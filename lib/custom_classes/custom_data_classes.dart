class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}

class FolderItem {
  late String path;
  late String title;
  late int audioAmout;

  FolderItem(this.path, this.title, this.audioAmout);

  void increaseAudioAmount() {
    audioAmout += 1;
  }
}
