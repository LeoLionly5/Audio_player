import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Play back order button
class PlaybackOrderButton extends StatelessWidget {
  /// Play back order button
  const PlaybackOrderButton({super.key, required this.iconSize});
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final audioPlayer = GetIt.instance<AssetsAudioPlayer>();
    return StreamBuilder<LoopMode>(
      stream: audioPlayer.loopMode,
      builder: (context, snapshot) {
        final loopMode = snapshot.data ?? LoopMode.playlist;
        final icons = [
          Icon(Icons.repeat, color: IconTheme.of(context).color!),
          Icon(Icons.repeat_one, color: IconTheme.of(context).color!),
        ];
        const cycleModes = [
          LoopMode.playlist,
          LoopMode.single,
        ];
        final index = cycleModes.indexOf(loopMode);
        return IconButton(
          icon: icons[index],
          iconSize: iconSize,
          onPressed: () {
            audioPlayer.setLoopMode(cycleModes[
                (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
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
class PreviousButton extends StatelessWidget {
  const PreviousButton({super.key, required this.iconSize});
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final audioPlayer = GetIt.instance<AssetsAudioPlayer>();
    // return StreamBuilder<SequenceState?>(
    //   stream: player.sequenceStateStream,
    //   builder: (context, snapshot) => IconButton(
    //     icon: const Icon(Icons.skip_previous),
    //     iconSize: iconSize,
    //     onPressed: player.hasPrevious ? player.seekToPrevious : null,
    //   ),
    // );
    return IconButton(
      icon: const Icon(Icons.skip_previous),
      iconSize: iconSize,
      onPressed: audioPlayer.previous,
      // onPressed: () => player.seek(Duration.zero, index: 0),
      // onPressed: () => player.seek(Duration.zero, index: 3),
    );
  }
}

// 下一首音乐按钮
class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.iconSize});
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final audioPlayer = GetIt.instance<AssetsAudioPlayer>();
    // player.loopMode
    // return StreamBuilder<SequenceState?>(
    //   stream: player.sequenceStateStream,
    //   builder: (context, snapshot) => IconButton(
    //     icon: const Icon(Icons.skip_next),
    //     iconSize: iconSize,
    //     onPressed: player.n .hasNext ? player.next() : null,
    //     // onPressed: () => player.seek(Duration.zero, index: 0),
    //     // onPressed: () => player.seek(Duration.zero, index: 3),
    //   ),
    // );
    return IconButton(
      icon: const Icon(Icons.skip_next),
      iconSize: iconSize,
      onPressed: audioPlayer.next,
      // onPressed: () => player.seek(Duration.zero, index: 0),
      // onPressed: () => player.seek(Duration.zero, index: 3),
    );
  }
}
