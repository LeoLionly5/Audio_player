import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Album cover of the music file
class AlbumCover extends StatelessWidget {
  /// Album cover of the music file
  const AlbumCover({super.key, required this.size, this.albumArt});

  final double size;
  final Uint8List? albumArt;

  @override
  Widget build(BuildContext context) {
    return albumArt != null
        ? SizedBox(
            height: size,
            width: size,
            child: Center(
              child: Image.memory(albumArt!),
            ),
          )
        : Container(
            height: size,
            width: size,
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Icon(Icons.music_note, size: size / 2),
          );
  }
}
