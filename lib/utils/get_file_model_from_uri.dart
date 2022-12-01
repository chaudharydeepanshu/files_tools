import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/utils/format_bytes.dart';
import 'package:flutter/material.dart';
import 'package:pick_or_save/pick_or_save.dart';

Future<InputFileModel> getInputFileModelFromUri(
    {required String filePathOrUri}) async {
  FileMetadata fileMetadata;
  fileMetadata = await PickOrSave()
      .fileMetaData(params: FileMetadataParams(filePath: filePathOrUri));
  final String fileName = fileMetadata.displayName ?? 'Unknown';
  final DateTime? lastModifiedDateTime;
  if (fileMetadata.lastModified != null &&
      fileMetadata.lastModified != 'Unknown') {
    lastModifiedDateTime = DateTime.parse(fileMetadata.lastModified!).toLocal();
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
  final String fileSizeFormatBytes =
      fileMetadata.size != null && fileMetadata.size != 'Unknown'
          ? formatBytes(bytes: int.parse(fileMetadata.size!), decimals: 2)
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
      fileUri: filePathOrUri);
  return file;
}

Future<OutputFileModel> getOutputFileModelFromPath(
    {required String filePathOrUri}) async {
  FileMetadata fileMetadata;
  fileMetadata = await PickOrSave()
      .fileMetaData(params: FileMetadataParams(filePath: filePathOrUri));
  final String fileName = fileMetadata.displayName ?? 'Unknown';
  final DateTime? lastModifiedDateTime;
  if (fileMetadata.lastModified != null &&
      fileMetadata.lastModified != 'Unknown') {
    lastModifiedDateTime = DateTime.parse(fileMetadata.lastModified!).toLocal();
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
  final String fileSizeFormatBytes =
      fileMetadata.size != null && fileMetadata.size != 'Unknown'
          ? formatBytes(bytes: int.parse(fileMetadata.size!), decimals: 2)
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
      filePath: filePathOrUri);
  return file;
}
