import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:files_tools/basicFunctionalityFunctions/creating_and_saving_image_file_using_bytes_temporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/file_name_manager.dart';
import 'package:files_tools/basicFunctionalityFunctions/get_external_storage_file_path_from_file_name.dart';
import 'package:files_tools/basicFunctionalityFunctions/get_file_name_from_file_path.dart';
import 'package:files_tools/basicFunctionalityFunctions/read_file_byte_from_file_path.dart';
import 'package:files_tools/ui/functionsActionsScaffold/compress_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

Future<dynamic> compressImages(List<String> imageFilePaths,
    Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
  List<File> compressedFiles = [];
  List<String> compressedFilesPaths = [];

  debugPrint(imageFilePaths.length.toString());

  for (int i = 0; i < imageFilePaths.length; i++) {
    File file = File(imageFilePaths[i]);

    String extensionOfFileName =
        extensionOfString(fileName: pdfChangesDataMap['File Names'][i])
            .toLowerCase();
    String fileNameWithoutExtension = stringWithoutExtension(
        fileName: pdfChangesDataMap['File Names'][i],
        extensionOfString: extensionOfFileName);
    debugPrint(extensionOfFileName);

    Future<File> compressAndGetFile(
        File file, String targetPath, int quality) async {
      File? imageCompressResult;
      if (extensionOfFileName == '.png') {
        //facing issue with png images compression so using another plugin for that
        // imageCompressResult = await FlutterImageCompress.compressAndGetFile(
        //     file.absolute.path, targetPath,
        //     quality: quality, rotate: 0, format: CompressFormat.png);
        imageCompressResult = await FlutterNativeImage.compressImage(
            file.absolute.path,
            quality: quality,
            percentage: 100);
        try {
          Uint8List fileByte;
          String myPath = imageCompressResult.path;
          readFileByteFromFilePath(myPath).then((bytesData) async {
            fileByte = bytesData!;
            //do your task here
            Map map = {};
            map['_imageName'] = getFileNameFromFilePath(targetPath);
            map['_extraBetweenNameAndExtension'] = '';
            map['_imageBytes'] = fileByte;
            await creatingAndSavingImageFileUsingBytesTemporarily(map);
          });
        } catch (e) {
          // if path invalid or not able to read
          debugPrint(e.toString());
        }
      } else if (extensionOfFileName == '.jpg' ||
          extensionOfFileName == '.jpeg') {
        imageCompressResult = await FlutterImageCompress.compressAndGetFile(
            file.absolute.path, targetPath,
            quality: quality, rotate: 0, format: CompressFormat.jpeg);
      } else if (extensionOfFileName == '.webp') {
        imageCompressResult = await FlutterImageCompress.compressAndGetFile(
            file.absolute.path, targetPath,
            quality: quality, rotate: 0, format: CompressFormat.webp);
      } else if (extensionOfFileName == '.heic' ||
          extensionOfFileName == '.heif') {
        imageCompressResult = await FlutterImageCompress.compressAndGetFile(
            file.absolute.path, targetPath,
            quality: quality, rotate: 0, format: CompressFormat.heic);
      }

      debugPrint(file.lengthSync().toString());
      debugPrint(imageCompressResult!.lengthSync().toString());

      return imageCompressResult;
    }

    String targetPath = await getExternalStorageFilePathFromFileName(
        fileNameWithoutExtension +
            ' ' +
            'compressed' +
            ' ' +
            i.toString() +
            extensionOfFileName);
    debugPrint(targetPath);
    int quality = 0;
    if (pdfChangesDataMap['Qualities Method'] == Qualities.high) {
      quality = 88;
    } else if (pdfChangesDataMap['Qualities Method'] == Qualities.medium) {
      quality = 50;
    } else if (pdfChangesDataMap['Qualities Method'] == Qualities.low) {
      quality = 20;
    } else if (pdfChangesDataMap['Qualities Method'] == Qualities.custom) {
      quality = pdfChangesDataMap['Quality Custom Value'];
    }
    debugPrint(quality.toString());

    if (extensionOfFileName == '.png' ||
        extensionOfFileName == '.jpg' ||
        extensionOfFileName == '.jpeg' ||
        extensionOfFileName == '.heic' ||
        extensionOfFileName == '.heif' ||
        extensionOfFileName == '.webp') {
      compressedFiles.add(await compressAndGetFile(file, targetPath, quality));
      compressedFilesPaths.add(targetPath);
    }
  }

  if (kDebugMode) {
    print(compressedFilesPaths);
  }
  return compressedFilesPaths;
}
