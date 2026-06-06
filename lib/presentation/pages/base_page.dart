import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/presentation/widgets/bottom_player.dart';

// 带有底部播放器的总页面，所有其他页面都被包括在此页面之内
class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState extends ConsumerState<BasePage> {
  final audioPlayer = GetIt.instance<AudioPlayer>();

  @override
  void initState() {
    super.initState();
    audioPlayer.setLoopMode(LoopMode.all);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('CZ Music Player')),
          ),
          bottomNavigationBar: const BottomPlayer(),
        ));
  }
}
