import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> clearCache({required String clearCacheCommandFrom}) async {
  Directory directory = await getTemporaryDirectory();

  if (!(await directory.exists())) {
    directory.create(recursive: true);
    log("Temporary directory didn't exist so created");
  }

  final List<FileSystemEntity> entities = await directory.list().toList();
  for (var entity in entities) {
    if (!(await entity.exists())) {
      entity.deleteSync(recursive: true);
    }
  }

  log("Temporary directory emptied by $clearCacheCommandFrom");
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
