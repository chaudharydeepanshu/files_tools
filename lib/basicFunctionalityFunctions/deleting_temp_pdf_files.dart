import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'get_external_storage_file_path_from_file_name.dart';

Future<void> deletingTempPDFFiles(String fileName) async {
  try {
    final file = File(await getExternalStorageFilePathFromFileName(fileName));
    await file.delete();
  } catch (e) {
    debugPrint(e.toString());
  }
}
