import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/core/router/go_router.dart';

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
    final router = goRouter;

    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        themeMode: ThemeMode.system,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark().copyWith(
          splashColor: Colors.transparent,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.greenAccent,
            brightness: Brightness.dark,
          ),
        ),
        title: 'CZ Music Player',
      ),
    );
  }
}
