bool isAudio(String path) {
  final lowerCasePath = path.toLowerCase();
  return lowerCasePath.endsWith('.flac') ||
      lowerCasePath.endsWith('.mp3') ||
      lowerCasePath.endsWith('.wav');
}
