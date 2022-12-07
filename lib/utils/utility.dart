import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:files_tools/constants.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' as painting;
import 'package:flutter/services.dart';
import 'package:image_editor/image_editor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_bitmaps/pdf_bitmaps.dart';
import 'package:pick_or_save/pick_or_save.dart';
import 'package:url_launcher/url_launcher.dart';

/// A general utility class containing many small helpful methods which are
/// useful through out the app.
class Utility {
  /// For getting [ui.Image] object from provided [Uint8List].
  static Future<ui.Image> imageFromUint8List({
    required final Uint8List uint8list,
  }) async {
    return await painting.decodeImageFromList(uint8list);
  }

  /// For getting cached file path from provided file uri.
  static Future<String> getCachedFilePathFromFileUri({
    required final String fileUri,
  }) async {
    // Holds cached file path from uri path.
    String? cachedFilePath;

    try {
      // Getting cached file path and storing result path in cachedFilePath.
      cachedFilePath = await PickOrSave().cacheFilePathFromPath(
        params: CacheFilePathFromPathParams(filePath: fileUri),
      );
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }
    if (cachedFilePath == null) {
      throw 'Cached file path from Uri is null.';
    }

    return cachedFilePath;
  }

  /// For cleaning up a file name to make it suitable for saving in Android.
  static String getCleanedUpFileName(final String fileName) {
    return fileName.replaceAll(RegExp('[\\\\/:*?"<>|\\[\\]]'), '_');
  }

  /// For getting a file extension from provided file name.
  static String getFileNameExtension({required final String fileName}) {
    int indexOfLastDot = fileName.lastIndexOf('.');
    if (indexOfLastDot == -1) {
      return '';
    } else {
      String fileExt = fileName.substring(indexOfLastDot).toLowerCase();
      return fileExt;
    }
  }

  /// For getting a file name without extension from provided file name.
  static String getFileNameWithoutExtension({required final String fileName}) {
    String fileExt = getFileNameExtension(fileName: fileName);
    String fileNameWithoutExtension =
        fileName.substring(0, fileName.length - fileExt.length);
    return fileNameWithoutExtension;
  }

  /// For getting platform temporary directory used for save cache files.
  ///
  /// If a temporary directory doesn't exists in the device then it creates
  /// the directory and returns the created directory.
  static Future<Directory> getTempDirectory() async {
    Directory directory = await getTemporaryDirectory();

    if (!(await directory.exists())) {
      directory.create(recursive: true);
      log("Temporary directory didn't exist so created");
    }

    return directory;
  }

  /// For clearing platform temporary directory.
  static Future<void> clearTempDirectory({
    required final String clearCacheCommandFrom,
  }) async {
    Directory directory = await getTempDirectory();

    final List<FileSystemEntity> entities = await directory.list().toList();
    for (FileSystemEntity entity in entities) {
      if (!(await entity.exists())) {
        entity.deleteSync(recursive: true);
      }
    }

    log('Temporary directory emptied by $clearCacheCommandFrom');
  }

  /// For deleting selective files from platform through provided files paths.
  static Future<void> deleteSelectiveFiles({
    required final List<String> filesPaths,
    required final String deleteCommandFrom,
  }) async {
    for (String filePath in filesPaths) {
      File tempFile = File(filePath);
      if (!(await tempFile.exists())) {
        tempFile.delete();
      }
    }

    log('Selective files deleted by $deleteCommandFrom');
    log('Deleted files paths: $filesPaths');
  }

