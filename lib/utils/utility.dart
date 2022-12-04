import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' as painting;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_bitmaps/pdf_bitmaps.dart';
import 'package:pick_or_save/pick_or_save.dart';

// ignore: constant_identifier_names
enum BytesFormatType { auto, B, KB, MB, GB, TB, PB, EB, ZB, YB }

class Utility {
  static Future<ui.Image> imageFromUint8List(
      {required Uint8List uint8list}) async {
    return await painting.decodeImageFromList(uint8list);
  }

  static Future<String> getAbsoluteFilePathFromFileUri(
      {required String fileUri}) async {
    String? absoluteFilePath;

    absoluteFilePath = await PickOrSave().cacheFilePathFromPath(
      params: CacheFilePathFromPathParams(filePath: fileUri),
    );
    if (absoluteFilePath == null) {
      throw Exception('File cached file path from Uri was null.');
    }

    return absoluteFilePath;
  }

  static String getCleanedUpFileName(String fileName) {
    return fileName.replaceAll(RegExp('[\\\\/:*?"<>|\\[\\]]'), '_');
  }

  static String getFileNameExtension({required String fileName}) {
    int indexOfLastDot = fileName.lastIndexOf('.');
    if (indexOfLastDot == -1) {
      return '';
    } else {
      String fileExt = fileName.substring(indexOfLastDot).toLowerCase();
      return fileExt;
    }
  }

  static String getFileNameWithoutExtension({required String fileName}) {
    String fileExt = getFileNameExtension(fileName: fileName);
    String fileNameWithoutExtension =
        fileName.substring(0, fileName.length - fileExt.length);
    return fileNameWithoutExtension;
  }

  static Future<Directory> getTempDirectory() async {
    Directory directory = await getTemporaryDirectory();

    if (!(await directory.exists())) {
      directory.create(recursive: true);
      log("Temporary directory didn't exist so created");
    }

    return directory;
  }

  static Future<void> clearCache(
      {required String clearCacheCommandFrom}) async {
    Directory directory = await getTempDirectory();

    final List<FileSystemEntity> entities = await directory.list().toList();
    for (FileSystemEntity entity in entities) {
      if (!(await entity.exists())) {
        entity.deleteSync(recursive: true);
      }
    }

    log('Temporary directory emptied by $clearCacheCommandFrom');
  }

  static Future<void> clearSelectiveFilesFromCache(
      {required List<String> filesPaths,
      required String clearCacheCommandFrom}) async {
    Directory directory = await getTemporaryDirectory();

    if (!(await directory.exists())) {
      directory.create(recursive: true);
      log("Temporary directory didn't exist so created");
    }

    final List<FileSystemEntity> entities = await directory.list().toList();
    for (String filePath in filesPaths) {
      File tempFile = File(filePath);
      if (!(await tempFile.exists())) {
        tempFile.delete();
      }
    }

    log('Temporary directory emptied by $clearCacheCommandFrom');
    log('Deleted temporary directory files paths are $filesPaths');
  }

  // This is for MB etc not MiB etc as they use 1024 instead of 1000.
  static String formatBytes({
    required int bytes,
    required int decimals,
    BytesFormatType? formatType,
  }) {
    if (BytesFormatType.B == formatType) {
      if (bytes <= 0) {
        return '0';
      }
      return (bytes).toStringAsFixed(decimals);
    } else if (BytesFormatType.KB == formatType) {
      if (bytes <= 0) {
        return '0';
      }
      double i = (bytes / 1000);
      return (i).toStringAsFixed(decimals);
    } else if (BytesFormatType.MB == formatType) {
      if (bytes <= 0) {
        return '0';
      }
      double i = (bytes / math.pow(1000, 2));
      return (i).toStringAsFixed(decimals);
    } else if (BytesFormatType.GB == formatType) {
      if (bytes <= 0) {
        return '0';
      }
      double i = (bytes / math.pow(1000, 3));
      return (i).toStringAsFixed(decimals);
    } else if (BytesFormatType.TB == formatType) {
      if (bytes <= 0) {
        return '0';
      }
      double i = (bytes / math.pow(1000, 4));
      return (i).toStringAsFixed(decimals);
    } else if (BytesFormatType.PB == formatType) {
      if (bytes <= 0) {
        return '0';
      }
      double i = (bytes / math.pow(1000, 5));
      return (i).toStringAsFixed(decimals);
    } else if (BytesFormatType.EB == formatType) {
      if (bytes <= 0) {
        return '0';
      }
      double i = (bytes / math.pow(1000, 6));
      return (i).toStringAsFixed(decimals);
    } else if (BytesFormatType.ZB == formatType) {
      if (bytes <= 0) {
        return '0';
      }
      double i = (bytes / math.pow(1000, 7));
      return (i).toStringAsFixed(decimals);
    } else if (BytesFormatType.YB == formatType) {
      if (bytes <= 0) {
        return '0';
      }
      double i = (bytes / math.pow(1000, 8));
      return (i).toStringAsFixed(decimals);
    } else {
      if (bytes <= 0) {
        return '0 B';
      }
      const List<String> suffixes = <String>[
        'B',
        'KB',
        'MB',
        'GB',
        'TB',
        'PB',
        'EB',
        'ZB',
        'YB'
      ];
      int i = (math.log(bytes) / math.log(1000)).floor();
      String sizeValue = (bytes / math.pow(1000, i)).toStringAsFixed(decimals);
      String sizeSuffix = suffixes[i];
      return '$sizeValue $sizeSuffix';
    }
  }

