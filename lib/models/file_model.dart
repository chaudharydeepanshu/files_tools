/// Model class for user picked files.
///
/// It hold all the useful information about a user picked file.
class InputFileModel {
  /// Defining [InputFileModel] constructor.
  InputFileModel({
    required this.fileName,
    required this.fileDate,
    required this.fileTime,
    required this.fileSizeFormatBytes,
    required this.fileSizeBytes,
    required this.fileUri,
  });

  /// User picked file name.
  final String fileName;

  /// User picked file last modified date in (DD/MM/YYYY) format.
  final String fileDate;

  /// User picked file last modified time in (hh:mm aa) format.
  final String fileTime;

  /// User picked file formatted size using [Utility.formatBytes].
  final String fileSizeFormatBytes;

  /// User picked file size as bytes unit.
  final int fileSizeBytes;

  /// User picked file Uri from platform.
  final String fileUri;

  /// Creates copy of InputFileModel object with the given
  /// values replaced with new values.
  InputFileModel copyWith({
    String? fileName,
    String? fileDate,
    String? fileTime,
    String? fileSizeFormatBytes,
    int? fileSizeBytes,
    String? fileUri,
  }) {
    return InputFileModel(
      fileName: fileName ?? this.fileName,
      fileDate: fileDate ?? this.fileDate,
      fileTime: fileTime ?? this.fileTime,
      fileSizeFormatBytes: fileSizeFormatBytes ?? this.fileSizeFormatBytes,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      fileUri: fileUri ?? this.fileUri,
    );
  }

  /// Overriding InputFileModel equality operator.
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

  /// Overriding InputFileModel hashCode.
  @override
  int get hashCode =>
      fileName.hashCode ^
      fileDate.hashCode ^
      fileTime.hashCode ^
      fileSizeFormatBytes.hashCode ^
      fileSizeBytes.hashCode ^
      fileUri.hashCode;

  /// Overriding InputFileModel toString to make it easier to see information.
  /// when using the print statement.
  @override
  String toString() {
    return 'FileModel{'
        'fileName: $fileName, '
        'fileDate: $fileDate, '
        'fileTime: $fileTime, '
        'fileSizeFormatBytes: $fileSizeFormatBytes, '
        'fileSizeBytes: $fileSizeBytes, '
        'fileUri: $fileUri '
        '}';
  }
}

/// Model class for app result files.
///
/// It hold all the useful information about a user picked file.
class OutputFileModel {
  /// Defining OutputFileModel constructor.
  const OutputFileModel({
    required this.fileName,
    required this.fileDate,
    required this.fileTime,
    required this.fileSizeFormatBytes,
    required this.fileSizeBytes,
    required this.filePath,
  });

  /// App result file name.
  final String fileName;

  /// App result file last modified date in (DD/MM/YYYY) format.
  final String fileDate;

  /// App result file last modified time in (hh:mm aa) format.
  final String fileTime;

  /// App result file formatted size using [Utility.formatBytes].
  final String fileSizeFormatBytes;

  /// App result file size as bytes unit.
  final int fileSizeBytes;

  /// App result cached file path.
  final String filePath;

  /// Creates copy of OutputFileModel object with the given
  /// values replaced with new values.
  OutputFileModel copyWith({
    String? fileName,
    String? fileDate,
    String? fileTime,
    String? fileSizeFormatBytes,
    int? fileSizeBytes,
    String? filePath,
  }) {
    return OutputFileModel(
      fileName: fileName ?? this.fileName,
      fileDate: fileDate ?? this.fileDate,
      fileTime: fileTime ?? this.fileTime,
      fileSizeFormatBytes: fileSizeFormatBytes ?? this.fileSizeFormatBytes,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      filePath: filePath ?? this.filePath,
    );
  }

  /// Overriding OutputFileModel equality operator.
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

  /// Overriding OutputFileModel hashCode.
  @override
  int get hashCode =>
      fileName.hashCode ^
      fileDate.hashCode ^
      fileTime.hashCode ^
      fileSizeFormatBytes.hashCode ^
      fileSizeBytes.hashCode ^
      filePath.hashCode;

  /// Overriding InputFileModel toString to make it easier to see information.
  /// when using the print statement.
  @override
  String toString() {
    return 'FileModel{'
        'fileName: $fileName, '
        'fileDate: $fileDate, '
        'fileTime: $fileTime, '
        'fileSizeFormatBytes: $fileSizeFormatBytes, '
        'fileSizeBytes: $fileSizeBytes, '
        'filePath: $filePath '
        '}';
  }
}
