class InputFileModel {
  final String fileName;
  final String fileDate;
  final String fileTime;
  final String fileSizeFormatBytes;
  final int fileSizeBytes;
  final String fileUri;

  InputFileModel({
    required this.fileName,
    required this.fileDate,
    required this.fileTime,
    required this.fileSizeFormatBytes,
    required this.fileSizeBytes,
    required this.fileUri,
  });

  // Implement toString to make it easier to see information
  // when using the print statement.
  @override
  String toString() {
    return 'FileModel{fileName: $fileName, fileDate: $fileDate, fileTime: $fileTime, fileSizeFormatBytes: $fileSizeFormatBytes, fileSizeBytes: $fileSizeBytes, fileUri: $fileUri}';
  }
}

class OutputFileModel {
  final String fileName;
  final String fileDate;
  final String fileTime;
  final String fileSize;
  final String filePath;

  OutputFileModel({
    required this.fileName,
    required this.fileDate,
    required this.fileTime,
    required this.fileSize,
    required this.filePath,
  });

  // Implement toString to make it easier to see information
  // when using the print statement.
  @override
  String toString() {
    return 'OutputFileModel{fileName: $fileName, fileDate: $fileDate, fileTime: $fileTime, fileSize: $fileSize, filePath: $filePath}';
  }
}
