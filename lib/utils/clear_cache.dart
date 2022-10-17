import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> clearCache() async {
  var appDir = (await getTemporaryDirectory()).path;
  Directory(appDir).delete(recursive: true);
  log("Cleared all cache");
  if (!(await Directory(appDir).exists())) {
    Directory(appDir).create();
    log("Creating cache directory");
  }
}

Future<void> clearSelectiveFilesFromCache(List<String> filesPaths) async {
  var appDir = (await getTemporaryDirectory()).path;
  for (var filePath in filesPaths) {
    File tempFile = File(filePath);
    if (await tempFile.exists()) {
      tempFile.delete();
    }
  }
  log("Cleared $filesPaths from cache");
  if (!(await Directory(appDir).exists())) {
    Directory(appDir).create();
    log("Creating cache directory");
  }
}
