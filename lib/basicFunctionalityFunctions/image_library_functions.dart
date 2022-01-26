import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart';
import 'package:files_tools/basicFunctionalityFunctions/get_external_storage_file_path_from_file_name.dart';

class DecodeParam {
  final File file;
  final SendPort sendPort;
  DecodeParam(this.file, this.sendPort);
}

void decodeIsolate(DecodeParam param) {
  // Read an image from file (webp in this case).
  // decodeImage will identify the format of the image and use the appropriate
  // decoder.
  var image = decodeImage(param.file.readAsBytesSync())!;
  // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
  var thumbnail =
      copyResize(image, width: 1920, interpolation: Interpolation.nearest);
  param.sendPort.send(thumbnail);
}

// Decode and process an image file in a separate thread (isolate) to avoid
// stalling the main UI thread.
Future<File> imageEncoder(String imagePath) async {
  var receivePort = ReceivePort();

  await Isolate.spawn(
      decodeIsolate, DecodeParam(File(imagePath), receivePort.sendPort));

  // Get the processed image from the isolate.
  var image = await receivePort.first as Image;

  return await File(
          await getExternalStorageFilePathFromFileName('thumbnail.png'))
      .writeAsBytes(encodePng(image));
}
