import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/cupertino.dart';

Future<Uint8List?> readFileByteFromFilePath(String filePath) async {
  Uri myUri = Uri.parse(filePath);
  File audioFile = File.fromUri(myUri);
  Uint8List? bytes;
  await audioFile.readAsBytes().then((value) {
    bytes = Uint8List.fromList(value);
    debugPrint('reading of bytes is completed');
  }).catchError((onError) {
    debugPrint(
        'Exception Error while reading file from path:' + onError.toString());
  });
  return bytes;
}
