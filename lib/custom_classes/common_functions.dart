import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';

bool isAudio(String path) {
  final lowerCasePath = path.toLowerCase();
  return lowerCasePath.endsWith('.flac') ||
      lowerCasePath.endsWith('.mp3') ||
      lowerCasePath.endsWith('.wav');
}

Future<MediaItem> getMediaItem(String path) async {
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

  return getMediaItemfromJson(metadata);
}

MediaItem getMediaItemfromJson(dynamic map) => MediaItem(
      id: map['filePath'],
      title: map['metadata']['trackName'] ?? map['filePath'].split('/').last,
      album: map['metadata']['albumName'],
      artist: map['metadata']['trackArtistNames']?.split('/').join(', '),
      // TODO Uint8List 专辑封面转换为 artUri
      // artUri: map['albumArt'] != null
      //     ? Uri.dataFromBytes((map['albumArt'] as Uint8List).toList(),
      //         mimeType: 'image/jpeg')
      //     : null,
      // artUri: uint8ListToDataURI(map['albumArt'], 'image/jpeg'),
      genre: map['genre'],
      duration: Duration(
          milliseconds:
              parseDurationInteger(map['metadata']['trackDuration']) ?? 0),
      extras: {'albumArt': map['albumArt']},
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

// TODO Uint8List 专辑封面转换为 artUri 相关方法

// Uri? uint8ListToDataURI(Uint8List? uint8List, String mimeType) {
//   if (uint8List == null) return null;
//   final base64Data = base64Encode(uint8List);
//   return Uri.parse('data:$mimeType;base64,$base64Data');
// }
// final mimeType = 'image/jpeg'

// 保存专辑封面到本地
// Future<String> saveUint8ListToStorage(Uint8List data) async {
//   // final Directory tempDir = await getTemporaryDirectory();
//   final Directory directory = await getApplicationSupportDirectory();
//   final File tempFile = File('${directory.path}/temp_image.jpg');
//   await tempFile.writeAsBytes(data);
//   return tempFile.path;
// }

// Future<String> getFileContentUri(String filePath) async {
//   // 这里假设你使用了 FileProvider，并且已在 AndroidManifest.xml 中进行了配置
//   // 注意这里的 authority 应该是你在 AndroidManifest.xml 中定义的 FileProvider 的 authority
//   final String authority = 'your.fileprovider.authority';
//   final Uri contentUri = Uri.parse('content://$authority');
//   final String filePathEncoded = Uri.encodeFull(filePath);
//   return '$contentUri/$filePathEncoded';
// }

// void main() async {
//   // 示例 Uint8List 数据
//   final Uint8List imageData = Uint8List.fromList([/* your data */]);

//   // 将 Uint8List 写入文件
//   final String filePath = await saveUint8ListToStorage(imageData);

//   // 获取文件的 Content URI
//   final String contentUri = await getFileContentUri(filePath);

//   print('Content URI for the file: $contentUri');
// }
