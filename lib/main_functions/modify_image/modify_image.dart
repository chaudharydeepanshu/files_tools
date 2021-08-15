import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:image_editor/image_editor.dart';
import 'dart:async';
import 'package:flutter/material.dart';

Future<dynamic> modifyImage(String imageFilePath,
    Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
  String extensionOfFileName =
      extensionOfString(fileName: pdfChangesDataMap['File Name']);

  Future<Uint8List?> cropImageDataWithNativeLibrary(
      {required ExtendedImageEditorState state}) async {
    print('native library start cropping');

    final Rect? cropRect = state.getCropRect();
    final EditActionDetails action = state.editAction!;

    final int rotateAngle = action.rotateAngle.toInt();
    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    final Uint8List img = state.rawImageData;

    final ImageEditorOption option = ImageEditorOption();

    if (action.needCrop) {
      option.addOption(ClipOption.fromRect(cropRect!));
    }

    if (action.needFlip) {
      option.addOption(
          FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    }

    if (action.hasRotateAngle) {
      option.addOption(RotateOption(rotateAngle));
    }

    if (extensionOfFileName.toLowerCase() == '.jpg' ||
        extensionOfFileName.toLowerCase() == '.jpeg') {
      option.outputFormat = const OutputFormat.jpeg(100);
    } else if (extensionOfFileName.toLowerCase() == '.png') {
      option.outputFormat = const OutputFormat.png(100);
    }

    final DateTime start = DateTime.now();
    final Uint8List? result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    print('${DateTime.now().difference(start)} ：total time');
    return result;
  }

  Uint8List? fileData =
      await cropImageDataWithNativeLibrary(state: pdfChangesDataMap['State']);

  return fileData;
}
