import 'package:flutter/widgets.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/components/album_cover.dart';
import 'package:music_player/components/control_buttons.dart';
import 'package:music_player/components/seek_bar.dart';
import 'package:music_player/custom_classes/custom_data_classes.dart';

import 'package:rxdart/rxdart.dart';

class AudioPlayerBottomSheet extends StatefulWidget {
  const AudioPlayerBottomSheet({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;

  @override
  State<AudioPlayerBottomSheet> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayerBottomSheet>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      widget.audioPlayer.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest2<Duration, Duration?, PositionData>(
          widget.audioPlayer.positionStream,
          widget.audioPlayer.durationStream,
          (position, duration) =>
              PositionData(position, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: widget.audioPlayer.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final mediaItem = state!.currentSource!.tag as MediaItem;
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Icon(Icons.keyboard_arrow_down),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 专辑封面
                  Center(
                    child: AlbumCover(
                      size: 200,
                      albumArt: mediaItem.extras?['albumArt'],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // 歌名
                  Text(mediaItem.title.isNotEmpty
                      ? mediaItem.title
                      : 'Unknown track name'),
                  // 作者
                  const SizedBox(
                    height: 10,
                  ),
                  // TODO 美化
                  Text(mediaItem.album ?? 'Unknown album'),
                  // 作者
                  const SizedBox(
                    height: 10,
                  ),
                  // TODO 美化
                  Text(mediaItem.artist ?? 'Unknown artist'),
                  // 按钮组
                  ControlButtons(audioPlayer: widget.audioPlayer),
                  // 播放进度条
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        onChangeEnd: widget.audioPlayer.seek,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
