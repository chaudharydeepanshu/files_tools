import 'dart:developer';

import 'package:files_tools/models/file_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pick_or_save/pick_or_save.dart';

import '../utils/format_bytes.dart';

class ToolScreenState extends ChangeNotifier {
  List<InputFileModel> _selectedFiles = [];
  List<InputFileModel> get selectedFiles => _selectedFiles;

  bool _isPickingFile = false;
  bool get isPickingFile => _isPickingFile;

  updateSelectedFiles({required List<InputFileModel> files}) {
    _selectedFiles = files;
    notifyListeners();
  }

  Future<void> _filePicker(FilePickerParams params) async {
    List<String>? result;
    try {
      updateFilePickingStatus(status: true);
      _isPickingFile = true;
      result = await PickOrSave().filePicker(params: params);
      // log(result.toString());
    } on PlatformException catch (e) {
      log(e.toString());
    }
    if (result != null && result.isNotEmpty) {
      List<InputFileModel> files = [];
      for (int i = 0; i < result.length; i++) {
        InputFileModel file = await getInputFileModelFromUri(uri: result[i]);
        files.add(file);
      }
      files = _selectedFiles + files;
      updateSelectedFiles(files: files);
    }
    updateFilePickingStatus(status: false);
  }

  updateFilePickingStatus({required bool status}) async {
    _isPickingFile = status;
    notifyListeners();
  }

  selectFiles({required FilePickerParams params}) async {
    _filePicker(params);
  }
}

Future<InputFileModel> getInputFileModelFromUri({required String uri}) async {
  InputFileModel file;
  FileMetadata fileMetadata = await PickOrSave()
      .fileMetaData(params: FileMetadataParams(sourceFileUri: uri));
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
      fileUri: uri);
  return file;
}
