import 'dart:typed_data';

class ImageModel {
  final String imageName;
  final Uint8List? imageBytes;
  final bool imageErrorStatus;
  final String imageError;

  ImageModel({
    required this.imageName,
    required this.imageBytes,
    required this.imageErrorStatus,
    required this.imageError,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageModel &&
          runtimeType == other.runtimeType &&
          imageName == other.imageName &&
          imageBytes == other.imageBytes &&
          imageErrorStatus == other.imageErrorStatus &&
          imageError == other.imageError;

  @override
  int get hashCode =>
      imageName.hashCode ^
      imageBytes.hashCode ^
      imageErrorStatus.hashCode ^
      imageError.hashCode;

  // Implement toString to make it easier to see information
  // when using the print statement.
  @override
  String toString() {
    return 'ImageModel{imageName: $imageName, imageBytes: $imageBytes, imageErrorStatus: $imageErrorStatus, imageError: $imageError}';
  }
}
