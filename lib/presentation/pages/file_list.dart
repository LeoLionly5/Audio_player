import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_player/providers/providers.dart';
import 'package:audio_player/presentation/widgets/album_cover.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../utils/common_functions.dart';

/// Music file list page
class FileList extends ConsumerStatefulWidget {
  /// Music file list page
  const FileList({super.key, required this.navigateToPage});

  final Function(int) navigateToPage;

  @override
  ConsumerState<FileList> createState() => _FileListState();
}

class _FileListState extends ConsumerState<FileList> with WidgetsBindingObserver {
  final audioPlayer = GetIt.instance<AssetsAudioPlayer>();

  Future<Playlist?> _scanFiles(String folderPath, WidgetRef ref) async {
    final playList = Playlist(audios: []);

    Directory directory = Directory(folderPath);
    try {
      List<FileSystemEntity> entities = directory.listSync();
      for (FileSystemEntity entity in entities) {
        if (entity is File && isAudio(entity.path)) {
          final mediaMetas = await getMediaMetas(entity.path);
          playList.audios.add(Audio.file(entity.path, metas: mediaMetas));
        }
      }
      return playList;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  Future<void> _onMusicClicked(int index, Playlist playList) async {
    await audioPlayer.open(playList..startIndex = index,
        loopMode: LoopMode.playlist,
        showNotification: true,
        notificationSettings: const NotificationSettings(
          stopEnabled: false,
          // prevEnabled: false, //disable the previous button

          //and have a custom next action (will disable the default action)
          //         customStopAction: (player) async {
          //   print(
          //       "nextnextnextnextnextnextnextnextnextnextnextnextnextnextnextnextnext");
          //   const url = 'shyMusicPlayer'; // 这是本应用的 URL Scheme

          //   final AndroidIntent intent = const AndroidIntent(
          //     action: 'action_view',
          //     data:
          //         'com.example.audio_player', // replace com.example.app with your applicationId
          //   );
          //   await intent.launch();
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _scanFiles(ref.watch(currentFolderPathProvider), ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // 等待加载指示器
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('error when scan files');
          } else {
            final playList = snapshot.data!;
            return ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 8,
                  thickness: 2,
                );
              },
              itemCount: playList.audios.length,
              itemBuilder: (context, index) {
                final mediaMetas = playList.audios[index].metas;
                final trackName = mediaMetas.title;
                final artistName = mediaMetas.artist ?? 'Unknown artist';
                final albumName = mediaMetas.album ?? 'Unknown album';
                return ListTile(
                  leading: AlbumCover(
                    size: 40,
                    albumArt: mediaMetas.extra?['albumArt'],
                  ),
                  title: Text(trackName!),
                  subtitle: Text('$artistName - $albumName'),
                  onTap: () => _onMusicClicked(index, playList),
                );
              },
            );
          }
        });
  }
}
