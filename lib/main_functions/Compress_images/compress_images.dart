import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingImageFileUsingBytesTemporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/currentDateTimeInString.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/basicFunctionalityFunctions/getCacheFilePathFromFileName.dart';
import 'package:files_tools/basicFunctionalityFunctions/getExternalStorageFilePathFromFileName.dart';
import 'package:files_tools/basicFunctionalityFunctions/getFileNameFromFilePath.dart';
import 'package:files_tools/ui/functionsActionsScaffold/compressImage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_compression/image_compression.dart';
import 'dart:async';
import 'package:image_compression/image_compression_html.dart'
    as image_compression_html;

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
      var imageCompressResult;
      if (extensionOfFileName == '.png') {
        // print('png compressed');
        // final tempFile = File(file.absolute.path);
        //
        // final input = ImageFile(
        //   rawBytes: tempFile.readAsBytesSync(),
        //   filePath: tempFile.path,
        // );
        // final output = await image_compression_html.compressInQueue(
        //     ImageFileConfiguration(
        //         input: input,
        //         config: Configuration(
        //             pngCompression: PngCompression.defaultCompression)));
        // print('Input size = ${file.lengthSync()}');
        // print('Output size = ${output.sizeInBytes}');
        // print("output.rawBytes : ${output.rawBytes}");
        // Map map = Map();
        // map['_imageName'] = getFileNameFromFilePath(targetPath);
        // map['_extraBetweenNameAndExtension'] = '';
        // map['_imageBytes'] = output.rawBytes;
        // final outputFile =
        //     File(await creatingAndSavingImageFileUsingBytesTemporarily(map));
        //imageCompressResult = outputFile;

        imageCompressResult = await FlutterImageCompress.compressAndGetFile(
            file.absolute.path, targetPath,
            quality: quality, rotate: 0, format: CompressFormat.png);
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
