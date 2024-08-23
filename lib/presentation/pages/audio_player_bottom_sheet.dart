import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_player/data/models/audio_position.dart';
import 'package:audio_player/presentation/widgets/control_buttons.dart';
import 'package:audio_player/presentation/widgets/seek_bar.dart';
import 'package:audio_player/presentation/widgets/album_cover.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

/// The bottom sheet which includes the track details and playing controls
class AudioPlayerBottomSheet extends StatefulWidget {
  /// The bottom sheet which includes the track details and playing controls
  const AudioPlayerBottomSheet({super.key});

  @override
  State<AudioPlayerBottomSheet> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayerBottomSheet>
    with WidgetsBindingObserver {
  Widget _bottomSheetWidget = const SizedBox();

  final audioPlayer = GetIt.instance<AssetsAudioPlayer>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      audioPlayer.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 2 streams of interest into one.
  Stream<AudioPositionModel> get _positionDataStream =>
      Rx.combineLatest2<Duration, Playing?, AudioPositionModel>(
          audioPlayer.currentPosition,
          audioPlayer.current,
          (position, playing) => AudioPositionModel(position, playing));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayingAudio?>(
      stream: audioPlayer.onReadyToPlay,
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
                  ControlButtons(),
                  // Seek bar
                  StreamBuilder<AudioPositionModel>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                        duration: positionData?.playing?.audio.duration ??
                            Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        onChangeEnd: audioPlayer.seek,
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
