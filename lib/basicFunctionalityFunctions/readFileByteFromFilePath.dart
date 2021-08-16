import 'dart:typed_data';
import 'dart:io';

Future<Uint8List?> readFileByteFromFilePath(String filePath) async {
  Uri myUri = Uri.parse(filePath);
  File audioFile = new File.fromUri(myUri);
  Uint8List? bytes;
  await audioFile.readAsBytes().then((value) {
    bytes = Uint8List.fromList(value);
    print('reading of bytes is completed');
  }).catchError((onError) {
    print('Exception Error while reading file from path:' + onError.toString());
  });
  return bytes;
}
