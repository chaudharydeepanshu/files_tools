import 'dart:developer';

import 'package:files_tools/main.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/ui/components/custom_snack_bar.dart';
import 'package:files_tools/utils/get_file_model_from_uri.dart';
import 'package:files_tools/utils/get_file_name_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_bitmaps/pdf_bitmaps.dart';
import 'package:pick_or_save/pick_or_save.dart';

class ToolScreenState extends ChangeNotifier {
  List<InputFileModel> removedFiles = [];

  List<InputFileModel> _selectedFiles = [];
  List<InputFileModel> get selectedFiles => _selectedFiles;

  bool _isPickingFile = false;
  bool get isPickingFile => _isPickingFile;

  void updateSelectedFiles({required List<InputFileModel> files}) {
    _selectedFiles = files;
    notifyListeners();
  }

  Future<List<InputFileModel>> _filePicker(FilePickerParams params) async {
    List<String>? result;
    try {
      updateFilePickingStatus(status: true);
      _isPickingFile = true;
      result = await PickOrSave().filePicker(params: params);
      // log(result.toString());
    } on PlatformException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
    List<InputFileModel> files = [];
    if (result != null && result.isNotEmpty) {
      for (int i = 0; i < result.length; i++) {
        InputFileModel file =
            await getInputFileModelFromUri(filePathOrUri: result[i]);
        files.add(file);
      }
    }
    return files;
  }

  void updateFilePickingStatus({required bool status}) {
    _isPickingFile = status;

    BuildContext? context = navigatorKey.currentState?.context;
    if (context != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (removedFiles.isNotEmpty) {
        String? contentText =
            "Discarded invalid or encrypted pdf files:\n${List<String>.generate(removedFiles.length, (int index) => removedFiles[index].fileName).join("\n")}";
        //'Oh...No! There is no old data available.';
        Color? backgroundColor = Theme.of(context).colorScheme.errorContainer;
        Duration? duration = const Duration(seconds: 20);
        IconData? iconData = Icons.warning;
        Color? iconAndTextColor = Theme.of(context).colorScheme.error;
        TextStyle? textStyle = Theme.of(context).textTheme.bodySmall;

        showCustomSnackBar(
          context: context,
          contentText: contentText,
          backgroundColor: backgroundColor,
          duration: duration,
          iconData: iconData,
          iconAndTextColor: iconAndTextColor,
          textStyle: textStyle,
        );
      }
    }

    notifyListeners();
  }

  void selectFiles(
      {required FilePickerParams params,
      required bool discardInvalidPdfFiles,
      required bool discardProtectedPdfFiles}) async {
    removedFiles = [];

    _selectedFiles = _selectedFiles + await _filePicker(params);

    removedFiles = await fileFiltering(
        files: selectedFiles,
        discardInvalidPdfFiles: discardInvalidPdfFiles,
        discardProtectedPdfFiles: discardProtectedPdfFiles);

    _selectedFiles.removeWhere((element) =>
        removedFiles.map((e) => e.fileUri).contains(element.fileUri));

    updateSelectedFiles(files: _selectedFiles);

    updateFilePickingStatus(status: false);
  }
}

Future<List<InputFileModel>> fileFiltering(
    {required List<InputFileModel> files,
    required bool discardInvalidPdfFiles,
    required bool discardProtectedPdfFiles}) async {
  List<InputFileModel> filesToRemoveFromSelection = [];
  for (var element in files) {
    String extensionOfFile = getFileNameExtension(fileName: element.fileName);
    if ((discardInvalidPdfFiles || discardProtectedPdfFiles) &&
        extensionOfFile == '.pdf') {
      PdfValidityAndProtection? pdfValidityAndProtectionInfo =
          await PdfBitmaps().pdfValidityAndProtection(
              params: PDFValidityAndProtectionParams(pdfPath: element.fileUri));
      if (pdfValidityAndProtectionInfo == null) {
        InputFileModel temp = InputFileModel(
            fileName: '${element.fileName} (Invalid)',
            fileDate: element.fileDate,
            fileTime: element.fileTime,
            fileSizeFormatBytes: element.fileSizeFormatBytes,
            fileSizeBytes: element.fileSizeBytes,
            fileUri: element.fileUri);
        filesToRemoveFromSelection.add(temp);
      } else if (pdfValidityAndProtectionInfo.isPDFValid == false &&
          discardInvalidPdfFiles) {
        InputFileModel temp = InputFileModel(
            fileName: '${element.fileName} (Invalid)',
            fileDate: element.fileDate,
            fileTime: element.fileTime,
            fileSizeFormatBytes: element.fileSizeFormatBytes,
            fileSizeBytes: element.fileSizeBytes,
            fileUri: element.fileUri);
        filesToRemoveFromSelection.add(temp);
      } else if (pdfValidityAndProtectionInfo.isOpenPasswordProtected == true &&
          discardProtectedPdfFiles) {
        InputFileModel temp = InputFileModel(
            fileName: '${element.fileName} (Protected)',
            fileDate: element.fileDate,
            fileTime: element.fileTime,
            fileSizeFormatBytes: element.fileSizeFormatBytes,
            fileSizeBytes: element.fileSizeBytes,
            fileUri: element.fileUri);
        filesToRemoveFromSelection.add(temp);
      }
    }
  }

  return filesToRemoveFromSelection;
}

Future<List<InputFileModel>> imagesFiltering(
    {required List<InputFileModel> images,
    required List<String> allowedExtensions}) async {
  List<InputFileModel> filesToRemoveFromSelection = [];
  for (var element in images) {
    String extensionOfFile =
        getFileNameExtension(fileName: element.fileName).toLowerCase();
    allowedExtensions = allowedExtensions.map((e) => e.toLowerCase()).toList();

    if (allowedExtensions.isNotEmpty &&
        !allowedExtensions.contains(extensionOfFile)) {
      InputFileModel temp = InputFileModel(
          fileName: '${element.fileName} (Unsupported File Type)',
          fileDate: element.fileDate,
          fileTime: element.fileTime,
          fileSizeFormatBytes: element.fileSizeFormatBytes,
          fileSizeBytes: element.fileSizeBytes,
          fileUri: element.fileUri);
      filesToRemoveFromSelection.add(temp);
    }
  }

  return filesToRemoveFromSelection;
}
