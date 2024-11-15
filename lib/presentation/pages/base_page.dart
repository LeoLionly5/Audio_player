import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_player/presentation/widgets/bottom_player.dart';
import 'package:audio_player/presentation/pages/file_list.dart';
import 'package:audio_player/presentation/pages/folder_list.dart';
import 'package:audio_player/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

/// The main page with the bottom player, all other pages are included in this page
class BasePage extends ConsumerStatefulWidget {
  /// The main page with the bottom player, all other pages are included in this page
  const BasePage({super.key});

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState extends ConsumerState<BasePage> {
  final audioPlayer = GetIt.instance<AssetsAudioPlayer>();

  int _currentPageIndex = 0;

  // Navigation method for switching between folder pages and file pages
  void _navigateToPage(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    audioPlayer.onErrorDo = (handler) {
      // It shows network error from assets audio player package, when some of the audio files
      if (handler.error.errorType == AssetsAudioPlayerErrorType.Network) {
        if (audioPlayer.loopMode.value == LoopMode.playlist) {
          handler.player.next();
        } else {
          handler.player.stop();
          handler.player.seek(Duration.zero);
          handler.player.play();
        }
      }
      // TODO log the error
    };
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
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          // When the system back button is clicked, execute _navigateToPage to return to the previous page
          List<int> navigationHistory = ref.watch(navigationHistoryProvider);
          if (navigationHistory.isNotEmpty) {
            _navigateToPage(navigationHistory.removeAt(navigationHistory.length - 1));
          } else {
            return;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('SHY Music Player')),
          ),
          body: IndexedStack(
            index: _currentPageIndex,
            children: <Widget>[
              FolderList(navigateToPage: _navigateToPage),
              FileList(navigateToPage: _navigateToPage),
            ],
          ),
          bottomNavigationBar: const BottomPlayer(),
        ));
  }
}
