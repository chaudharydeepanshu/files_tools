import 'dart:io';
import 'package:path/path.dart' as path_library;

String getFileNameFromFilePath(String filePath) {
  File file = File(filePath);
  String fileName = path_library.basename(file.path);
  return fileName;
}
