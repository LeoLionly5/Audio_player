import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_player_flutter_test/domain/entities/audio_position.dart';
import 'package:audio_player_flutter_test/presentation/blocs/control_buttons.dart';
import 'package:audio_player_flutter_test/presentation/blocs/seek_bar.dart';
import 'package:audio_player_flutter_test/presentation/widgets/album_cover.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerBottomSheet extends StatefulWidget {
  const AudioPlayerBottomSheet({super.key, required this.audioPlayer});

  final AssetsAudioPlayer audioPlayer;

  @override
  State<AudioPlayerBottomSheet> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayerBottomSheet>
    with WidgetsBindingObserver {
  Widget _bottomSheetWidget = const SizedBox();

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
  /// feature of rx_dart to combine the 2 streams of interest into one.
  Stream<AudioPositionEntity> get _positionDataStream =>
      Rx.combineLatest2<Duration, Playing?, AudioPositionEntity>(
          widget.audioPlayer.currentPosition,
          widget.audioPlayer.current,
          (position, playing) => AudioPositionEntity(position, playing));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayingAudio?>(
      stream: widget.audioPlayer.onReadyToPlay,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.assetAudioPath.isEmpty ?? true) {
          return _bottomSheetWidget;
        }
        final mediaMetas = state!.audio.metas;
        _bottomSheetWidget = Column(
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
                  Center(
                    child: AlbumCover(
                      size: 200,
                      albumArt: mediaMetas.extra?['albumArt'],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Track name
                  Text(mediaMetas.title ?? 'Unknown track name'),
                  const SizedBox(
                    height: 10,
                  ),
                  // TODO beautify
                  Text(mediaMetas.album ?? 'Unknown album'),
                  const SizedBox(
                    height: 10,
                  ),
                  // TODO beautify
                  Text(mediaMetas.artist ?? 'Unknown artist'),
                  ControlButtons(audioPlayer: widget.audioPlayer),
                  // Seek bar
                  StreamBuilder<AudioPositionEntity>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                        duration: positionData?.playing?.audio.duration ??
                            Duration.zero,
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
        return _bottomSheetWidget;
      },
    );
  }
}
