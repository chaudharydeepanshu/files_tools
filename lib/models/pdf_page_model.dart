import 'dart:typed_data';

/// Model class for an individual PDF page.
///
/// It holds all the information about an PDF page.
/// For example: If a PDF page fails to load in the app then we can update the
/// [pageErrorStatus] in model to use that updated status somewhere in the
/// app for further actions.
class PdfPageModel {
  /// Defining PdfPageModel constructor.
  PdfPageModel({
    required this.pageIndex,
    required this.pageBytes,
    required this.pageSelected,
    required this.pageRotationAngle,
    required this.pageHidden,
    required this.pageErrorStatus,
  });

  /// PDF page index.
  final int pageIndex;

  /// PDF page data.
  final Uint8List? pageBytes;

  /// PDF page selection status.
  final bool pageSelected;

  /// PDF page rotation angle.
  final int pageRotationAngle;

  /// PDF page hidden status.
  final bool pageHidden;

  /// PDF page error status.
  final bool pageErrorStatus;

  /// Creates copy of PdfPageModel object with the given
  /// values replaced with new values.
  PdfPageModel copyWith({
    int? pageIndex,
    Uint8List? pageBytes,
    bool? pageSelected,
    int? pageRotationAngle,
    bool? pageHidden,
    bool? pageErrorStatus,
  }) {
    return PdfPageModel(
      pageIndex: pageIndex ?? this.pageIndex,
      pageBytes: pageBytes ?? this.pageBytes,
      pageSelected: pageSelected ?? this.pageSelected,
      pageRotationAngle: pageRotationAngle ?? this.pageRotationAngle,
      pageHidden: pageHidden ?? this.pageHidden,
      pageErrorStatus: pageErrorStatus ?? this.pageErrorStatus,
    );
  }

  /// Overriding PdfPageModel equality operator.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfPageModel &&
          runtimeType == other.runtimeType &&
          pageIndex == other.pageIndex &&
          pageBytes == other.pageBytes &&
          pageHidden == other.pageHidden &&
          pageSelected == other.pageSelected &&
          pageRotationAngle == other.pageRotationAngle &&
          pageErrorStatus == other.pageErrorStatus;

  /// Overriding PdfPageModel hashCode.
  @override
  int get hashCode =>
      pageIndex.hashCode ^
      pageBytes.hashCode ^
      pageHidden.hashCode ^
      pageSelected.hashCode ^
      pageRotationAngle.hashCode ^
      pageErrorStatus.hashCode;

  /// Overriding PdfPageModel toString to make it easier to see information.
  /// when using the print statement.
  @override
  String toString() {
    return 'PdfPageModel{'
        'pageIndex: $pageIndex, '
        'pageBytes: $pageBytes, '
        'pageErrorStatus: $pageErrorStatus, '
        'pageSelected: $pageSelected, '
        'pageRotationAngle: $pageRotationAngle, '
        'pageHidden: $pageHidden'
        '}';
  }
}
