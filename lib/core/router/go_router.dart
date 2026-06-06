import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/presentation/pages/file_list.dart';
import 'package:music_player/presentation/pages/folder_list.dart';
import 'package:music_player/presentation/widgets/bottom_player.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(title: const Center(child: Text('CZ Music Player'))),
          body: child,
          bottomNavigationBar: const BottomPlayer(),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'folders',
          builder: (context, state) => const FolderList(),
        ),
        GoRoute(
          path: '/files',
          name: 'files',
          builder: (context, state) => const FileList(),
        ),
      ],
    ),
  ],
);
