String extensionOfString({required String fileName}) {
  return fileName.substring(fileName.lastIndexOf('.')).substring(0);
}

String replaceLast(
    {required String string,
    required String substring,
    required String replacement}) {
  int index = string.lastIndexOf(substring);
  if (index == -1) return string;
  return string.substring(0, index) +
      replacement +
      string.substring(index + substring.length);
}

String stringWithoutExtension(
    {required String fileName, required String extensionOfString}) {
  return replaceLast(
      string: fileName, substring: extensionOfString, replacement: "");
}
