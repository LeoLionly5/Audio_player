import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/services.dart';

bool isAudio(String path) {
  final lowerCasePath = path.toLowerCase();
  return lowerCasePath.endsWith('.flac') ||
      lowerCasePath.endsWith('.mp3') ||
      lowerCasePath.endsWith('.wav') ||
      lowerCasePath.endsWith('.m4a');
}

Future<Metas> getMediaMetas(String path) async {
  // MediaItem({
  //   required this.id,
  //   required this.title,
  //   this.album,
  //   this.artist,
  //   this.genre,
  //   this.duration,
  //   this.artUri,
  //   this.artHeaders,
  //   this.playable = true,
  //   this.displayTitle,
  //   this.displaySubtitle,
  //   this.displayDescription,
  //   this.rating,
  //   this.extras,
  // });
  var metadata =
      await const MethodChannel('flutter_media_metadata').invokeMethod(
    'MetadataRetriever',
    {
      'filePath': path,
    },
  );
  metadata['filePath'] = path;

  return getMediaMetasfromJson(metadata);
}

Metas getMediaMetasfromJson(dynamic map) => Metas(
      id: map['filePath'],
      title: map['metadata']['trackName'] ?? map['filePath'].split('/').last,
      artist: map['metadata']['trackArtistNames']?.split('/').join(', '),
      album: map['metadata']['albumName'],
      extra: {'albumArt': map['albumArt']},
    );

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
