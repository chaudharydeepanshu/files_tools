import 'dart:io';
import 'package:path/path.dart' as PathLibrary;

String getFileNameFromFilePath(String filePath) {
  File file = File(filePath);
  String fileName = PathLibrary.basename(file.path);
  return fileName;
}
