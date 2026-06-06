import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

// 播放顺序按钮
class PlaybackOrderButton extends ConsumerWidget {
  const PlaybackOrderButton({super.key, required this.iconSize});
  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioPlayer = GetIt.instance<AudioPlayer>();
    return StreamBuilder<LoopMode>(
      stream: audioPlayer.loopModeStream,
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
            audioPlayer
                .setLoopMode(cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
          },
        );
      },
    );
    // TODO: 乱序
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
  const PreviousButton({super.key, required this.iconSize});
  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioPlayer = GetIt.instance<AudioPlayer>();

    return StreamBuilder<SequenceState?>(
      stream: audioPlayer.sequenceStateStream,
      builder: (context, snapshot) => IconButton(
        icon: const Icon(Icons.skip_previous),
        iconSize: iconSize,
        onPressed: audioPlayer.hasPrevious ? audioPlayer.seekToPrevious : null,
      ),
    );
  }
}

// 下一首音乐按钮
class NextButton extends ConsumerWidget {
  const NextButton({super.key, required this.iconSize});
  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioPlayer = GetIt.instance<AudioPlayer>();
    // player.loopMode
    return StreamBuilder<SequenceState?>(
      stream: audioPlayer.sequenceStateStream,
      builder: (context, snapshot) => IconButton(
        icon: const Icon(Icons.skip_next),
        iconSize: iconSize,
        onPressed: audioPlayer.hasNext ? audioPlayer.seekToNext : null,
      ),
    );
  }
}
