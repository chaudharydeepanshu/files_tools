import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> clearCache({required String clearCacheCommandFrom}) async {
  // await DefaultCacheManager().emptyCache();
  var appDir = (await getTemporaryDirectory()).path;
  Directory directory = Directory(appDir);
  // await directory.delete(recursive: true);
  final List<FileSystemEntity> entities = await directory.list().toList();
  for (var entity in entities) {
    if (entity.existsSync()) {
      entity.deleteSync(recursive: true);
    }
  }
  log("Cache emptied by $clearCacheCommandFrom");
  // if (!(await Directory(appDir).exists())) {
  //   Directory(appDir).create();
  //   log("Created cache directory");
  // }
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
