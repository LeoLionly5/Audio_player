import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_player_flutter_test/presentation/blocs/bottom_player.dart';
import 'package:audio_player_flutter_test/presentation/blocs/play_pause_replay_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/streams.dart';

class MockAssetsAudioPlayer extends Mock implements AssetsAudioPlayer {}

void main() {
  testWidgets('BottomPlayer when there is no music file selected',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: BottomPlayer(audioPlayer: AssetsAudioPlayer())));

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