  /// For formatting file size bytes provided to human readable string.
  ///
  /// Can format provided bytes to string with numeral part having certain
  /// no. decimal range in a specific [BytesFormatType].
  ///
  /// We use 1000 as a factor(base 10) for conversion of byte to different
  /// formats instead of 1024(base 2). As Android file system compute file
  /// sizes in Mebibyte (MiB = 1024 KB), Gib, etc but it report results as
  /// Megabyte (MB = 1000 KB), GB, etc.
  static String formatBytes({
    required final int bytes,
    required final int decimals,
    final BytesFormatType? formatType,
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

  /// For getting [InputFileModel] from provided file uri.
  ///
  /// A [InputFileModel] can be used to get a file last modified date, time
  /// size in bytes, formatted size, file name used for displaying
  /// user, its picked files info in UI picking screen.
  static Future<InputFileModel> getInputFileModelFromUri({
    required final String filePathOrUri,
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
      fileTime = '${time.hourOfPeriod}:${time.minute} '
          '${time.period.name.toUpperCase()}';
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

  /// For getting [OutputFileModel] from provided file uri.
  ///
  /// A [OutputFileModel] can be used to get a file last modified date, time
  /// size in bytes, formatted size, file name used for displaying
  /// user, the processed result files info in UI result screen.
  static Future<OutputFileModel> getOutputFileModelFromPath({
    required final String filePathOrUri,
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
      fileTime = '${time.hourOfPeriod}:${time.minute} '
          '${time.period.name.toUpperCase()}';
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

  /// For getting [Uint8List] of the image of a PDF specific page.
  ///
  /// We can provide it further parameters to manipulate the image of that
  /// pdf page like image rotation, background color, scaling, etc.
  static Future<Uint8List?> getUint8ListOfPdfPageAsImage({
    required final int index,
    required final String pdfPath,
    final double? scale,
    final int? rotationAngle,
    final Color? backgroundColor,
    final PdfRendererType? pdfRendererType,
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
    } on PlatformException catch (e) {
      log(e.toString());
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }

    if (imageCachedPath != null) {
      bytes = File(imageCachedPath).readAsBytesSync();
    } else {
      throw 'Cached image path of a PDF page is null.';
    }

    return bytes;
  }

  /// For getting updated [PdfPageModel] which is used for holding data of the
  /// image of a PDF specific page.
  ///
  /// This method is generally used to update a dummy model of a PDF page with
  /// [Uint8List] of the image of that PDF page. This is helpful if we are
  /// working with large number of PDF pages and we don't want to create a
  /// complete model for each PDF page as that would be very slow and expensive.
  static Future<PdfPageModel> getUpdatedPdfPageModel({
    required final int index,
    required final String pdfPath,
    required final PdfPageModel pdfPageModel,
    final double? scale,
    final int? rotationAngle,
    final Color? backgroundColor,
    final PdfRendererType? pdfRendererType,
  }) async {
    Uint8List? bytes;

    try {
      bytes = await getUint8ListOfPdfPageAsImage(
        index: index,
        pdfPath: pdfPath,
        scale: scale,
        rotationAngle: rotationAngle,
        backgroundColor: backgroundColor,
        pdfRendererType: pdfRendererType,
      );
    } on PlatformException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }

    PdfPageModel updatedPdfPage = pdfPageModel.copyWith(
      pageBytes: bytes,
      pageErrorStatus: bytes == null,
    );

    return updatedPdfPage;
  }

  /// For getting page count of a PDF file through the provided PDF file path.
  static Future<int> getPdfPageCount({required final String pdfPath}) async {
    int? pdfPageCount;
    try {
      pdfPageCount = await PdfBitmaps()
          .pdfPageCount(params: PDFPageCountParams(pdfPath: pdfPath));
    } on PlatformException catch (e) {
      log(e.toString());
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }

    if (pdfPageCount == null) {
      throw 'Total page count of PDF is null.';
    }

    return pdfPageCount;
  }

  /// For generating a dummy list of [PdfPageModel] for a PDF through provided
  /// PDF file path and total page count.
  ///
  /// This is helpful if we are working with large number of PDF pages and
  /// we don't want to create a complete model for each PDF page as that would
  /// be very slow and expensive so instead we create list of dummy models.
  static Future<List<PdfPageModel>> generatePdfPagesList({
    required final String pdfPath,
    final int? pageCount,
  }) async {
    List<PdfPageModel> pdfPages = <PdfPageModel>[];
    int? pdfPageCount;

    try {
      pdfPageCount = pageCount ?? await getPdfPageCount(pdfPath: pdfPath);
    } on PlatformException catch (e) {
      log(e.toString());
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }

    pdfPages = List<PdfPageModel>.generate(
      pdfPageCount,
      (final int index) => PdfPageModel(
        pageIndex: index,
        pageBytes: null,
        pageErrorStatus: false,
        pageSelected: false,
        pageRotationAngle: 0,
        pageHidden: false,
      ),
    );

    return pdfPages;
  }

  /// For getting byte data as [Uint8List] of a file through the provided
  /// file path or file uri.
  static Future<Uint8List> getByteDataFromFilePathOrUri({
    final String? filePath,
    final String? fileUri,
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
      String? path;
      try {
        path = await PickOrSave().cacheFilePathFromPath(
          params: CacheFilePathFromPathParams(filePath: fileUri),
        );
      } on PlatformException catch (e) {
        log(e.toString());
        rethrow;
      } catch (e) {
        log(e.toString());
        rethrow;
      }

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

  /// Called for launching URLs through out the app.
  static Future<void> urlLauncher(final String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }

  /// Called to crop, rotate, flip an image based on [ExtendedImageEditorState].
  static Future<Uint8List?> modifyImage(
    final ExtendedImageEditorState currentState,
  ) async {
    Future<Uint8List?> cropImageDataWithNativeLibrary({
      required final ExtendedImageEditorState state,
    }) async {
      log('Native library start cropping');

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
          FlipOption(horizontal: flipHorizontal, vertical: flipVertical),
        );
      }

      if (action.hasRotateAngle) {
        option.addOption(RotateOption(rotateAngle));
      }

      final DateTime start = DateTime.now();
      final Uint8List? result = await ImageEditor.editImage(
        image: img,
        imageEditorOption: option,
      );

      log('${DateTime.now().difference(start)} ：total time');
      return result;
    }

    Uint8List? fileData =
        await cropImageDataWithNativeLibrary(state: currentState);

    return fileData;
  }
}
