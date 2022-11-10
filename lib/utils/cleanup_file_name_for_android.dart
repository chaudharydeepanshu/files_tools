String getCleanedUpFileName(String fileName) {
  return fileName.replaceAll(RegExp("[\\\\/:*?\"<>|\\[\\]]"), "_");
}
