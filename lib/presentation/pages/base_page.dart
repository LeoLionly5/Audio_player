import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/presentation/blocs/bottom_player.dart';
import 'package:music_player/presentation/pages/file_list.dart';
import 'package:music_player/presentation/pages/folder_list.dart';
import 'package:music_player/presentation/providers/providers.dart';

// 带有底部播放器的总页面，所有其他页面都被包括在此页面之内
class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState extends ConsumerState<BasePage> {
  final audioPlayer = AudioPlayer();

  int _currentPageIndex = 0;

  // 用于切换文件夹页面和文件页面的导航方法
  void _navigateToPage(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

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
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          // 当点击系统返回按钮时，执行_navigateToPage返回上一个页面
          List<int> navigationHistory = ref.watch(navigationHistoryProvider);
          if (navigationHistory.isNotEmpty) {
            _navigateToPage(
                navigationHistory.removeAt(navigationHistory.length - 1));
          } else {
            return;
          }
          // 返回false以阻止默认的返回按钮行为
          // return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('SHY Music Player')),
          ),
          body: IndexedStack(
            index: _currentPageIndex,
            children: <Widget>[
              FolderList(navigateToPage: _navigateToPage),
              FileList(
                  navigateToPage: _navigateToPage, audioPlayer: audioPlayer),
            ],
          ),
          bottomNavigationBar: BottomPlayer(audioPlayer: audioPlayer),
        ));
  }
}
