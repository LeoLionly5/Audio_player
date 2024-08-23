import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Play/Pause/Replay button
class PlayPauseReplayButton extends StatelessWidget {
  /// Play/Pause/Replay button
  const PlayPauseReplayButton({super.key, required this.iconSize});
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final audioPlayer = GetIt.instance<AssetsAudioPlayer>();
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerState,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        // if (processingState == ProcessingState.loading ||
        //     processingState == ProcessingState.buffering) {
        //   return Container(
        //     margin: const EdgeInsets.all(8.0),
        //     width: iconSize,
        //     height: iconSize,
        //     child: const CircularProgressIndicator(),
        //   );
        // }
        if (playerState == PlayerState.pause) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            iconSize: iconSize,
            onPressed: audioPlayer.play,
          );
        } else if (playerState == PlayerState.play) {
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: iconSize,
            onPressed: audioPlayer.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            iconSize: iconSize,
            onPressed: () => audioPlayer.seek(Duration.zero),
          );
        }
      },
    );
  }
}
