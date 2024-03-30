import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/components/play_pause_replay_button.dart';
import 'package:music_player/components/previous_next_playback_order_buttons.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 调整音量，根系统音量不同步，暂时移除
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
        // 播放速度调节
        StreamBuilder<double>(
          stream: audioPlayer.speedStream,
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
                value: audioPlayer.speed,
                stream: audioPlayer.speedStream,
                onChanged: audioPlayer.setSpeed,
              );
            },
          ),
        ),
        PreviousButton(
          player: audioPlayer,
          iconSize: 40,
        ),
        PlayPauseReplayButton(
          player: audioPlayer,
          iconSize: 64,
        ),
        NextButton(
          player: audioPlayer,
          iconSize: 40,
        ),
        PlaybackOrderButton(
          player: audioPlayer,
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
