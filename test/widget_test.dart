import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_player/presentation/widgets/bottom_player.dart';
import 'package:audio_player/presentation/widgets/play_pause_replay_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

class MockAssetsAudioPlayer extends Mock implements AssetsAudioPlayer {}

void main() {
  setUp(() async {
    // Make sure the instance is cleared before each test.
    await GetIt.I.reset();
  });
  testWidgets('BottomPlayer when there is no music file selected',
      (WidgetTester tester) async {
    GetIt.instance.registerSingleton<AssetsAudioPlayer>(AssetsAudioPlayer());
    await tester.pumpWidget(const MaterialApp(home: BottomPlayer()));

    expect(find.text('Please select an audio'), findsOneWidget);
    expect(find.byIcon(Icons.music_note), findsOneWidget);
    expect(
        find.byWidgetPredicate(
            (Widget widget) => widget is PlayPauseReplayButton),
        findsNothing);
  });

  // testWidgets('BottomPlayer when there is one music file selected',
  //     (WidgetTester tester) async {
  //   final player = MockAssetsAudioPlayer();
  //   final playList = Playlist(audios: []);

  //   final audio = Audio.network(
  //     "/assets/musics/test1.flac",
  //     metas: Metas(
  //       title: "test1 title",
  //       artist: "test1 artist",
  //       album: "test1 album",
  //     ),
  //   );

  //   playList.audios.add(audio);

  //   // Mock the current stream
  //   final currentAudio =
  //       PlayingAudio(audio: audio, duration: const Duration(minutes: 1));

  //   final playing = Playing(
  //       audio: currentAudio,
  //       index: 0,
  //       hasNext: false,
  //       playlist: ReadingPlaylist(audios: [audio]));

  //   when(player.current)
  //       .thenAnswer((_) => Stream<Playing?>.value(playing).shareValue());

  //   // Mock the open method to complete immediately
  //   when(player.open(playList..startIndex = 0, loopMode: LoopMode.playlist))
  //       .thenAnswer((_) async {});

  //   await tester
  //       .pumpWidget(MaterialApp(home: BottomPlayer(audioPlayer: player)));

  //   await player.open(playList..startIndex = 0, loopMode: LoopMode.playlist);

  //   await tester.pump();

  //   expect(find.text('Please select an audio'), findsNothing);
  //   expect(find.byIcon(Icons.music_note), findsOneWidget);
  //   expect(
  //       find.byWidgetPredicate(
  //           (Widget widget) => widget is PlayPauseReplayButton),
  //       findsOneWidget);
  //   // expect(player.open(playList..startIndex = 0, loopMode: LoopMode.playlist),
  //   //     completes);
  // });
}
