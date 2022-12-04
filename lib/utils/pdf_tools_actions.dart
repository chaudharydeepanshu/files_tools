import 'dart:io';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';

/// PdfToolsActions is a utility class for all the actions of PDF tools.
class PdfToolsActions {
  /// For merging multiple PDF files.
  static Future<OutputFileModel> mergePdfFiles({
    required List<InputFileModel> sourceFiles,
  }) async {
    // Holds result output file.
    OutputFileModel outputFile;

    // Paths of source PDF files to merge.
    List<String> pathsOfSourceFiles = List<String>.generate(
      sourceFiles.length,
      (int index) => sourceFiles[index].fileUri,
    );

    // Holds merge result file path.
    String? resultFilePath;

    try {
      // Merging the PDFs and storing result PDF file path in resultFilePath.
      resultFilePath = await PdfManipulator().mergePDFs(
        params: PDFMergerParams(
          pdfsPaths: pathsOfSourceFiles,
        ),
      );
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    // If actionErrorStatus is false then proceed with result.
    if (resultFilePath != null) {
      // If resultFilePath not null generating output files.
      OutputFileModel file = await Utility.getOutputFileModelFromPath(
        filePathOrUri: resultFilePath,
      );
      DateTime currentDateTime = DateTime.now();
      String outputFileName =
          Utility.getCleanedUpFileName('Merged File $currentDateTime.pdf');
      outputFile = file.copyWith(fileName: outputFileName);
    } else {
      // If resultFilesPaths is null then throw.
      throw 'Merged multiple PDFs result is null';
    }

    return outputFile;
  }

  /// For splitting PDF.
  static Future<List<OutputFileModel>> splitPdfFile({
    required InputFileModel sourceFile,
    int? pageCount,
    int? byteSize,
    List<int>? pageNumbers,
    List<String>? pageRanges,
    String? pageRange,
  }) async {
    // Holds result output files.
    List<OutputFileModel> outputFiles;

    // Getting info of source PDF file to split.
    String nameOfSourceFile = sourceFile.fileName;
    String extensionOfSourceFile =
        Utility.getFileNameExtension(fileName: nameOfSourceFile);
    String nameOfSourceFileWithoutExtension =
        Utility.getFileNameWithoutExtension(fileName: nameOfSourceFile);
    String pathOfSourceFile = sourceFile.fileUri;

    // Holds split result files paths.
    List<String>? resultFilesPaths;

    try {
      // Splitting the PDF and then storing result PDF
      // files paths in resultFilesPaths.

      if (pageCount != null ||
          byteSize != null ||
          pageNumbers != null ||
          pageRanges != null ||
          pageRange != null) {
        // If any parameter of PDFSplitterParams is non null.
        resultFilesPaths = await PdfManipulator().splitPDF(
          params: PDFSplitterParams(
            pdfPath: pathOfSourceFile,
            pageCount: pageCount,
            byteSize: byteSize,
            pageNumbers: pageNumbers,
            pageRanges: pageRanges,
            pageRange: pageRange,
          ),
        );
      } else {
        throw 'Every parameter of PDFSplitterParams is null for splitPdfFile()';
      }
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    if (resultFilesPaths != null && resultFilesPaths.isNotEmpty) {
      // If resultFilePath not null generating output files.
      outputFiles = <OutputFileModel>[];
      for (int i = 0; i < resultFilesPaths.length; i++) {
        OutputFileModel file = await Utility.getOutputFileModelFromPath(
          filePathOrUri: resultFilesPaths[i],
        );

        DateTime currentDateTime = DateTime.now();
        String outputFileName = Utility.getCleanedUpFileName(
          '$nameOfSourceFileWithoutExtension'
          ' - '
          '${i + 1}'
          ' - '
          '$currentDateTime$extensionOfSourceFile',
        );

        OutputFileModel outputFile = file.copyWith(fileName: outputFileName);

        outputFiles.add(outputFile);
      }
    } else {
      // If resultFilesPaths is null or empty then throw.
      throw 'Split PDFs result is $resultFilesPaths';
    }
    return outputFiles;
  }

  /// For rotating, reordering and deleting PDF pages.
  static Future<OutputFileModel> modifyPdfFile({
    required InputFileModel sourceFile,
    List<PageRotationInfo>? pagesRotationInfo,
    List<int>? pageNumbersForReorder,
    List<int>? pageNumbersForDeleter,
  }) async {
    // Holds result output file.
    OutputFileModel outputFile;

    // Getting info of source PDF file to modify.
    String nameOfSourceFile = sourceFile.fileName;
    String extensionOfSourceFile =
        Utility.getFileNameExtension(fileName: nameOfSourceFile);
    String nameOfSourceFileWithoutExtension =
        Utility.getFileNameWithoutExtension(fileName: nameOfSourceFile);
    String pathOfSourceFile = sourceFile.fileUri;

    // Holds modify result file path.
    String? resultFilePath;

    try {
      // Modifying the PDF and storing result PDF file path in resultFilePath.
      resultFilePath = await PdfManipulator().pdfPageRotatorDeleterReorder(
        params: PDFPageRotatorDeleterReorderParams(
          pdfPath: pathOfSourceFile,
          pagesRotationInfo: pagesRotationInfo,
          pageNumbersForDeleter: pageNumbersForDeleter,
          pageNumbersForReorder: pageNumbersForReorder,
        ),
      );
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    if (resultFilePath != null) {
      // If resultFilePath not null generating output files.
      OutputFileModel file = await Utility.getOutputFileModelFromPath(
        filePathOrUri: resultFilePath,
      );
      DateTime currentDateTime = DateTime.now();
      String outputFileName =
          Utility.getCleanedUpFileName('$nameOfSourceFileWithoutExtension'
              ' - '
              '$currentDateTime$extensionOfSourceFile');
      outputFile = file.copyWith(fileName: outputFileName);
    } else {
      // If resultFilePath is null or empty then throw.
      throw 'Split PDFs result is $resultFilePath';
    }
    return outputFile;
  }

  /// For converting PDF pages to images.
  static Future<List<OutputFileModel>> convertPdfFilePagesToImages({
    required InputFileModel sourceFile,
    required List<PdfPageModel> selectedPages,
    required double imageScaling,
  }) async {
    // Holds result output files.
    List<OutputFileModel> outputFiles;

    // Getting info of source PDF file to modify.
    String nameOfSourceFile = sourceFile.fileName;
    String extensionOfSourceFile =
        Utility.getFileNameExtension(fileName: nameOfSourceFile);
    String nameOfSourceFileWithoutExtension =
        Utility.getFileNameWithoutExtension(fileName: nameOfSourceFile);
    String pathOfSourceFile = sourceFile.fileUri;

    // Holds converted result files paths.
    List<String>? resultFilesPaths;

    try {
      // Converting the PDF pages to images and then storing result
      // files paths in resultFilesPaths.
      String imageTypeExtension = '.png';
      Directory directory = await Utility.getTempDirectory();
      String tempDirPath = directory.path;
      resultFilesPaths = <String>[];
      for (PdfPageModel page in selectedPages) {
        Uint8List? pageBytes;
        // Getting bytes of a PDF page.
        pageBytes = await Utility.getPdfPageBitmap(
          index: page.pageIndex,
          pdfPath: pathOfSourceFile,
          scale: imageScaling,
          rotationAngle: page.pageRotationAngle,
        );
        DateTime currentDateTime = DateTime.now();
        String tempFileName = Utility.getCleanedUpFileName(
          '$currentDateTime$imageTypeExtension',
        );
        File file = File('$tempDirPath/$tempFileName');
        if (pageBytes != null) {
          // If bytes of a PDF page not null then writing them to a file.
          await file.writeAsBytes(
            pageBytes.buffer.asUint8List(
              pageBytes.offsetInBytes,
              pageBytes.lengthInBytes,
            ),
          );
          resultFilesPaths.add(file.path);
        } else {
          throw 'PageBytes is null for convertPdfFilePagesToImages()';
        }
      }
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    if (resultFilesPaths.isNotEmpty) {
      // If resultFilePath not null generating output files.
      outputFiles = <OutputFileModel>[];
      for (int i = 0; i < resultFilesPaths.length; i++) {
        OutputFileModel file = await Utility.getOutputFileModelFromPath(
          filePathOrUri: resultFilesPaths[i],
        );

        DateTime currentDateTime = DateTime.now();
        String outputFileName = Utility.getCleanedUpFileName(
          '$nameOfSourceFileWithoutExtension'
          ' - '
          '${i + 1}'
          ' - '
          '$currentDateTime$extensionOfSourceFile',
        );

        OutputFileModel outputFile = file.copyWith(fileName: outputFileName);

        outputFiles.add(outputFile);
      }
    } else {
      // If resultFilesPaths is empty then throw.
      throw 'Convert PDF pages to images result is $resultFilesPaths';
    }
    return outputFiles;
  }

  /// For compressing PDF.
  static Future<OutputFileModel> compressPdfFile({
    required InputFileModel sourceFile,
    double? imageScale,
    int? imageQuality,
    bool? unEmbedFonts,
  }) async {
    // Holds result output file.
    OutputFileModel outputFile;

    // Getting info of source PDF file to compress.
    String nameOfSourceFile = sourceFile.fileName;
    String extensionOfSourceFile =
        Utility.getFileNameExtension(fileName: nameOfSourceFile);
    String nameOfSourceFileWithoutExtension =
        Utility.getFileNameWithoutExtension(fileName: nameOfSourceFile);
    String pathOfSourceFile = sourceFile.fileUri;

    // Holds compressed result file path.
    String? resultFilePath;

    try {
      // Compressing the PDF and storing result PDF file path in resultFilePath.
      resultFilePath = await PdfManipulator().pdfCompressor(
        params: PDFCompressorParams(
          pdfPath: pathOfSourceFile,
          imageScale: imageScale ?? 1,
          imageQuality: imageQuality ?? 100,
          unEmbedFonts: unEmbedFonts ?? false,
        ),
      );
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    // If actionErrorStatus is false then proceed with result.
    if (resultFilePath != null) {
      // If resultFilePath not null generating output files.
      OutputFileModel file = await Utility.getOutputFileModelFromPath(
        filePathOrUri: resultFilePath,
      );
      DateTime currentDateTime = DateTime.now();
      String outputFileName =
          Utility.getCleanedUpFileName('$nameOfSourceFileWithoutExtension'
              ' Compressed '
              '$currentDateTime$extensionOfSourceFile');
      outputFile = file.copyWith(fileName: outputFileName);
    } else {
      // If resultFilesPaths is null then throw.
      throw 'Compress PDF result is null';
    }

    return outputFile;
  }

  /// For watermarking PDF.
  static Future<OutputFileModel> watermarkPdfFile({
    required InputFileModel sourceFile,
    required String text,
    double? fontSize,
    WatermarkLayer? watermarkLayer,
    double? opacity,
    double? rotationAngle,
    Color? watermarkColor,
    PositionType? positionType,
  }) async {
    // Holds result output file.
    OutputFileModel outputFile;

    // Getting info of source PDF file to watermark.
    String nameOfSourceFile = sourceFile.fileName;
    String extensionOfSourceFile =
        Utility.getFileNameExtension(fileName: nameOfSourceFile);
    String nameOfSourceFileWithoutExtension =
        Utility.getFileNameWithoutExtension(fileName: nameOfSourceFile);
    String pathOfSourceFile = sourceFile.fileUri;

    // Holds watermarked result file path.
    String? resultFilePath;

    try {
      // Watermark the PDF and storing result PDF file path in resultFilePath.
      resultFilePath = await PdfManipulator().pdfWatermark(
        params: PDFWatermarkParams(
          pdfPath: pathOfSourceFile,
          text: text,
          fontSize: fontSize ?? 30,
          watermarkLayer: watermarkLayer ?? WatermarkLayer.overContent,
          opacity: opacity ?? 0.5,
          rotationAngle: rotationAngle ?? 45,
          watermarkColor: watermarkColor ?? Colors.black,
          positionType: positionType ?? PositionType.center,
        ),
      );
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    // If actionErrorStatus is false then proceed with result.
    if (resultFilePath != null) {
      // If resultFilePath not null generating output files.
      OutputFileModel file = await Utility.getOutputFileModelFromPath(
        filePathOrUri: resultFilePath,
      );
      DateTime currentDateTime = DateTime.now();
      String outputFileName =
          Utility.getCleanedUpFileName('$nameOfSourceFileWithoutExtension'
              ' Watermarked '
              '$currentDateTime$extensionOfSourceFile');
      outputFile = file.copyWith(fileName: outputFileName);
    } else {
      // If resultFilePath is null then throw.
      throw 'Watermark PDF result is null';
    }

    return outputFile;
  }

  /// For encrypting PDF.
  static Future<OutputFileModel> encryptPdfFile({
    required InputFileModel sourceFile,
    String? ownerPassword,
    String? userPassword,
    bool? allowPrinting,
    bool? allowModifyContents,
    bool? allowCopy,
    bool? allowModifyAnnotations,
    bool? allowFillIn,
    bool? allowScreenReaders,
    bool? allowAssembly,
    bool? allowDegradedPrinting,
    bool? standardEncryptionAES40,
    bool? standardEncryptionAES128,
    bool? encryptionAES128,
    bool? encryptionAES256,
    bool? encryptEmbeddedFilesOnly,
    bool? doNotEncryptMetadata,
  }) async {
    // Holds result output file.
    OutputFileModel outputFile;

    // Getting info of source PDF file to encrypt.
    String nameOfSourceFile = sourceFile.fileName;
    String extensionOfSourceFile =
        Utility.getFileNameExtension(fileName: nameOfSourceFile);
    String nameOfSourceFileWithoutExtension =
        Utility.getFileNameWithoutExtension(fileName: nameOfSourceFile);
    String pathOfSourceFile = sourceFile.fileUri;

    // Holds encrypted result file path.
    String? resultFilePath;

    try {
      // Encrypting the PDF and storing result PDF file path in resultFilePath.
      resultFilePath = await PdfManipulator().pdfEncryption(
        params: PDFEncryptionParams(
          pdfPath: pathOfSourceFile,
          ownerPassword: ownerPassword ?? '',
          userPassword: userPassword ?? '',
          allowPrinting: allowPrinting ?? false,
          allowModifyContents: allowModifyContents ?? false,
          allowCopy: allowCopy ?? false,
          allowModifyAnnotations: allowModifyAnnotations ?? false,
          allowFillIn: allowFillIn ?? false,
          allowScreenReaders: allowScreenReaders ?? false,
          allowAssembly: allowAssembly ?? false,
          allowDegradedPrinting: allowDegradedPrinting ?? false,
          standardEncryptionAES40: standardEncryptionAES40 ?? false,
          standardEncryptionAES128: standardEncryptionAES128 ?? false,
          encryptionAES128: encryptionAES128 ?? false,
          encryptionAES256: encryptionAES256 ?? false,
          encryptEmbeddedFilesOnly: encryptEmbeddedFilesOnly ?? false,
          doNotEncryptMetadata: doNotEncryptMetadata ?? false,
        ),
      );
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    // If actionErrorStatus is false then proceed with result.
    if (resultFilePath != null) {
      // If resultFilePath not null generating output files.
      OutputFileModel file = await Utility.getOutputFileModelFromPath(
        filePathOrUri: resultFilePath,
      );
      DateTime currentDateTime = DateTime.now();
      String outputFileName =
          Utility.getCleanedUpFileName('$nameOfSourceFileWithoutExtension'
              ' Encrypted '
              '$currentDateTime$extensionOfSourceFile');
      outputFile = file.copyWith(fileName: outputFileName);
    } else {
      // If resultFilesPaths is null then throw.
      throw 'Encrypt PDF result is null';
    }

    return outputFile;
  }

  /// For decrypting PDF.
  static Future<OutputFileModel> decryptPdfFile({
    required InputFileModel sourceFile,
    String? password,
  }) async {
    // Holds result output file.
    OutputFileModel outputFile;

    // Getting info of source PDF file to decrypt.
    String nameOfSourceFile = sourceFile.fileName;
    String extensionOfSourceFile =
        Utility.getFileNameExtension(fileName: nameOfSourceFile);
    String nameOfSourceFileWithoutExtension =
        Utility.getFileNameWithoutExtension(fileName: nameOfSourceFile);
    String pathOfSourceFile = sourceFile.fileUri;

    // Holds decrypted result file path.
    String? resultFilePath;

    try {
      // Decrypting the PDF and storing result PDF file path in resultFilePath.
      resultFilePath = await PdfManipulator().pdfDecryption(
        params: PDFDecryptionParams(
          pdfPath: pathOfSourceFile,
          password: password ?? '',
        ),
      );
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    // If actionErrorStatus is false then proceed with result.
    if (resultFilePath != null) {
      // If resultFilePath not null generating output files.
      OutputFileModel file = await Utility.getOutputFileModelFromPath(
        filePathOrUri: resultFilePath,
      );
      DateTime currentDateTime = DateTime.now();
      String outputFileName =
          Utility.getCleanedUpFileName('$nameOfSourceFileWithoutExtension'
              ' Decrypted '
              '$currentDateTime$extensionOfSourceFile');
      outputFile = file.copyWith(fileName: outputFileName);
    } else {
      // If resultFilesPaths is null then throw.
      throw 'Decrypt PDF result is null';
    }

    return outputFile;
  }
}
