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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputFileModel &&
          runtimeType == other.runtimeType &&
          fileName == other.fileName &&
          fileDate == other.fileDate &&
          fileTime == other.fileTime &&
          fileSizeFormatBytes == other.fileSizeFormatBytes &&
          fileSizeBytes == other.fileSizeBytes &&
          fileUri == other.fileUri;

  @override
  int get hashCode =>
      fileName.hashCode ^
      fileDate.hashCode ^
      fileTime.hashCode ^
      fileSizeFormatBytes.hashCode ^
      fileSizeBytes.hashCode ^
      fileUri.hashCode;

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
  final String fileSizeFormatBytes;
  final int fileSizeBytes;
  final String filePath;

  OutputFileModel({
    required this.fileName,
    required this.fileDate,
    required this.fileTime,
    required this.fileSizeFormatBytes,
    required this.fileSizeBytes,
    required this.filePath,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutputFileModel &&
          runtimeType == other.runtimeType &&
          fileName == other.fileName &&
          fileDate == other.fileDate &&
          fileTime == other.fileTime &&
          fileSizeFormatBytes == other.fileSizeFormatBytes &&
          fileSizeBytes == other.fileSizeBytes &&
          filePath == other.filePath;

  @override
  int get hashCode =>
      fileName.hashCode ^
      fileDate.hashCode ^
      fileTime.hashCode ^
      fileSizeFormatBytes.hashCode ^
      fileSizeBytes.hashCode ^
      filePath.hashCode;

  // Implement toString to make it easier to see information
  // when using the print statement.
  @override
  String toString() {
    return 'OutputFileModel{fileName: $fileName, fileDate: $fileDate, fileTime: $fileTime, fileSizeFormatBytes: $fileSizeFormatBytes, fileSizeBytes: $fileSizeBytes, filePath: $filePath}';
  }
}
