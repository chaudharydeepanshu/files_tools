import 'dart:typed_data';

class PdfPageModel {
  final int pageIndex;
  final Uint8List? pageBytes;
  final bool pageErrorStatus;

  PdfPageModel({
    required this.pageIndex,
    required this.pageBytes,
    required this.pageErrorStatus,
  });

  // Implement toString to make it easier to see information
  // when using the print statement.
  @override
  String toString() {
    return 'PdfPageModel{pageIndex: $pageIndex, pageBytes: $pageBytes, pageErrorStatus: $pageErrorStatus}';
  }
}
