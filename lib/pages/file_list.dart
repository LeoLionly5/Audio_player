import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/components/album_cover.dart';
import 'package:music_player/providers.dart';

import '../custom_classes/common_functions.dart';

// 音乐文件列表页面
class FileList extends ConsumerStatefulWidget {
  const FileList(
      {super.key, required this.navigateToPage, required this.audioPlayer});

  final Function(int) navigateToPage;
  final AudioPlayer audioPlayer;

  @override
  ConsumerState<FileList> createState() => _FileListState();
}

class _FileListState extends ConsumerState<FileList>
    with WidgetsBindingObserver {
  Future<List<UriAudioSource>?> _scanFiles(
      String folderPath, WidgetRef ref) async {
    List<UriAudioSource> playList = [];
    // playList.clear();
    Directory directory = Directory(folderPath);
    try {
      List<FileSystemEntity> entities = directory.listSync();
      for (FileSystemEntity entity in entities) {
        if (entity is File && isAudio(entity.path)) {
          final mediaItem = await getMediaItem(entity.path);
          playList.add(AudioSource.file(entity.path, tag: mediaItem));
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

  Future<void> _onMusicClicked(int index, List<UriAudioSource> playList) async {
    await widget.audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: playList),
        initialIndex: index,
        initialPosition: Duration.zero);
    widget.audioPlayer.play();
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
              itemCount: playList.length,
              itemBuilder: (context, index) {
                final mediaItem = playList[index].tag as MediaItem;
                final trackName = mediaItem.title;
                final artistName = mediaItem.artist ?? 'Unknown artist';
                final albumName = mediaItem.album ?? 'Unknown album';
                return ListTile(
                  leading: AlbumCover(
                    size: 40,
                    albumArt: mediaItem.extras?['albumArt'],
                  ),
                  title: Text(trackName),
                  subtitle: Text('$artistName - $albumName'),
                  onTap: () => _onMusicClicked(index, playList),
                );
              },
            );
          }
        });
  }
}
