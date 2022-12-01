String getFileNameExtension({required String fileName}) {
  int indexOfLastDot = fileName.lastIndexOf('.');
  if (indexOfLastDot == -1) {
    return '';
  } else {
    String fileExt = fileName.substring(indexOfLastDot).toLowerCase();
    return fileExt;
  }
}
