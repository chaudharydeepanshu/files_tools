import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String> getExternalStorageDirectoryPath() async {
  final directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationDocumentsDirectory();
  String? path = directory!.path;
  return path;
}

Future<String> getExternalStorageFilePathFromFileName(String fileName) async {
  String? path = await getExternalStorageDirectoryPath();
  String filePath = Platform.isAndroid ? '$path/$fileName' : '$path\\$fileName';
  return filePath;
}