  static Future<InputFileModel> getInputFileModelFromUri({
    required String filePathOrUri,
  }) async {
    FileMetadata fileMetadata;
    fileMetadata = await PickOrSave()
        .fileMetaData(params: FileMetadataParams(filePath: filePathOrUri));
    final String fileName = fileMetadata.displayName ?? 'Unknown';
    final DateTime? lastModifiedDateTime;
    if (fileMetadata.lastModified != null &&
        fileMetadata.lastModified != 'Unknown') {
      lastModifiedDateTime =
          DateTime.parse(fileMetadata.lastModified!).toLocal();
    } else {
      lastModifiedDateTime = null;
    }

    final String fileDate;
    final String fileTime;

    if (lastModifiedDateTime != null) {
      fileDate =
          '${lastModifiedDateTime.day}/${lastModifiedDateTime.month}/${lastModifiedDateTime.year}';
      TimeOfDay time = TimeOfDay.fromDateTime(lastModifiedDateTime);
      fileTime =
          '${time.hourOfPeriod}:${time.minute} ${time.period.name.toUpperCase()}';
    } else {
      fileDate = 'Unknown';
      fileTime = 'Unknown';
    }
    final String fileSizeFormatBytes = fileMetadata.size != null &&
            fileMetadata.size != 'Unknown'
        ? Utility.formatBytes(bytes: int.parse(fileMetadata.size!), decimals: 2)
        : 'Unknown';
    final int fileSizeBytes =
        fileMetadata.size != null && fileMetadata.size != 'Unknown'
            ? int.parse(fileMetadata.size!)
            : 0;
    InputFileModel file = InputFileModel(
      fileName: fileName,
      fileDate: fileDate,
      fileTime: fileTime,
      fileSizeFormatBytes: fileSizeFormatBytes,
      fileSizeBytes: fileSizeBytes,
      fileUri: filePathOrUri,
    );
    return file;
  }

  static Future<OutputFileModel> getOutputFileModelFromPath({
    required String filePathOrUri,
  }) async {
    FileMetadata fileMetadata;
    fileMetadata = await PickOrSave()
        .fileMetaData(params: FileMetadataParams(filePath: filePathOrUri));
    final String fileName = fileMetadata.displayName ?? 'Unknown';
    final DateTime? lastModifiedDateTime;
    if (fileMetadata.lastModified != null &&
        fileMetadata.lastModified != 'Unknown') {
      lastModifiedDateTime =
          DateTime.parse(fileMetadata.lastModified!).toLocal();
    } else {
      lastModifiedDateTime = null;
    }

    final String fileDate;
    final String fileTime;

    if (lastModifiedDateTime != null) {
      fileDate =
          '${lastModifiedDateTime.day}/${lastModifiedDateTime.month}/${lastModifiedDateTime.year}';
      TimeOfDay time = TimeOfDay.fromDateTime(lastModifiedDateTime);
      fileTime =
          '${time.hourOfPeriod}:${time.minute} ${time.period.name.toUpperCase()}';
    } else {
      fileDate = 'Unknown';
      fileTime = 'Unknown';
    }
    final String fileSizeFormatBytes = fileMetadata.size != null &&
            fileMetadata.size != 'Unknown'
        ? Utility.formatBytes(bytes: int.parse(fileMetadata.size!), decimals: 2)
        : 'Unknown';
    final int fileSizeBytes =
        fileMetadata.size != null && fileMetadata.size != 'Unknown'
            ? int.parse(fileMetadata.size!)
            : 0;
    OutputFileModel file = OutputFileModel(
      fileName: fileName,
      fileDate: fileDate,
      fileTime: fileTime,
      fileSizeFormatBytes: fileSizeFormatBytes,
      fileSizeBytes: fileSizeBytes,
      filePath: filePathOrUri,
    );
    return file;
  }

