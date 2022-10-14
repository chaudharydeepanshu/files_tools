import 'dart:developer';
import 'dart:io';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
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
}

class ToolsActionsState extends ChangeNotifier {
  List<OutputFileModel> _outputFiles = [];
  List<OutputFileModel> get outputFiles => _outputFiles;

  bool _actionErrorStatus = false;
  bool get actionErrorStatus => _actionErrorStatus;

  bool _isActionProcessing = false;
  bool get isActionProcessing => _isActionProcessing;

  bool _isSaveProcessing = false;
  bool get isSaveProcessing => _isSaveProcessing;

  bool _saveErrorStatus = false;
  bool get saveErrorStatus => _saveErrorStatus;

  late ToolsActions _currentActionType;
  ToolsActions get currentActionType => _currentActionType;

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
    } catch (e) {
      log(e.toString());
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
    }
    updateActionProcessingStatus(false);
    notifyListeners();
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
    } catch (e) {
      log(e.toString());
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
    }
    updateActionProcessingStatus(false);
    notifyListeners();
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
    String outputFileName = "Unknown File.pdf";
    try {
      updateActionType(ToolsActions.splitByPageCount);
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
    } catch (e) {
      log(e.toString());
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
    }
    updateActionProcessingStatus(false);
    notifyListeners();
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
    } catch (e) {
      log(e.toString());
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
    }
    updateActionProcessingStatus(false);
    notifyListeners();
  }

  void cancelAction() {
    updateActionProcessingStatus(true);
    try {
      PdfManipulator().cancelManipulations();
    } on PlatformException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
    updateActionProcessingStatus(false);
    notifyListeners();
  }

  updateActionErrorStatus(bool status) {
    _actionErrorStatus = status;
    notifyListeners();
  }

  updateActionProcessingStatus(bool status) {
    _isActionProcessing = status;
    notifyListeners();
  }

  updateSaveProcessingStatus(bool status) {
    _isSaveProcessing = status;
    notifyListeners();
  }

  updateActionType(ToolsActions actionType) {
    _currentActionType = actionType;
    notifyListeners();
  }

  Future<void> saveFile(
      {required List<OutputFileModel> files,
      required List<String>? mimeTypeFilter}) async {
    updateSaveProcessingStatus(true);
    List<String> pathsOfFilesToSave = List<String>.generate(
        files.length, (int index) => files[index].filePath);
    List<String> namesOfFilesToSave = List<String>.generate(
        files.length, (int index) => files[index].fileName);
    List<String>? result;
    try {
      result = await PickOrSave().fileSaver(
          params: FileSaverParams(
        filesNames: namesOfFilesToSave,
        sourceFilesPaths: pathsOfFilesToSave,
        mimeTypeFilter: mimeTypeFilter,
      ));
    } on PlatformException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
    if (result != null) {
    } else {
      _saveErrorStatus = true;
    }
    updateSaveProcessingStatus(false);
    notifyListeners();
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
  String fileExt = fileName.substring(fileName.lastIndexOf('.'));
  return fileExt;
}
