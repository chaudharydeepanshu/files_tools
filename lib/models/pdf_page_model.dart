import 'dart:typed_data';

class PdfPageModel {
  final int pageIndex;
  final Uint8List? pageBytes;
  final bool pageErrorStatus;
  final bool pageSelected;
  final int pageRotationAngle;
  final bool pageHidden;

  PdfPageModel({
    required this.pageIndex,
    required this.pageBytes,
    required this.pageErrorStatus,
    required this.pageSelected,
    required this.pageRotationAngle,
    required this.pageHidden,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfPageModel &&
          runtimeType == other.runtimeType &&
          pageIndex == other.pageIndex &&
          pageBytes == other.pageBytes &&
          pageErrorStatus == other.pageErrorStatus &&
          pageSelected == other.pageSelected &&
          pageRotationAngle == other.pageRotationAngle &&
          pageHidden == other.pageHidden;

  @override
  int get hashCode =>
      pageIndex.hashCode ^
      pageBytes.hashCode ^
      pageErrorStatus.hashCode ^
      pageSelected.hashCode ^
      pageRotationAngle.hashCode ^
      pageHidden.hashCode;

  // Implement toString to make it easier to see information
  // when using the print statement.
  @override
  String toString() {
    return 'PdfPageModel{pageIndex: $pageIndex, pageBytes: $pageBytes, pageErrorStatus: $pageErrorStatus, pageSelected: $pageSelected, pageRotationAngle: $pageRotationAngle, pageHidden: $pageHidden}';
  }
}
