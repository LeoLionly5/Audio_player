import 'dart:async';
import 'dart:io';

import 'package:audio_player/data/models/folder.dart';
import 'package:audio_player/domain/providers/providers.dart';
import 'package:audio_player/domain/common_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Folder list page containing music files
class FolderList extends ConsumerStatefulWidget {
  /// Folder list page containing music files
  const FolderList({super.key, required this.navigateToPage});

  final Function(int) navigateToPage;

  @override
  FolderListState createState() => FolderListState();
}

class FolderListState extends ConsumerState<FolderList> {
  Map<String, FolderModel> audioFolderPaths = {};
  String selectedFolderPath = '';
  bool isScanning = false;

  // Check storage permissions
  Future<void> _checkPermissionAndScanMusic() async {
    if (await Permission.storage.request().isGranted) {
      _scanMusic();
    } else {
      if (kDebugMode) {
        print('no permission');
      }
    }
  }

  // Scan music and list parent folders
  void _scanMusic() async {
    Map<String, FolderModel> currentMusicFolders = {};
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

  // After clicking on the folder, update the providers and navigate to the file list page
  void _onFolderClicked(String folderPath) {
    // Update the clicked folder path to the provider
    ref.read(currentFolderPathProvider.notifier).update((state) => folderPath);
    // Add the current page to the navigation history
    ref.read(navigationHistoryProvider.notifier).update((state) {
      return [...state, 0];
    });
    // Navigate to the file list page
    // TODO Can define another value, but not 1
    widget.navigateToPage(1);
  }

  @override
  void initState() {
    super.initState();
    _loadFolderPath();
  }

  // Load saved data
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

  // Save data
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

// Used for the compute() method, so this method cannot be placed inside any class, only top-level
Future<Map<String, FolderModel>> _scanMusicInBackground(String rootPath) async {
  Map<String, FolderModel> currentAudioFolders = {};
  _scanDirectory(Directory(rootPath).listSync(), currentAudioFolders);
  return currentAudioFolders;
}

// Recursive scanning of folders
void _scanDirectory(List<FileSystemEntity> entities,
    Map<String, FolderModel> currentMusicFolders) {
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
          currentMusicFolders.putIfAbsent(parentFolder,
              () => FolderModel(parentFolder, parentFolder.split('/').last, 1));
        }
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
