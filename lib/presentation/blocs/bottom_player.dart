import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/presentation/widgets/album_cover.dart';
import 'package:music_player/presentation/blocs/play_pause_replay_button.dart';
import 'package:music_player/presentation/pages/audio_player_bottom_sheet.dart';

class BottomPlayer extends ConsumerStatefulWidget {
  const BottomPlayer({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;

  @override
  BottomPlayerState createState() => BottomPlayerState();
}

class BottomPlayerState extends ConsumerState<BottomPlayer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: widget.audioPlayer.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        late bool hasSelectedAudio;
        if (state?.sequence.isEmpty ?? true) {
          hasSelectedAudio = false;
        } else {
          hasSelectedAudio = true;
        }
        final mediaItem = hasSelectedAudio
            ? state!.currentSource!.tag as MediaItem
            : const MediaItem(id: '', title: '');
        final audioName = mediaItem.title.isNotEmpty
            ? mediaItem.title
            : 'Please select an audio';
        return GestureDetector(
          onTap: hasSelectedAudio
              ? () {
                  // 点击底部播放栏，打开播放器bottom sheet
                  showModalBottomSheet(
                      // bottom sheet 解锁高度限制
                      isScrollControlled: true,
                      // 重新限制高度
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height / 1.3),
                      context: context,
                      builder: (_) {
                        return AudioPlayerBottomSheet(
                            audioPlayer: widget.audioPlayer);
                      });
                }
              : null,
          child: Container(
            height: 60, // 调整悬浮播放器的高度
            decoration: BoxDecoration(
              color: Colors.grey,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                ),
                // 音乐封面
                AlbumCover(
                  size: 40,
                  albumArt: mediaItem.extras?['albumArt'],
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(child: Text(audioName)),
                if (hasSelectedAudio)
                  // 播放/暂停/重播按钮
                  PlayPauseReplayButton(
                    player: widget.audioPlayer,
                    iconSize: 40,
                  ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
