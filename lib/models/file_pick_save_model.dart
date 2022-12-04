import 'package:files_tools/models/file_model.dart';
import 'package:pick_or_save/pick_or_save.dart';

/// Model class for defining file picking action through out the app.
///
/// It hold all the useful information about a picking action to use for
/// designing android picker experience and app UI.
class FilePickModel {
  /// Defining FilePickingModel constructor.
  const FilePickModel({
    this.allowedExtensions,
    this.mimeTypesFilter,
    this.localOnly = false,
    this.getCachedFilePath = false,
    this.pickerType = PickerType.file,
    this.enableMultipleSelection = false,
    this.discardInvalidPdfFiles = false,
    this.discardProtectedPdfFiles = false,
    this.multipleFilePickRequired = false,
    this.continuePicking = false,
  });

  /// Provide allowed extensions (null allows all extensions).
  final List<String>? allowedExtensions;

  /// Filter MIME types.
  final List<String>? mimeTypesFilter;

  /// Show only device local files. Defaults to false.
  final bool localOnly;

  /// Copy file to cache directory. Defaults to false.
  final bool getCachedFilePath;

  /// Picker types for (file, photo).Defaults to PickerType.file.
  final PickerType pickerType;

  /// To pick multiple files set this to true. Defaults to false.
  final bool enableMultipleSelection;

  /// To discard picked invalid PDF files set this to true. Defaults to false.
  final bool discardInvalidPdfFiles;

  /// To discard picked protected PDF files set this to true. Defaults to false.
  final bool discardProtectedPdfFiles;

  /// Set true to mark picking multiple file required. Defaults to false.
  /// It will in no way affect the picking experience in any state.
  /// Used just in UI to suggest user to pick more files.
  final bool multipleFilePickRequired;

  /// Set true if you want to include previous picking result in this pick.
  final bool continuePicking;

  /// Creates copy of FilePickModel object with the given
  /// values replaced with new values.
  FilePickModel copyWith({
    List<String>? allowedExtensions,
    List<String>? mimeTypesFilter,
    bool? localOnly,
    bool? getCachedFilePath,
    PickerType? pickerType,
    bool? enableMultipleSelection,
    bool? discardInvalidPdfFiles,
    bool? discardProtectedPdfFiles,
    bool? multipleFilePickRequired,
    bool? continuePicking,
  }) {
    return FilePickModel(
      allowedExtensions: allowedExtensions ?? this.allowedExtensions,
      mimeTypesFilter: mimeTypesFilter ?? this.mimeTypesFilter,
      localOnly: localOnly ?? this.localOnly,
      getCachedFilePath: getCachedFilePath ?? this.getCachedFilePath,
      pickerType: pickerType ?? this.pickerType,
      enableMultipleSelection:
          enableMultipleSelection ?? this.enableMultipleSelection,
      discardInvalidPdfFiles:
          discardInvalidPdfFiles ?? this.discardInvalidPdfFiles,
      discardProtectedPdfFiles:
          discardProtectedPdfFiles ?? this.discardProtectedPdfFiles,
      multipleFilePickRequired:
          multipleFilePickRequired ?? this.multipleFilePickRequired,
      continuePicking: continuePicking ?? this.continuePicking,
    );
  }

  /// Overriding FilePickModel equality operator.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilePickModel &&
          runtimeType == other.runtimeType &&
          allowedExtensions == other.allowedExtensions &&
          mimeTypesFilter == other.mimeTypesFilter &&
          localOnly == other.localOnly &&
          getCachedFilePath == other.getCachedFilePath &&
          pickerType == other.pickerType &&
          enableMultipleSelection == other.enableMultipleSelection &&
          discardInvalidPdfFiles == other.discardInvalidPdfFiles &&
          discardProtectedPdfFiles == other.discardProtectedPdfFiles &&
          multipleFilePickRequired == other.multipleFilePickRequired &&
          continuePicking == other.continuePicking;

  /// Overriding FilePickModel hashCode.
  @override
  int get hashCode =>
      allowedExtensions.hashCode ^
      mimeTypesFilter.hashCode ^
      localOnly.hashCode ^
      getCachedFilePath.hashCode ^
      pickerType.hashCode ^
      enableMultipleSelection.hashCode ^
      discardInvalidPdfFiles.hashCode ^
      discardProtectedPdfFiles.hashCode ^
      multipleFilePickRequired.hashCode ^
      continuePicking.hashCode;

  /// Overriding FilePickModel toString to make it easier to see information.
  /// when using the print statement.
  @override
  String toString() {
    return 'FilePickModel{'
        'allowedExtensions: $allowedExtensions, '
        'mimeTypesFilter: $mimeTypesFilter, '
        'localOnly: $localOnly, '
        'getCachedFilePath: $getCachedFilePath, '
        'pickerType: $pickerType, '
        'enableMultipleSelection: $enableMultipleSelection '
        'discardInvalidPdfFiles: $discardInvalidPdfFiles, '
        'discardProtectedPdfFiles: $discardProtectedPdfFiles'
        'multipleFilePickRequired: $multipleFilePickRequired'
        'continuePicking: $continuePicking'
        '}';
  }
}

/// Model class for defining file saving action through out the app.
///
/// It hold all the useful information about a saving action to use for
/// designing android saver experience and app UI.
class FileSaveModel {
  /// Defining FileSaveModel constructor.
  const FileSaveModel({
    required this.saveFiles,
    this.mimeTypesFilter,
    this.localOnly = false,
  });

  /// SaveFileInfo for files to save.
  final List<OutputFileModel> saveFiles;

  /// Filter MIME types.
  /// Location picker will be showing only provided MIME types.
  final List<String>? mimeTypesFilter;

  /// Show only device local files.
  final bool localOnly;

  /// Creates copy of FileSaveModel object with the given
  /// values replaced with new values.
  FileSaveModel copyWith({
    List<OutputFileModel>? saveFiles,
    List<String>? mimeTypesFilter,
    bool? localOnly,
  }) {
    return FileSaveModel(
      saveFiles: saveFiles ?? this.saveFiles,
      mimeTypesFilter: mimeTypesFilter ?? this.mimeTypesFilter,
      localOnly: localOnly ?? this.localOnly,
    );
  }

  /// Overriding FileSaveModel equality operator.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileSaveModel &&
          runtimeType == other.runtimeType &&
          saveFiles == other.saveFiles &&
          mimeTypesFilter == other.mimeTypesFilter &&
          localOnly == other.localOnly;

  /// Overriding FileSaveModel hashCode.
  @override
  int get hashCode =>
      saveFiles.hashCode ^ mimeTypesFilter.hashCode ^ localOnly.hashCode;

  /// Overriding FileSaveModel toString to make it easier to see information.
  /// when using the print statement.
  @override
  String toString() {
    return 'FileSaveModel{'
        'saveFiles: $saveFiles, '
        'mimeTypesFilter: $mimeTypesFilter, '
        'localOnly: $localOnly'
        '}';
  }
}
