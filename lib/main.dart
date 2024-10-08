import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_player/presentation/pages/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.instance.registerSingleton<AssetsAudioPlayer>(AssetsAudioPlayer());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        themeMode: ThemeMode.system,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark().copyWith(
          splashColor: Colors
              .transparent, // Set to transparent color to prevent gray effect after clicking ListTile
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.greenAccent,
            brightness: Brightness.dark,
          ),
        ),
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
