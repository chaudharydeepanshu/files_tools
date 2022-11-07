import 'dart:developer';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/utils/clear_cache.dart';
import 'package:files_tools/utils/edit_image.dart';
import 'package:files_tools/utils/get_pdf_bitmaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';
import 'package:pick_or_save/pick_or_save.dart';

import '../utils/format_bytes.dart';

enum ToolsActions {
  merge,
  splitByPageCount,
  splitByByteSize,
  splitByPageNumbers,
  splitByPageRanges,
  splitByPageRange,
  modify,
  convertToImage,
  compress,
  watermark,
  encrypt,
  decrypt,
  imageToPDF,
}

class ToolsActionsState extends ChangeNotifier {
  List<OutputFileModel> _outputFiles = [];
  List<OutputFileModel> get outputFiles => _outputFiles;

  bool _actionErrorStatus = false;
  bool get actionErrorStatus => _actionErrorStatus;

  String _errorMessage = "Unknown error";
  String get errorMessage => _errorMessage;

  bool _isActionProcessing = false;
  bool get isActionProcessing => _isActionProcessing;

  bool _isSaveProcessing = false;
  bool get isSaveProcessing => _isSaveProcessing;

  bool _saveErrorStatus = false;
  bool get saveErrorStatus => _saveErrorStatus;

  late ToolsActions _currentActionType;
  ToolsActions get currentActionType => _currentActionType;

  bool _mounted = true;
  bool get mounted => _mounted;

  @override
  void dispose() {
    super.dispose();
    _mounted = false;
  }

