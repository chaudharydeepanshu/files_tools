import 'package:path_provider/path_provider.dart';

Future<String> getExternalStorageDirectoryPath() async {
  final directory = await getExternalStorageDirectory();
  String? path = directory!.path;
  return path;
}

Future<String> getExternalStorageFilePathFromFileName(String fileName) async {
  String? path = await getExternalStorageDirectoryPath();
  String filePath = '$path/$fileName';
  return filePath;
}
