class FolderEntity {
  late String path;
  late String title;
  late int audioAmount;

  FolderEntity(this.path, this.title, this.audioAmount);

  void increaseAudioAmount() {
    audioAmount += 1;
  }
}
