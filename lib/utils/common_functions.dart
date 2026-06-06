import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';

bool isAudio(String path) {
  final lowerCasePath = path.toLowerCase();
  return lowerCasePath.endsWith('.flac') ||
      lowerCasePath.endsWith('.mp3') ||
      lowerCasePath.endsWith('.wav') ||
      lowerCasePath.endsWith('.m4a');
}

Future<MediaItem> getMediaItem(String trackPath) async {
  try {
    final audioMetadataTag = await getMeta(trackPath);
    return MediaItem(
      id: trackPath,
      title: audioMetadataTag?['title'] ?? trackPath.split('/').last,
      album: audioMetadataTag?['album'],
      artist: audioMetadataTag?['artist'],
      extras: {
        'albumArt': audioMetadataTag?['albumArt'] != null
            ? (audioMetadataTag?['albumArt'] as Uint8List)
            : null
      },
    );
  } catch (e) {
    return MediaItem(
      id: trackPath,
      title: trackPath.split('/').last,
    );
  }
}

const channel = MethodChannel('audio_meta');

Future<Map?> getMeta(String path) async {
  final result = await channel.invokeMethod('getMeta', path);
  return Map<String, dynamic>.from(result);
}

int? parseDurationInteger(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  } else if (value is String) {
    try {
      try {
        return int.parse(value);
      } catch (_) {
        return int.parse(value.split('/').first);
      }
    } catch (_) {}
  }
  return null;
}