  Future<void> mergeSelectedFiles({required List<InputFileModel> files}) async {
    updateActionErrorStatus(false);
    updateActionProcessingStatus(true);
    updateActionType(ToolsActions.merge);
    List<String> uriPathsOfFilesToMerge = List<String>.generate(
        files.length, (int index) => files[index].fileUri);
    String? result;
    try {
      result = await PdfManipulator().mergePDFs(
          params: PDFMergerParams(
        pdfsPaths: uriPathsOfFilesToMerge,
      ));
    } on PlatformException catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    } catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    }
    if (result != null) {
      OutputFileModel file = await getOutputFileModelFromPath(path: result);
      DateTime currentDateTime = DateTime.now();
      _outputFiles = [
        OutputFileModel(
            fileName: "Merged File $currentDateTime.pdf",
            fileDate: file.fileDate,
            fileTime: file.fileTime,
            fileSize: file.fileSize,
            filePath: file.filePath)
      ];
    } else {
      updateActionErrorStatus(true);

      // We can use this place to get the exact time of cancellation action.
      // But don't just put clear cache here as at this state user may have started another task.
      // So we avoid clearing cache here as we don't want the user to wait till cancellation for next task will.
    }
    updateActionProcessingStatus(false);
    customNotifyListener();
  }

  Future<void> splitSelectedFile({
    required List<InputFileModel> files,
    int? pageCount,
    int? byteSize,
    List<int>? pageNumbers,
    List<String>? pageRanges,
    String? pageRange,
  }) async {
    updateActionErrorStatus(false);
    updateActionProcessingStatus(true);
    String nameOfFileToSplit = files[0].fileName;
    String extensionOfFileToSplit =
        getFileNameExtension(fileName: nameOfFileToSplit);
    String nameOfFileToSplitWithoutExtension =
        getFileNameWithoutExtension(fileName: nameOfFileToSplit);
    String uriPathOfFileToSplit = files[0].fileUri;
    List<String>? result;
    List<String> outputFilesNames = [];
    try {
      if (pageCount != null) {
        updateActionType(ToolsActions.splitByPageCount);
        result = await PdfManipulator().splitPDF(
            params: PDFSplitterParams(
          pdfPath: uriPathOfFileToSplit,
          pageCount: pageCount,
        ));
        if (result != null) {
          outputFilesNames = List<String>.generate(result.length, (int index) {
            DateTime currentDateTime = DateTime.now();
            return "$nameOfFileToSplitWithoutExtension - ${index + 1} - $currentDateTime$extensionOfFileToSplit";
          }, growable: false);
        }
      } else if (byteSize != null) {
        updateActionType(ToolsActions.splitByByteSize);
        result = await PdfManipulator().splitPDF(
            params: PDFSplitterParams(
          pdfPath: uriPathOfFileToSplit,
          byteSize: byteSize,
        ));
        if (result != null) {
          outputFilesNames = List<String>.generate(result.length, (int index) {
            DateTime currentDateTime = DateTime.now();
            return "$nameOfFileToSplitWithoutExtension - ${index + 1} - $currentDateTime$extensionOfFileToSplit";
          }, growable: false);
        }
      } else if (pageNumbers != null) {
        updateActionType(ToolsActions.splitByPageNumbers);
        result = await PdfManipulator().splitPDF(
            params: PDFSplitterParams(
          pdfPath: uriPathOfFileToSplit,
          pageNumbers: pageNumbers,
        ));
        if (result != null) {
          outputFilesNames = List<String>.generate(result.length, (int index) {
            DateTime currentDateTime = DateTime.now();
            return "$nameOfFileToSplitWithoutExtension - ${index + 1} - $currentDateTime$extensionOfFileToSplit";
          }, growable: false);
        }
      } else if (pageRange != null) {
        updateActionType(ToolsActions.splitByPageRange);
        result = await PdfManipulator().splitPDF(
            params: PDFSplitterParams(
          pdfPath: uriPathOfFileToSplit,
          pageRange: pageRange,
        ));
        if (result != null) {
          outputFilesNames = List<String>.generate(result.length, (int index) {
            DateTime currentDateTime = DateTime.now();
            return "$nameOfFileToSplitWithoutExtension - ${index + 1} - $currentDateTime$extensionOfFileToSplit";
          }, growable: false);
        }
      } else if (pageRanges != null) {
        updateActionType(ToolsActions.splitByPageRanges);
        result = await PdfManipulator().splitPDF(
            params: PDFSplitterParams(
          pdfPath: uriPathOfFileToSplit,
          pageRanges: pageRanges,
        ));
      }
    } on PlatformException catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    } catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    }
    if (result != null && result.isNotEmpty) {
      outputFiles.clear();
      for (int i = 0; i < result.length; i++) {
        OutputFileModel file =
            await getOutputFileModelFromPath(path: result[i]);
        file = OutputFileModel(
            fileName: outputFilesNames[i],
            fileDate: file.fileDate,
            fileTime: file.fileTime,
            fileSize: file.fileSize,
            filePath: file.filePath);
        outputFiles.add(file);
      }
    } else {
      updateActionErrorStatus(true);

      // We can use this place to get the exact time of cancellation action.
      // But don't just put clear cache here as at this state user may have started another task.
      // So we avoid clearing cache here as we don't want the user to wait till cancellation for next task will.
    }
    updateActionProcessingStatus(false);
    customNotifyListener();
  }

  Future<void> modifySelectedFile({
    required List<InputFileModel> files,
    List<PageRotationInfo>? pagesRotationInfo,
    List<int>? pageNumbersForReorder,
    List<int>? pageNumbersForDeleter,
  }) async {
    updateActionErrorStatus(false);
    updateActionProcessingStatus(true);
    String nameOfFileToSplit = files[0].fileName;
    String extensionOfFileToSplit =
        getFileNameExtension(fileName: nameOfFileToSplit);
    String nameOfFileToSplitWithoutExtension =
        getFileNameWithoutExtension(fileName: nameOfFileToSplit);
    String uriPathOfFileToModify = files[0].fileUri;
    String? result;
    String outputFileName = "Unknown File$extensionOfFileToSplit";
    try {
      updateActionType(ToolsActions.modify);
      result = await PdfManipulator().pdfPageRotatorDeleterReorder(
          params: PDFPageRotatorDeleterReorderParams(
        pdfPath: uriPathOfFileToModify,
        pagesRotationInfo: pagesRotationInfo,
        pageNumbersForDeleter: pageNumbersForDeleter,
        pageNumbersForReorder: pageNumbersForReorder,
      ));

      if (result != null) {
        DateTime currentDateTime = DateTime.now();
        outputFileName =
            "$nameOfFileToSplitWithoutExtension - $currentDateTime$extensionOfFileToSplit";
      }
    } on PlatformException catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    } catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    }
    if (result != null && result.isNotEmpty) {
      outputFiles.clear();
      OutputFileModel file = await getOutputFileModelFromPath(path: result);
      file = OutputFileModel(
          fileName: outputFileName,
          fileDate: file.fileDate,
          fileTime: file.fileTime,
          fileSize: file.fileSize,
          filePath: file.filePath);
      outputFiles.add(file);
    } else {
      updateActionErrorStatus(true);

      // We can use this place to get the exact time of cancellation action.
      // But don't just put clear cache here as at this state user may have started another task.
      // So we avoid clearing cache here as we don't want the user to wait till cancellation for next task will.
    }
    updateActionProcessingStatus(false);
    customNotifyListener();
  }

  Future<void> convertSelectedFile({
    required List<InputFileModel> files,
    required List<PdfPageModel> selectedPages,
    double? imageScaling,
  }) async {
    updateActionErrorStatus(false);
    updateActionProcessingStatus(true);
    String nameOfFileToConvert = files[0].fileName;
    // String extensionOfFileToCovert =
    //     getFileNameExtension(fileName: nameOfFileToConvert);
    String nameOfFileToConvertWithoutExtension =
        getFileNameWithoutExtension(fileName: nameOfFileToConvert);
    String uriPathOfFileToConvert = files[0].fileUri;
    List<String> result = [];
    List<String> outputFilesNames = [];
    try {
      if (imageScaling != null) {
        String imageTypeExtension = ".png";
        updateActionType(ToolsActions.convertToImage);
        String tempPath = (await getTemporaryDirectory()).path;
        for (var page in selectedPages) {
          Uint8List? pageBytes;
          pageBytes = await getPdfPageBitmap(
              index: page.pageIndex,
              pdfPath: uriPathOfFileToConvert,
              scale: imageScaling,
              rotationAngle: page.pageRotationAngle);
          DateTime currentDateTime = DateTime.now();
          File file = File('$tempPath/$currentDateTime$imageTypeExtension');
          await file.writeAsBytes(pageBytes!.buffer
              .asUint8List(pageBytes.offsetInBytes, pageBytes.lengthInBytes));
          result.add(file.path);
        }
        outputFilesNames = List<String>.generate(result.length, (int index) {
          DateTime currentDateTime = DateTime.now();
          return "$nameOfFileToConvertWithoutExtension - ${index + 1} - $currentDateTime$imageTypeExtension";
        }, growable: false);
      }
    } on PlatformException catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    } catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    }
    if (result.isNotEmpty) {
      outputFiles.clear();
      for (int i = 0; i < result.length; i++) {
        OutputFileModel file =
            await getOutputFileModelFromPath(path: result[i]);
        file = OutputFileModel(
            fileName: outputFilesNames[i],
            fileDate: file.fileDate,
            fileTime: file.fileTime,
            fileSize: file.fileSize,
            filePath: file.filePath);
        outputFiles.add(file);
      }
    } else {
      updateActionErrorStatus(true);

      // We can use this place to get the exact time of cancellation action.
      // But don't just put clear cache here as at this state user may have started another task.
      // So we avoid clearing cache here as we don't want the user to wait till cancellation for next task will.
    }
    updateActionProcessingStatus(false);
    customNotifyListener();
  }

  Future<void> compressSelectedFile({
    required List<InputFileModel> files,
    double? imageScale,
    int? imageQuality,
    bool? unEmbedFonts,
  }) async {
    updateActionErrorStatus(false);
    updateActionProcessingStatus(true);
    String nameOfFileToCompress = files[0].fileName;
    String extensionOfFileToCompress =
        getFileNameExtension(fileName: nameOfFileToCompress);
    String nameOfFileToCompressWithoutExtension =
        getFileNameWithoutExtension(fileName: nameOfFileToCompress);
    String uriPathOfFileToCompress = files[0].fileUri;
    String? result;
    String outputFileName = "Unknown File$extensionOfFileToCompress";
    try {
      updateActionType(ToolsActions.compress);
      result = await PdfManipulator().pdfCompressor(
          params: PDFCompressorParams(
        pdfPath: uriPathOfFileToCompress,
        imageScale: imageScale ?? 1,
        imageQuality: imageQuality ?? 100,
        unEmbedFonts: unEmbedFonts ?? false,
      ));
      if (result != null) {
        DateTime currentDateTime = DateTime.now();
        outputFileName =
            "$nameOfFileToCompressWithoutExtension - Compressed - $currentDateTime$extensionOfFileToCompress";
      }
    } on PlatformException catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    } catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    }
    if (result != null && result.isNotEmpty) {
      outputFiles.clear();
      OutputFileModel file = await getOutputFileModelFromPath(path: result);
      file = OutputFileModel(
          fileName: outputFileName,
          fileDate: file.fileDate,
          fileTime: file.fileTime,
          fileSize: file.fileSize,
          filePath: file.filePath);
      outputFiles.add(file);
    } else {
      updateActionErrorStatus(true);

      // We can use this place to get the exact time of cancellation action.
      // But don't just put clear cache here as at this state user may have started another task.
      // So we avoid clearing cache here as we don't want the user to wait till cancellation for next task will.
    }
    updateActionProcessingStatus(false);
    customNotifyListener();
  }

  Future<void> watermarkSelectedFile({
    required List<InputFileModel> files,
    required String text,
    double? fontSize,
    WatermarkLayer? watermarkLayer,
    double? opacity,
    double? rotationAngle,
    Color? watermarkColor,
    PositionType? positionType,
  }) async {
    updateActionErrorStatus(false);
    updateActionProcessingStatus(true);
    String nameOfFileToWatermark = files[0].fileName;
    String extensionOfFileToWatermark =
        getFileNameExtension(fileName: nameOfFileToWatermark);
    String nameOfFileToWatermarkWithoutExtension =
        getFileNameWithoutExtension(fileName: nameOfFileToWatermark);
    String uriPathOfFileToWatermark = files[0].fileUri;
    String? result;
    String outputFileName = "Unknown File$extensionOfFileToWatermark";
    try {
      updateActionType(ToolsActions.watermark);
      result = await PdfManipulator().pdfWatermark(
          params: PDFWatermarkParams(
        pdfPath: uriPathOfFileToWatermark,
        text: text,
        fontSize: fontSize ?? 30,
        watermarkLayer: watermarkLayer ?? WatermarkLayer.overContent,
        opacity: opacity ?? 0.5,
        rotationAngle: rotationAngle ?? 45,
        watermarkColor: watermarkColor ?? Colors.black,
        positionType: positionType ?? PositionType.center,
      ));
      if (result != null) {
        DateTime currentDateTime = DateTime.now();
        outputFileName =
            "$nameOfFileToWatermarkWithoutExtension - Watermarked - $currentDateTime$extensionOfFileToWatermark";
      }
    } on PlatformException catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    } catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    }
    if (result != null && result.isNotEmpty) {
      outputFiles.clear();
      OutputFileModel file = await getOutputFileModelFromPath(path: result);
      file = OutputFileModel(
          fileName: outputFileName,
          fileDate: file.fileDate,
          fileTime: file.fileTime,
          fileSize: file.fileSize,
          filePath: file.filePath);
      outputFiles.add(file);
    } else {
      updateActionErrorStatus(true);

      // We can use this place to get the exact time of cancellation action.
      // But don't just put clear cache here as at this state user may have started another task.
      // So we avoid clearing cache here as we don't want the user to wait till cancellation for next task will.
    }
    updateActionProcessingStatus(false);
    customNotifyListener();
  }

  Future<void> encryptSelectedFile({
    required List<InputFileModel> files,
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
    updateActionErrorStatus(false);
    updateActionProcessingStatus(true);
    String nameOfFileToEncrypt = files[0].fileName;
    String extensionOfFileToEncrypt =
        getFileNameExtension(fileName: nameOfFileToEncrypt);
    String nameOfFileToEncryptWithoutExtension =
        getFileNameWithoutExtension(fileName: nameOfFileToEncrypt);
    String uriPathOfFileToEncrypt = files[0].fileUri;
    String? result;
    String outputFileName = "Unknown File$extensionOfFileToEncrypt";
    try {
      updateActionType(ToolsActions.encrypt);
      result = await PdfManipulator().pdfEncryption(
          params: PDFEncryptionParams(
        pdfPath: uriPathOfFileToEncrypt,
        ownerPassword: ownerPassword ?? "",
        userPassword: userPassword ?? "",
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
      ));
      if (result != null) {
        DateTime currentDateTime = DateTime.now();
        outputFileName =
            "$nameOfFileToEncryptWithoutExtension - Encrypted - $currentDateTime$extensionOfFileToEncrypt";
      }
    } on PlatformException catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    } catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    }
    if (result != null && result.isNotEmpty) {
      outputFiles.clear();
      OutputFileModel file = await getOutputFileModelFromPath(path: result);
      file = OutputFileModel(
          fileName: outputFileName,
          fileDate: file.fileDate,
          fileTime: file.fileTime,
          fileSize: file.fileSize,
          filePath: file.filePath);
      outputFiles.add(file);
    } else {
      updateActionErrorStatus(true);

      // We can use this place to get the exact time of cancellation action.
      // But don't just put clear cache here as at this state user may have started another task.
      // So we avoid clearing cache here as we don't want the user to wait till cancellation for next task will.
    }
    updateActionProcessingStatus(false);
    customNotifyListener();
  }

  Future<void> decryptSelectedFile({
    required List<InputFileModel> files,
    String? password,
  }) async {
    updateActionErrorStatus(false);
    updateActionProcessingStatus(true);
    String nameOfFileToDecrypt = files[0].fileName;
    String extensionOfFileToDecrypt =
        getFileNameExtension(fileName: nameOfFileToDecrypt);
    String nameOfFileToDecryptWithoutExtension =
        getFileNameWithoutExtension(fileName: nameOfFileToDecrypt);
    String uriPathOfFileToDecrypt = files[0].fileUri;
    String? result;
    String outputFileName = "Unknown File$extensionOfFileToDecrypt";
    try {
      updateActionType(ToolsActions.decrypt);
      result = await PdfManipulator().pdfDecryption(
          params: PDFDecryptionParams(
        pdfPath: uriPathOfFileToDecrypt,
        password: password ?? "",
      ));
      if (result != null) {
        DateTime currentDateTime = DateTime.now();
        outputFileName =
            "$nameOfFileToDecryptWithoutExtension - Decrypted - $currentDateTime$extensionOfFileToDecrypt";
      }
    } on PlatformException catch (e) {
      log(e.toString());
      if (e.toString().contains("BadPasswordException")) {
        _errorMessage = "Password provided was wrong";
      } else {
        _errorMessage = e.toString();
      }
    } catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    }
    if (result != null && result.isNotEmpty) {
      outputFiles.clear();
      OutputFileModel file = await getOutputFileModelFromPath(path: result);
      file = OutputFileModel(
          fileName: outputFileName,
          fileDate: file.fileDate,
          fileTime: file.fileTime,
          fileSize: file.fileSize,
          filePath: file.filePath);
      outputFiles.add(file);
    } else {
      updateActionErrorStatus(true);
      // We can use this place to get the exact time of cancellation action.
      // But don't just put clear cache here as at this state user may have started another task.
      // So we avoid clearing cache here as we don't want the user to wait till cancellation for next task will.
    }
    updateActionProcessingStatus(false);
    customNotifyListener();
  }

  Future<void> imageToPdf({
    required List<InputFileModel> files,
    required bool createSinglePdf,
    required List<GlobalKey<ExtendedImageEditorState>> editorKeys,
  }) async {
    updateActionErrorStatus(false);
    updateActionProcessingStatus(true);
    updateActionType(ToolsActions.imageToPDF);
    List<String>? result;
    List<String> outputFilesNames = [];
    try {
      List<InputFileModel> images = [];
      for (int i = 0; i < files.length; i++) {
        ExtendedImageEditorState? currentState = editorKeys[i].currentState;
        InputFileModel image = files[i];
        if (currentState != null) {
          Uint8List? imageData = await modifyImage(currentState);
          Directory tempDir = await getTemporaryDirectory();
          String tempPath = tempDir.path;
          // Directory appDocDir = await getApplicationDocumentsDirectory();
          // String appDocPath = appDocDir.path;
          String nameOfFile = image.fileName;
          String imageTypeExtension =
              getFileNameExtension(fileName: nameOfFile);
          DateTime currentDateTime = DateTime.now();
          File file = File('$tempPath/$currentDateTime$imageTypeExtension');
          await file.writeAsBytes(imageData!.buffer
              .asUint8List(imageData.offsetInBytes, imageData.lengthInBytes));
          image = InputFileModel(
              fileName: image.fileName,
              fileDate: image.fileDate,
              fileTime: image.fileTime,
              fileSizeFormatBytes: image.fileSizeFormatBytes,
              fileSizeBytes: image.fileSizeBytes,
              fileUri: file.path);
        }
        images.add(image);
      }

      List<String> uriPathsOfImages = List<String>.generate(
          images.length, (int index) => images[index].fileUri);

      result = await PdfManipulator().imagesToPdfs(
          params: ImagesToPDFsParams(
        imagesPaths: uriPathsOfImages,
        createSinglePdf: createSinglePdf,
      ));
      if (result != null) {
        DateTime currentDateTime = DateTime.now();
        outputFilesNames = List.generate(result.length, (index) {
          String nameOfFile = files[index].fileName;
          String nameOfFileWithoutExtension =
              getFileNameWithoutExtension(fileName: nameOfFile);
          return "$nameOfFileWithoutExtension - $currentDateTime.pdf";
        });
      }
    } on PlatformException catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    } catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    }
    if (result != null && result.isNotEmpty) {
      outputFiles.clear();
      for (int i = 0; i < result.length; i++) {
        OutputFileModel file =
            await getOutputFileModelFromPath(path: result[i]);
        file = OutputFileModel(
            fileName: outputFilesNames[i],
            fileDate: file.fileDate,
            fileTime: file.fileTime,
            fileSize: file.fileSize,
            filePath: file.filePath);
        outputFiles.add(file);
      }
    } else {
      updateActionErrorStatus(true);

      // We can use this place to get the exact time of cancellation action.
      // But don't just put clear cache here as at this state user may have started another task.
      // So we avoid clearing cache here as we don't want the user to wait till cancellation for next task will.
    }
    updateActionProcessingStatus(false);
    customNotifyListener();
  }

  void cancelAction() {
    clearCache(clearCacheCommandFrom: "Cancel Running Action");
    updateActionProcessingStatus(true);
    try {
      PdfManipulator().cancelManipulations();
    } on PlatformException catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    } catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    }
    updateActionProcessingStatus(false);
    customNotifyListener();
  }

  void cancelFileSaving() {
    try {
      PickOrSave().cancelFilesSaving();
    } on PlatformException catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    } catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    }
    updateSaveProcessingStatus(false);
    customNotifyListener();
  }

  updateActionErrorStatus(bool status) {
    _actionErrorStatus = status;
    customNotifyListener();
  }

  updateActionProcessingStatus(bool status) {
    _isActionProcessing = status;
    customNotifyListener();
  }

  updateSaveProcessingStatus(bool status) {
    _isSaveProcessing = status;
    customNotifyListener();
  }

  updateActionType(ToolsActions actionType) {
    _currentActionType = actionType;
    customNotifyListener();
  }

  void customNotifyListener() {
    // Using mounted because the state might be disposed when the cancellation was in progress due to manual cancellation.
    // And once cancellation completes it get called.
    if (_mounted) {
      notifyListeners();
    }
  }

  Future<void> saveFile(
      {required List<OutputFileModel> files,
      List<String>? mimeTypesFilter}) async {
    updateSaveProcessingStatus(true);
    List<SaveFileInfo> saveFiles = List<SaveFileInfo>.generate(
        files.length,
        (int index) => SaveFileInfo(
            filePath: files[index].filePath, fileName: files[index].fileName));
    List<String>? result;
    try {
      result = await PickOrSave().fileSaver(
          params: FileSaverParams(
        saveFiles: saveFiles,
        mimeTypesFilter: mimeTypesFilter,
      ));
    } on PlatformException catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    } catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
    }
    if (result != null) {
    } else {
      _saveErrorStatus = true;
    }
    updateSaveProcessingStatus(false);
    customNotifyListener();
  }
}

