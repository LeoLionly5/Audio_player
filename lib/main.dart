import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/pages/base_page.dart';

Future<void> main() async {
  // 后台播放以及通知栏控制
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
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
        title: 'SHY Music Player',
        // theme: ThemeData(
        //   // This is the theme of your application.
        //   //
        //   // TRY THIS: Try running your application with "flutter run". You'll see
        //   // the application has a blue toolbar. Then, without quitting the app,
        //   // try changing the seedColor in the colorScheme below to Colors.green
        //   // and then invoke "hot reload" (save your changes or press the "hot
        //   // reload" button in a Flutter-supported IDE, or press "r" if you used
        //   // the command line to start the app).
        //   //
        //   // Notice that the counter didn't reset back to zero; the application
        //   // state is not lost during the reload. To reset the state, use hot
        //   // restart instead.
        //   //
        //   // This works for code too, not just values: Most code changes can be
        //   // tested with just a hot reload.
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
        //   useMaterial3: true,
        // ),
        home: const BasePage(),
      ),
    );
  }
}
