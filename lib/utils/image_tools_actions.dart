import 'dart:io';
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/utils/edit_image.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';

/// ImageToolsActions is a utility class for all the actions of Image tools.
class ImageToolsActions {
  /// For cropping, rotating, flipping image files.
  static Future<List<OutputFileModel>> modifyImageFiles({
    required List<InputFileModel> sourceFiles,
    required List<GlobalKey<ExtendedImageEditorState>> editorKeys,
  }) async {
    // Holds result output files.
    List<OutputFileModel> outputFiles;

    // Holds modify image result files paths.
    List<String>? resultFilesPaths;

    try {
      // Modifying the images and storing result image files paths in
      // resultFilesPaths.
      resultFilesPaths = <String>[];
      for (int i = 0; i < sourceFiles.length; i++) {
        ExtendedImageEditorState? currentState = editorKeys[i].currentState;
        InputFileModel sourceFile = sourceFiles[i];
        if (currentState != null) {
          // If image needs to be modified.
          Uint8List? updatedImageData = await modifyImage(currentState);

          // Getting info of source Image file.
          String nameOfSourceFile = sourceFile.fileName;
          String extensionOfSourceFile =
              Utility.getFileNameExtension(fileName: nameOfSourceFile);

          // Creating temp file name.
          DateTime currentDateTime = DateTime.now();
          String tempFileName = Utility.getCleanedUpFileName(
            '$currentDateTime$extensionOfSourceFile',
          );

          // Creating temp file and writing data to it.
          Directory directory = await Utility.getTempDirectory();
          String tempDirPath = directory.path;
          File tempFile = File('$tempDirPath/$tempFileName');
          if (updatedImageData != null) {
            // If bytes of an image not null then writing it to a file.
            await tempFile.writeAsBytes(
              updatedImageData.buffer.asUint8List(
                updatedImageData.offsetInBytes,
                updatedImageData.lengthInBytes,
              ),
            );
            resultFilesPaths.add(tempFile.path);
          } else {
            throw 'ImageData is null for modifyImageFiles()';
          }
        } else {
          // If image doesn't need to be updated.
          resultFilesPaths.add(sourceFile.fileUri);
        }
      }
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    // If actionErrorStatus is false then proceed with result.
    if (resultFilesPaths.isNotEmpty) {
      // If resultFilesPaths not empty generating output files.
      outputFiles = <OutputFileModel>[];
      for (int i = 0; i < resultFilesPaths.length; i++) {
        OutputFileModel file = await Utility.getOutputFileModelFromPath(
          filePathOrUri: resultFilesPaths[i],
        );

        // Getting info of source image file.
        String nameOfSourceFile = sourceFiles[i].fileName;
        String extensionOfSourceFile =
            Utility.getFileNameExtension(fileName: nameOfSourceFile);
        String nameOfSourceFileWithoutExtension =
            Utility.getFileNameWithoutExtension(fileName: nameOfSourceFile);

        DateTime currentDateTime = DateTime.now();
        String outputFileName = Utility.getCleanedUpFileName(
          '$nameOfSourceFileWithoutExtension'
          ' Modified '
          '$currentDateTime$extensionOfSourceFile',
        );

        OutputFileModel outputFile = file.copyWith(fileName: outputFileName);

        outputFiles.add(outputFile);
      }
    } else {
      // If resultFilesPaths is empty then throw.
      throw 'Modify images result is $resultFilesPaths';
    }

    return outputFiles;
  }

  /// For converting images to PDFs.
  static Future<List<OutputFileModel>> convertImageFilesToPdfs({
    required List<InputFileModel> sourceFiles,
    required bool createSinglePdf,
  }) async {
    // Holds result output files.
    List<OutputFileModel> outputFiles;

    // Paths of source PDF files to merge.
    List<String> pathsOfSourceFiles = List<String>.generate(
      sourceFiles.length,
      (int index) => sourceFiles[index].fileUri,
    );

    // Holds decrypted result files paths.
    List<String>? resultFilesPaths;

    try {
      // Converting the images to PDFs and storing result PDF file path in
      // resultFilesPaths.
      resultFilesPaths = await PdfManipulator().imagesToPdfs(
        params: ImagesToPDFsParams(
          imagesPaths: pathsOfSourceFiles,
          createSinglePdf: createSinglePdf,
        ),
      );
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    // If actionErrorStatus is false then proceed with result.
    if (resultFilesPaths != null && resultFilesPaths.isNotEmpty) {
      // If resultFilePath not null and not empty, generating output files.
      outputFiles = <OutputFileModel>[];
      for (int i = 0; i < resultFilesPaths.length; i++) {
        OutputFileModel file = await Utility.getOutputFileModelFromPath(
          filePathOrUri: resultFilesPaths[i],
        );

        // Getting info of output file.
        String nameOfOutputFile = file.fileName;
        String extensionOfOutputFile =
            Utility.getFileNameExtension(fileName: nameOfOutputFile);

        DateTime currentDateTime = DateTime.now();
        String outputFileName = Utility.getCleanedUpFileName(
          'Image PDF'
          ' - '
          '${i + 1}'
          ' - '
          '$currentDateTime$extensionOfOutputFile',
        );

        OutputFileModel outputFile = file.copyWith(fileName: outputFileName);

        outputFiles.add(outputFile);
      }
    } else {
      // If resultFilesPaths is null then throw.
      throw 'Image to PDF result is null';
    }

    return outputFiles;
  }

  /// For compressing image files.
  static Future<List<OutputFileModel>> compressImageFiles({
    required List<InputFileModel> sourceFiles,
    double? imageScale,
    int? imageQuality,
    bool? removeExifData,
  }) async {
    // Holds result output files.
    List<OutputFileModel> outputFiles;

    // Holds compress image result files paths.
    List<String>? resultFilesPaths;

    try {
      // Compressing the source images and storing result image files paths
      // in resultFilesPaths.
      resultFilesPaths = <String>[];
      for (int i = 0; i < sourceFiles.length; i++) {
        InputFileModel sourceFile = sourceFiles[i];

        // Getting source file bytes using its uri.
        Uint8List imageData = await Utility.getByteDataFromFilePathOrUri(
          fileUri: sourceFile.fileUri,
        );

        // Getting Image object from image data (Uint8List) for using it to get
        // image file size to scale it accordingly.
        ui.Image imageObject =
            await Utility.imageFromUint8List(uint8list: imageData);

        // Getting compressed image data.
        Uint8List compressedImageData =
            await FlutterImageCompress.compressWithList(
          imageData,
          minWidth: (imageObject.width * imageScale!).toInt(),
          minHeight: (imageObject.height * imageScale).toInt(),
          quality: imageQuality ?? 100,
          keepExif: removeExifData != null ? !removeExifData : true,
        );

        // Using original image if compressed image is larger in bytes then
        // original image.
        if (imageData.lengthInBytes < compressedImageData.lengthInBytes) {
          compressedImageData = imageData;
        }

        // Getting info of source Image file.
        String nameOfSourceFile = sourceFile.fileName;
        String extensionOfSourceFile =
            Utility.getFileNameExtension(fileName: nameOfSourceFile);

        // Creating temp file name.
        DateTime currentDateTime = DateTime.now();
        String tempFileName = Utility.getCleanedUpFileName(
          '$currentDateTime$extensionOfSourceFile',
        );

        // Creating temp file and writing data to it.
        Directory directory = await Utility.getTempDirectory();
        String tempDirPath = directory.path;
        File tempFile = File('$tempDirPath/$tempFileName');
        if (compressedImageData.isNotEmpty) {
          // If bytes of an image not null then writing it to a file.
          await tempFile.writeAsBytes(
            compressedImageData.buffer.asUint8List(
              compressedImageData.offsetInBytes,
              compressedImageData.lengthInBytes,
            ),
          );

          resultFilesPaths.add(tempFile.path);
        } else {
          throw 'CompressedImageData is empty for compressImageFile()';
        }
      }
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    // If actionErrorStatus is false then proceed with result.
    if (resultFilesPaths.isNotEmpty) {
      // If resultFilesPaths not empty generating output files.
      outputFiles = <OutputFileModel>[];
      for (int i = 0; i < resultFilesPaths.length; i++) {
        OutputFileModel file = await Utility.getOutputFileModelFromPath(
          filePathOrUri: resultFilesPaths[i],
        );

        // Getting info of source image file.
        String nameOfSourceFile = sourceFiles[i].fileName;
        String extensionOfSourceFile =
            Utility.getFileNameExtension(fileName: nameOfSourceFile);
        String nameOfSourceFileWithoutExtension =
            Utility.getFileNameWithoutExtension(fileName: nameOfSourceFile);

        DateTime currentDateTime = DateTime.now();
        String outputFileName = Utility.getCleanedUpFileName(
          '$nameOfSourceFileWithoutExtension'
          ' Compressed '
          '$currentDateTime$extensionOfSourceFile',
        );

        OutputFileModel outputFile = file.copyWith(fileName: outputFileName);

        outputFiles.add(outputFile);
      }
    } else {
      // If resultFilesPaths is empty then throw.
      throw 'Compress images result is $resultFilesPaths';
    }

    return outputFiles;
  }
}
