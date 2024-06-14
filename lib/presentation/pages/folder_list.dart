import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_player/domain/entities/folder.dart';
import 'package:music_player/utils/common_functions.dart';
import 'package:music_player/presentation/providers/providers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 包含音乐文件的文件夹列表页面
class FolderList extends ConsumerStatefulWidget {
  const FolderList({super.key, required this.navigateToPage});

  // 导航方法
  final Function(int) navigateToPage;

  @override
  FolderListState createState() => FolderListState();
}

class FolderListState extends ConsumerState<FolderList> {
  Map<String, FolderEntity> audioFolderPaths = {};
  String selectedFolderPath = '';
  bool isScanning = false;

  // 检查储存权限
  Future<void> _checkPermissionAndScanMusic() async {
    if (await Permission.storage.request().isGranted) {
      _scanMusic();
    } else {
      if (kDebugMode) {
        print('no permission');
      }
    }
  }

  // 扫描音乐并列出父文件夹
  void _scanMusic() async {
    Map<String, FolderEntity> currentMusicFolders = {};
    try {
      setState(() {
        isScanning = true;
      });
      var searchPath = selectedFolderPath.isNotEmpty
          ? selectedFolderPath
          : (await ExternalPath.getExternalStorageDirectories()).first;
      currentMusicFolders = await compute(_scanMusicInBackground, searchPath);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      setState(() {
        isScanning = false;
        audioFolderPaths = currentMusicFolders;
      });
    }
  }

  // 点击文件夹后，更新providers，导航到文件列表页面
  void _onFolderClicked(String folderPath) {
    // 将点击的文件夹路径更新到provider
    ref.read(currentFolderPathProvider.notifier).update((state) => folderPath);
    // 将当前页面添加到导航历史
    ref.read(navigationHistoryProvider.notifier).update((state) {
      return [...state, 0];
    });
    // 导航到文件列表页面
    // TODO 可以用其他的值，而不是1
    widget.navigateToPage(1);
  }

  @override
  void initState() {
    super.initState();
    _loadFolderPath();
  }

  // 加载保存的数据
  Future<void> _loadFolderPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString('folderPath');
    if (savedPath != null && savedPath.isNotEmpty) {
      setState(() {
        selectedFolderPath = savedPath;
      });
      _scanMusic();
    }
  }

  // 保存数据
  Future<void> _saveFolderPath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('folderPath', path);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return isScanning
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text('Scanning $selectedFolderPath'),
              ],
            ),
          )
        : audioFolderPaths.isNotEmpty
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: screenWidth / 30),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            selectedFolderPath =
                                (await _openFileExplorer(context)) ?? '';
                            await _checkPermissionAndScanMusic();
                            await _saveFolderPath(selectedFolderPath);
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.refresh),
                              SizedBox(width: screenWidth / 20),
                              Expanded(
                                child: Text(selectedFolderPath.isNotEmpty
                                    ? selectedFolderPath
                                    : 'Please select a folder to scan'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth / 30),
                    ],
                  ),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 0,
                          thickness: 2,
                        );
                      },
                      itemCount: audioFolderPaths.length,
                      itemBuilder: (context, index) {
                        final audioAmount =
                            audioFolderPaths.values.toList()[index].audioAmount;
                        return ListTile(
                          title: Text(
                              audioFolderPaths.values.toList()[index].title),
                          subtitle: Text(
                              '${audioFolderPaths.values.toList()[index].audioAmount} ${audioAmount > 1 ? 'songs in ' : 'song in '} ${audioFolderPaths.values.toList()[index].path}'),
                          onTap: () => _onFolderClicked(
                              audioFolderPaths.values.toList()[index].path),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        selectedFolderPath =
                            (await _openFileExplorer(context)) ?? '';
                        await _checkPermissionAndScanMusic();
                        await _saveFolderPath(selectedFolderPath);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth / 30),
                        child: Text(selectedFolderPath.isNotEmpty
                            ? selectedFolderPath
                            : 'Please select a folder to scan'),
                      ),
                    ),
                  ],
                ),
              );
  }

  Future<String?> _openFileExplorer(BuildContext context) async {
    String? filePath = await FilePicker.platform.getDirectoryPath();
    return filePath;
  }
}

// 用于compute()方法，所以此方法不能放入任何类的内部，只能top-level
Future<Map<String, FolderEntity>> _scanMusicInBackground(
    String rootPath) async {
  Map<String, FolderEntity> currentAudioFolders = {};
  _scanDirectory(Directory(rootPath).listSync(), currentAudioFolders);
  return currentAudioFolders;
}

// 递归扫描文件夹
void _scanDirectory(List<FileSystemEntity> entities,
    Map<String, FolderEntity> currentMusicFolders) {
  try {
    for (FileSystemEntity entity in entities) {
      if (entity is Directory) {
        // 递归扫描子文件夹
        _scanDirectory(entity.listSync(), currentMusicFolders);
      } else if (entity is File && isAudio(entity.path)) {
        // 获取父目录路径
        String parentFolder = entity.parent.path;
        // 将父文件夹路径添加到列表中，仅当该路径不在列表中时才添加
        if (currentMusicFolders.containsKey(parentFolder)) {
          currentMusicFolders.update(
              parentFolder, (folderItem) => folderItem..increaseAudioAmount());
        } else {
          currentMusicFolders.putIfAbsent(
              parentFolder,
              () =>
                  FolderEntity(parentFolder, parentFolder.split('/').last, 1));
        }
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
