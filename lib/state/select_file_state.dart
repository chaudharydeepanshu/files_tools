import 'dart:developer';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/select_image_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_bitmaps/pdf_bitmaps.dart';
import 'package:pick_or_save/pick_or_save.dart';
import '../main.dart';
import '../ui/components/custom_snack_bar.dart';
import '../utils/format_bytes.dart';

class ToolScreenState extends ChangeNotifier {
  List<InputFileModel> removedFiles = [];

  List<InputFileModel> _selectedFiles = [];
  List<InputFileModel> get selectedFiles => _selectedFiles;

  bool _isPickingFile = false;
  bool get isPickingFile => _isPickingFile;

  List<InputFileModel> removedImages = [];

  List<InputFileModel> _selectedImages = [];
  List<InputFileModel> get selectedImages => _selectedImages;

  bool _isPickingImage = false;
  bool get isPickingImage => _isPickingImage;

  updateSelectedFiles({required List<InputFileModel> files}) {
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
        InputFileModel file = await getInputFileModelFromUri(uri: result[i]);
        files.add(file);
      }
    }
    return files;
  }

  updateFilePickingStatus({required bool status}) {
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

  selectFiles(
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

  updateSelectedImages({required List<InputFileModel> images}) {
    _selectedImages = images;
    notifyListeners();
  }

  Future<List<InputFileModel>> _imagePicker(
      SelectImageType selectImageType) async {
    List<XFile>? result;
    try {
      updateImagePickingStatus(status: true);
      _isPickingImage = true;
      final ImagePicker picker = ImagePicker();
      if (selectImageType == SelectImageType.single) {
        XFile? pickedImage =
            await picker.pickImage(source: ImageSource.gallery);
        if (pickedImage == null) {
          result = null;
        } else {
          result = [pickedImage];
        }
      } else {
        result = await picker.pickMultiImage();
      }
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
            await getInputFileModelFromUri(path: result[i].path);
        files.add(file);
      }
    }
    return files;
  }

  updateImagePickingStatus({required bool status}) {
    _isPickingImage = status;

    BuildContext? context = navigatorKey.currentState?.context;
    if (context != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (removedImages.isNotEmpty) {
        String? contentText =
            "Discarded invalid or unsupported images:\n${List<String>.generate(removedImages.length, (int index) => removedImages[index].fileName).join("\n")}";
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

  selectImages(
      {required SelectImageType selectImageType,
      List<String>? allowedExtensions}) async {
    removedImages = [];

    _selectedImages = _selectedImages + await _imagePicker(selectImageType);

    removedImages = await imagesFiltering(
        images: _selectedImages, allowedExtensions: allowedExtensions ?? []);

    _selectedImages.removeWhere((element) =>
        removedImages.map((e) => e.fileUri).contains(element.fileUri));

    updateSelectedImages(images: _selectedImages);

    updateImagePickingStatus(status: false);
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
        extensionOfFile == ".pdf") {
      PdfValidityAndProtection? pdfValidityAndProtectionInfo =
          await PdfBitmaps().pdfValidityAndProtection(
              params: PDFValidityAndProtectionParams(pdfPath: element.fileUri));
      if (pdfValidityAndProtectionInfo == null) {
        InputFileModel temp = InputFileModel(
            fileName: "${element.fileName} (Invalid)",
            fileDate: element.fileDate,
            fileTime: element.fileTime,
            fileSizeFormatBytes: element.fileSizeFormatBytes,
            fileSizeBytes: element.fileSizeBytes,
            fileUri: element.fileUri);
        filesToRemoveFromSelection.add(temp);
      } else if (pdfValidityAndProtectionInfo.isPDFValid == false &&
          discardInvalidPdfFiles) {
        InputFileModel temp = InputFileModel(
            fileName: "${element.fileName} (Invalid)",
            fileDate: element.fileDate,
            fileTime: element.fileTime,
            fileSizeFormatBytes: element.fileSizeFormatBytes,
            fileSizeBytes: element.fileSizeBytes,
            fileUri: element.fileUri);
        filesToRemoveFromSelection.add(temp);
      } else if (pdfValidityAndProtectionInfo.isOpenPasswordProtected == true &&
          discardProtectedPdfFiles) {
        InputFileModel temp = InputFileModel(
            fileName: "${element.fileName} (Protected)",
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
          fileName: "${element.fileName} (Unsupported File Type)",
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

Future<InputFileModel> getInputFileModelFromUri(
    {String? uri, String? path}) async {
  InputFileModel file;
  FileMetadata fileMetadata;
  if (uri != null) {
    fileMetadata = await PickOrSave()
        .fileMetaData(params: FileMetadataParams(sourceFileUri: uri));
  } else {
    fileMetadata = await PickOrSave()
        .fileMetaData(params: FileMetadataParams(sourceFilePath: path));
  }
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
  final String fileSizeFormatBytes =
      fileMetadata.size != null && fileMetadata.size != "Unknown"
          ? formatBytes(bytes: int.parse(fileMetadata.size!), decimals: 2)
          : "Unknown";
  final int fileSizeBytes =
      fileMetadata.size != null && fileMetadata.size != "Unknown"
          ? int.parse(fileMetadata.size!)
          : 0;
  file = InputFileModel(
      fileName: fileName,
      fileDate: fileDate,
      fileTime: fileTime,
      fileSizeFormatBytes: fileSizeFormatBytes,
      fileSizeBytes: fileSizeBytes,
      fileUri: uri ?? path!);
  return file;
}
