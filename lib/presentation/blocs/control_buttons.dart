import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_player_flutter_test/presentation/blocs/play_pause_replay_button.dart';
import 'package:audio_player_flutter_test/presentation/blocs/previous_next_playback_order_buttons.dart';
import 'package:flutter/material.dart';

/// Control buttons, which contains Adjust speed, previous, play/pause, next, playback order
class ControlButtons extends StatelessWidget {
  /// Control buttons, which contains Adjust speed, previous, play/pause, next, playback order
  const ControlButtons({super.key, required this.audioPlayer});

  final AssetsAudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Adjust the volume, the root system volume is out of sync, temporarily removed
        // IconButton(
        //   icon: const Icon(Icons.volume_up),
        //   onPressed: () {
        //     showSliderDialog(
        //       context: context,
        //       title: "Adjust volume",
        //       divisions: 10,
        //       min: 0.0,
        //       max: 1.0,
        //       value: player.volume,
        //       stream: player.volumeStream,
        //       onChanged: player.setVolume,
        //     );
        //   },
        // ),
        // Playback speed adjustment
        StreamBuilder<double>(
          stream: audioPlayer.playSpeed,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              _showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: snapshot.data ?? 0,
                stream: audioPlayer.playSpeed,
                onChanged: audioPlayer.setPlaySpeed,
              );
            },
          ),
        ),
        PreviousButton(
          player: audioPlayer,
          // TODO Better size control
          iconSize: 40,
        ),
        PlayPauseReplayButton(
          player: audioPlayer,
          // TODO Better size control
          iconSize: 64,
        ),
        NextButton(
          player: audioPlayer,
          // TODO Better size control
          iconSize: 40,
        ),
        PlaybackOrderButton(
          player: audioPlayer,
          // TODO Better size control
          iconSize: 30,
        )
      ],
    );
  }

  void _showSliderDialog({
    required BuildContext context,
    required String title,
    required int divisions,
    required double min,
    required double max,
    String valueSuffix = '',
    // TODO: Replace these two by ValueStream.
    required double value,
    required Stream<double> stream,
    required ValueChanged<double> onChanged,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: StreamBuilder<double>(
          stream: stream,
          builder: (context, snapshot) => SizedBox(
            height: 100.0,
            child: Column(
              children: [
                Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                    style: const TextStyle(
                        fontFamily: 'Fixed',
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0)),
                Slider(
                  divisions: divisions,
                  min: min,
                  max: max,
                  value: snapshot.data ?? value,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
