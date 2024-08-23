class FolderModel {
  late String path;
  late String title;
  late int audioAmount;

  FolderModel(this.path, this.title, this.audioAmount);

  void increaseAudioAmount() {
    audioAmount += 1;
  }
}