  static Future<Uint8List?> getPdfPageBitmap({
    required int index,
    required String pdfPath,
    double? scale,
    int? rotationAngle,
    Color? backgroundColor,
    PdfRendererType? pdfRendererType,
  }) async {
    String? imageCachedPath;
    Uint8List? bytes;

    try {
      imageCachedPath = await PdfBitmaps().pdfBitmap(
        params: PDFBitmapParams(
          pdfPath: pdfPath,
          pageInfo: BitmapConfigForPage(
            pageNumber: index + 1,
            scale: scale ?? 1,
            rotationAngle: rotationAngle ?? 0,
            backgroundColor: backgroundColor ?? Colors.white,
          ),
          pdfRendererType:
              pdfRendererType ?? PdfRendererType.androidPdfRenderer,
        ),
      );
      if (imageCachedPath != null) {
        bytes = File(imageCachedPath).readAsBytesSync();
      }
    } on PlatformException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }

    return bytes;
  }

  static Future<PdfPageModel> getUpdatedPdfPage({
    required int index,
    required String pdfPath,
    required PdfPageModel pdfPageModel,
    double? scale,
    int? rotationAngle,
    Color? backgroundColor,
    PdfRendererType? pdfRendererType,
  }) async {
    Uint8List? bytes = await getPdfPageBitmap(
      index: index,
      pdfPath: pdfPath,
      scale: scale,
      rotationAngle: rotationAngle,
      backgroundColor: backgroundColor,
      pdfRendererType: pdfRendererType,
    );

    PdfPageModel updatedPdfPage;
    if (bytes != null) {
      updatedPdfPage = PdfPageModel(
        pageIndex: pdfPageModel.pageIndex,
        pageBytes: bytes,
        pageErrorStatus: false,
        pageSelected: pdfPageModel.pageSelected,
        pageRotationAngle: pdfPageModel.pageRotationAngle,
        pageHidden: pdfPageModel.pageHidden,
      );
    } else {
      updatedPdfPage = PdfPageModel(
        pageIndex: pdfPageModel.pageIndex,
        pageBytes: null,
        pageErrorStatus: true,
        pageSelected: pdfPageModel.pageSelected,
        pageRotationAngle: pdfPageModel.pageRotationAngle,
        pageHidden: pdfPageModel.pageHidden,
      );
    }
    return updatedPdfPage;
  }

  static Future<int?> getPdfPageCount({required String pdfPath}) async {
    int? pdfPageCount;
    try {
      pdfPageCount = await PdfBitmaps()
          .pdfPageCount(params: PDFPageCountParams(pdfPath: pdfPath));
    } on PlatformException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
    return pdfPageCount;
  }

  static Future<List<PdfPageModel>> generatePdfPagesList({
    required String pdfPath,
    int? pageCount,
  }) async {
    List<PdfPageModel> pdfPages = [];
    int? pdfPageCount;

    pdfPageCount = pageCount ?? await getPdfPageCount(pdfPath: pdfPath);
    if (pdfPageCount != null) {
      pdfPages = List<PdfPageModel>.generate(
        pdfPageCount,
        (int index) => PdfPageModel(
          pageIndex: index,
          pageBytes: null,
          pageErrorStatus: false,
          pageSelected: false,
          pageRotationAngle: 0,
          pageHidden: false,
        ),
      );
    }

    return pdfPages;
  }

  static Future<Uint8List> getBytesFromFilePathOrUri({
    String? filePath,
    String? fileUri,
  }) async {
    Uint8List filedData;

    if (filePath != null) {
      File tempFile = File(filePath);
      if (tempFile.existsSync()) {
        filedData = tempFile.readAsBytesSync();
      } else {
        throw Exception('File not found at file path.');
      }
    } else if (fileUri != null) {
      String? path = await PickOrSave().cacheFilePathFromPath(
        params: CacheFilePathFromPathParams(filePath: fileUri),
      );
      if (path != null) {
        File tempFile = File(path);
        filedData = tempFile.readAsBytesSync();
        tempFile.deleteSync();
      } else {
        throw Exception('File cached file path from Uri was null.');
      }
    } else {
      throw Exception('File path and file uri both are null.');
    }
    if (filedData.isEmpty) {
      throw Exception('File byte data is empty.');
    }

    return filedData;
  }

  /// For saving files.
  static Future<List<String>?> saveFiles({
    required List<SaveFileInfo> saveFiles,
    List<String>? mimeTypesFilter,
  }) async {
    // Holds save result.
    List<String>? saveResult;

    try {
      // Saving the files and storing result paths in saveResult.
      saveResult = await PickOrSave().fileSaver(
        params: FileSaverParams(
          saveFiles: saveFiles,
          mimeTypesFilter: mimeTypesFilter,
        ),
      );
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    return saveResult;
  }
}
