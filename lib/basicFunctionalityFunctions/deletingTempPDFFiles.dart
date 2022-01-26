import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'getExternalStorageFilePathFromFileName.dart';

Future<void> deletingTempPDFFiles(String fileName) async {
  try {
    final file = File(await getExternalStorageFilePathFromFileName(fileName));
    await file.delete();
  } catch (e) {
    debugPrint(e.toString());
  }
}