Future<OutputFileModel> getOutputFileModelFromPath(
    {required String path}) async {
  OutputFileModel file;
  FileMetadata fileMetadata = await PickOrSave()
      .fileMetaData(params: FileMetadataParams(sourceFilePath: path));
  final String fileName = fileMetadata.displayName ?? "Unknown";
  final DateTime? lastModifiedDateTime;
  if (fileMetadata.lastModified != null &&
      fileMetadata.lastModified != "Unknown") {
    lastModifiedDateTime = DateTime.parse(fileMetadata.lastModified!);
  } else {
    lastModifiedDateTime = null;
  }
  final String fileDate = lastModifiedDateTime != null
      ? "${lastModifiedDateTime.day}/${lastModifiedDateTime.month}/${lastModifiedDateTime.year}"
      : "Unknown";
  final String fileTime = lastModifiedDateTime != null
      ? "${lastModifiedDateTime.hour}:${lastModifiedDateTime.minute}"
      : "Unknown";
  final String fileSize =
      fileMetadata.size != null && fileMetadata.size != "Unknown"
          ? formatBytes(bytes: int.parse(fileMetadata.size!), decimals: 2)
          : "Unknown";
  file = OutputFileModel(
      fileName: fileName,
      fileDate: fileDate,
      fileTime: fileTime,
      fileSize: fileSize,
      filePath: path);
  return file;
}

String getFileNameWithoutExtension({required String fileName}) {
  String fileExt = fileName.substring(fileName.lastIndexOf('.'));
  String fileNameWithoutExtension =
      fileName.substring(0, fileName.length - fileExt.length);
  return fileNameWithoutExtension;
}

String getFileNameExtension({required String fileName}) {
  int indexOfLastDot = fileName.lastIndexOf('.');
  if (indexOfLastDot == -1) {
    return "";
  } else {
    String fileExt = fileName.substring(indexOfLastDot).toLowerCase();
    return fileExt;
  }
}
