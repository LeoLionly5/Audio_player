import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentFolderPathProvider = StateProvider<String>((ref) => '');

final navigationHistoryProvider = StateProvider<List<int>>((ref) => [0]);
