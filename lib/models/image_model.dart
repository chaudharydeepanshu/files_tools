import 'dart:typed_data';

class ImageModel {
  final String imageName;
  final Uint8List? imageBytes;
  final bool imageErrorStatus;
  final String imageErrorMessage;
  final StackTrace imageErrorStackTrace;

  ImageModel({
    required this.imageName,
    required this.imageBytes,
    required this.imageErrorStatus,
    required this.imageErrorMessage,
    required this.imageErrorStackTrace,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageModel &&
          runtimeType == other.runtimeType &&
          imageName == other.imageName &&
          imageBytes == other.imageBytes &&
          imageErrorStatus == other.imageErrorStatus &&
          imageErrorMessage == other.imageErrorMessage &&
          imageErrorStackTrace == other.imageErrorStackTrace;

  @override
  int get hashCode =>
      imageName.hashCode ^
      imageBytes.hashCode ^
      imageErrorStatus.hashCode ^
      imageErrorMessage.hashCode ^
      imageErrorStackTrace.hashCode;

  // Implement toString to make it easier to see information
  // when using the print statement.
  @override
  String toString() {
    return 'ImageModel{imageName: $imageName, imageBytes: $imageBytes, imageErrorStatus: $imageErrorStatus, imageErrorMessage: $imageErrorMessage, imageErrorStackTrace: $imageErrorStackTrace}';
  }
}
