import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';

// 播放/暂停/重播按钮
class PlayPauseReplayButton extends StatelessWidget {
  const PlayPauseReplayButton(
      {Key? key, required this.player, required this.iconSize})
      : super(key: key);
  final double iconSize;
  final AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: iconSize,
            height: iconSize,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            iconSize: iconSize,
            onPressed: player.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: iconSize,
            onPressed: player.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            iconSize: iconSize,
            onPressed: () => player.seek(Duration.zero),
          );
        }
      },
    );
  }
}
