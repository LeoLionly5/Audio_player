import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/presentation/pages/base_page.dart';

Future<void> main() async {
  // 后台播放以及通知栏控制
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  WidgetsFlutterBinding.ensureInitialized();
  GetIt.instance.registerSingleton<AudioPlayer>(AudioPlayer());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        themeMode: ThemeMode.system, // 设置主题模式为跟随系统
        theme: ThemeData.light(), // 浅色主题
        darkTheme: ThemeData.dark().copyWith(
          splashColor: Colors.transparent, // 设置为透明色，防止点击ListTile后出现灰色效果
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.greenAccent,
            brightness: Brightness.dark,
          ),
        ), // 深色主题
        title: 'CZ Music Player',
        home: const BasePage(),
      ),
    );
  }
}
