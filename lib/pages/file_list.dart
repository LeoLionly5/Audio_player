import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
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
  List<UriAudioSource> playList = [];

  Future<void> _scanFiles(String folderPath, WidgetRef ref) async {
    playList.clear();
    Directory directory = Directory(folderPath);
    try {
      List<FileSystemEntity> entities = directory.listSync();

      for (FileSystemEntity entity in entities) {
        if (entity is File && isAudio(entity.path)) {
          final metaData = await MetadataRetriever.fromFile(File(entity.path));
          playList.add(AudioSource.file(entity.path, tag: metaData));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _onMusicClicked(int index) async {
    await widget.audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: playList),
        initialIndex: index);
    widget.audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _scanFiles(ref.watch(currentFolderPathProvider), ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // 等待加载指示器
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 8,
                  thickness: 2,
                );
              },
              itemCount: playList.length,
              itemBuilder: (context, index) {
                final metaData = playList[index].tag as Metadata;
                final trackName = (metaData.trackName ??
                        metaData.filePath?.split('/').last) ??
                    'Unknown name';
                final artistName =
                    metaData.trackArtistNames?.join(", ") ?? 'Unknown artist';
                final albumName = metaData.albumName ?? 'Unknown album';
                return ListTile(
                  leading: AlbumCover(
                    size: 40,
                    albumArt: metaData.albumArt,
                  ),
                  title: Text(trackName),
                  subtitle: Text('$artistName - $albumName'),
                  onTap: () => _onMusicClicked(index),
                );
              },
            );
          }
        });
  }
}
