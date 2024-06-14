import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentFolderPathProvider = StateProvider<String>((ref) => '');

final navigationHistoryProvider = StateProvider<List<int>>((ref) => [0]);

final currentAudioIndexProvider = StateProvider<int>((ref) => 0);

final currentAudioIndexListProvider = StateProvider<List<int>>((ref) => [0]);
