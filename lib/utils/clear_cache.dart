import 'dart:developer';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

Future<void> clearCache({required String clearCacheCommandFrom}) async {
  await DefaultCacheManager().emptyCache();
  // var appDir = (await getTemporaryDirectory()).path;
  // Directory(appDir).delete(recursive: true);
  log("Cache emptied $clearCacheCommandFrom");
  // if (!(await Directory(appDir).exists())) {
  //   Directory(appDir).create();
  //   log("Creating cache directory");
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
