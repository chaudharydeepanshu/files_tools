import 'dart:io';
import 'dart:typed_data';

import 'package:pick_or_save/pick_or_save.dart';

Future<Uint8List> getBytesFromFilePathOrUri(
    {String? filePath, String? fileUri}) async {
  Uint8List filedData;

  if (filePath != null) {
    File tempFile = File(filePath);
    if (tempFile.existsSync()) {
      filedData = tempFile.readAsBytesSync();
    } else {
      throw Exception('File not found at file path.');
    }
  } else if (fileUri != null) {
    String? path = await PickOrSave().cacheFilePathFromUri(
        params: CacheFilePathFromUriParams(fileUri: fileUri));
    if (path != null) {
      File tempFile = File(path);
      filedData = tempFile.readAsBytesSync();
      tempFile.deleteSync();
    } else {
      throw Exception('File cached file path from Uri was null.');
    }
  } else {
    throw Exception('File path and file uri both are null.');
  }
  if (filedData.isEmpty) {
    throw Exception('File byte data is empty.');
  }

  return filedData;
}
