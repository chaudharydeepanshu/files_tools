import 'dart:math';
import 'package:files_tools/basicFunctionalityFunctions/getCacheFilePathFromFileName.dart';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'fileNameManager.dart';

Future<File> rotateImage(
    {required File file,
    required String imageFileName,
    required int rotation}) async {
  String extensionOfFileName = extensionOfString(fileName: imageFileName);
  String fileNameWithoutExtension = stringWithoutExtension(
      fileName: imageFileName, extensionOfString: extensionOfFileName);

  Random random = Random();
  int randomNumber = random.nextInt(1000000);

  File finalFile = await file.copy(await getCacheFilePathFromFileName(
      fileNameWithoutExtension + ' $randomNumber' + extensionOfFileName));
  try {
    final newFile = finalFile;

    List<int> imageBytes = await newFile.readAsBytes();

    final originalImage = img.decodeImage(imageBytes);

    img.Image fixedImage;
    fixedImage = img.copyRotate(originalImage!, rotation);

    final fixedFile = await newFile.writeAsBytes(img.encodeJpg(fixedImage),
        mode: FileMode.write, flush: true);

    finalFile = fixedFile;

    return fixedFile;
  } catch (e) {
    debugPrint('file not rotated due to exception');
    debugPrint(e.toString());
  }
  return finalFile;
}
