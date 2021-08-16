import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingImageFileUsingBytesTemporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/basicFunctionalityFunctions/getExternalStorageFilePathFromFileName.dart';
import 'package:files_tools/basicFunctionalityFunctions/getFileNameFromFilePath.dart';
import 'package:files_tools/basicFunctionalityFunctions/readFileByteFromFilePath.dart';
import 'package:files_tools/ui/functionsActionsScaffold/compressImage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

Future<dynamic> compressImages(List<String> imageFilePaths,
    Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
  List<File> compressedFiles = [];
  List<String> compressedFilesPaths = [];

  print(imageFilePaths.length);

  for (int i = 0; i < imageFilePaths.length; i++) {
    File file = File(imageFilePaths[i]);

    String extensionOfFileName =
        extensionOfString(fileName: pdfChangesDataMap['File Names'][i])
            .toLowerCase();
    String fileNameWithoutExtension = stringWithoutExtension(
        fileName: pdfChangesDataMap['File Names'][i],
        extensionOfString: extensionOfFileName);
    print(extensionOfFileName);

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
            Map map = Map();
            map['_imageName'] = getFileNameFromFilePath(targetPath);
            map['_extraBetweenNameAndExtension'] = '';
            map['_imageBytes'] = fileByte;
            await creatingAndSavingImageFileUsingBytesTemporarily(map);
          });
        } catch (e) {
          // if path invalid or not able to read
          print(e);
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

      print(file.lengthSync());
      print(imageCompressResult!.lengthSync());

      return imageCompressResult;
    }

    String targetPath =
        "${await getExternalStorageFilePathFromFileName(fileNameWithoutExtension + ' ' + 'compressed' + ' ' + i.toString() + extensionOfFileName)}";
    print(targetPath);
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
    print(quality);

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

  print(compressedFilesPaths);
  return compressedFilesPaths;
}
