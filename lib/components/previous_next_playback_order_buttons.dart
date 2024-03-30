import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

// 下一首音乐按钮
class PlaybackOrderButton extends ConsumerWidget {
  const PlaybackOrderButton(
      {Key? key, required this.player, required this.iconSize})
      : super(key: key);
  final double iconSize;
  final AudioPlayer player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<LoopMode>(
      stream: player.loopModeStream,
      builder: (context, snapshot) {
        final loopMode = snapshot.data ?? LoopMode.all;
        final icons = [
          Icon(Icons.repeat, color: IconTheme.of(context).color!),
          Icon(Icons.repeat_one, color: IconTheme.of(context).color!),
        ];
        const cycleModes = [
          LoopMode.all,
          LoopMode.one,
        ];
        final index = cycleModes.indexOf(loopMode);
        return IconButton(
          icon: icons[index],
          iconSize: iconSize,
          onPressed: () {
            player.setLoopMode(cycleModes[
                (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
          },
        );
      },
    );

    //     iconWidget = SvgPicture.asset(
    //       'assets/icons/shuffle_arrow.svg',
    //       colorFilter:
    //           ColorFilter.mode(IconTheme.of(context).color!, BlendMode.srcIn),
    //       height: iconSize / 1.3,
    //       width: iconSize / 2,
    //     );
  }
}

// 上一首音乐按钮
class PreviousButton extends ConsumerWidget {
  const PreviousButton({Key? key, required this.player, required this.iconSize})
      : super(key: key);
  final double iconSize;
  final AudioPlayer player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) => IconButton(
        icon: const Icon(Icons.skip_previous),
        iconSize: iconSize,
        onPressed: player.hasPrevious ? player.seekToPrevious : null,
      ),
    );
  }
}

// 下一首音乐按钮
class NextButton extends ConsumerWidget {
  const NextButton({Key? key, required this.player, required this.iconSize})
      : super(key: key);
  final double iconSize;
  final AudioPlayer player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) => IconButton(
        icon: const Icon(Icons.skip_next),
        iconSize: iconSize,
        onPressed: player.hasNext ? player.seekToNext : null,
      ),
    );
  }
}
