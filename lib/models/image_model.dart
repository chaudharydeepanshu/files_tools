import 'dart:typed_data';

/// Model class for an image.
///
/// It holds all the information about an image.
/// For example: If a image fails to load in the app then we can update the
/// [imageErrorStatus] in model to use that updated status somewhere in the
/// app for further actions.
class ImageModel {
  /// Defining ImageModel constructor.
  ImageModel({
    required this.imageName,
    required this.imageBytes,
    required this.imageErrorStatus,
    required this.imageErrorMessage,
    required this.imageErrorStackTrace,
  });

  /// Image name.
  final String imageName;

  /// Image data.
  final Uint8List? imageBytes;

  /// Image error status.
  final bool imageErrorStatus;

  /// Image error message.
  final String imageErrorMessage;

  /// Image error StackTrace.
  final StackTrace imageErrorStackTrace;

  /// Creates copy of ImageModel object with the given
  /// values replaced with new values.
  ImageModel copyWith({
    String? imageName,
    Uint8List? imageBytes,
    bool? imageErrorStatus,
    String? imageErrorMessage,
    StackTrace? imageErrorStackTrace,
  }) {
    return ImageModel(
      imageName: imageName ?? this.imageName,
      imageBytes: imageBytes ?? this.imageBytes,
      imageErrorStatus: imageErrorStatus ?? this.imageErrorStatus,
      imageErrorMessage: imageErrorMessage ?? this.imageErrorMessage,
      imageErrorStackTrace: imageErrorStackTrace ?? this.imageErrorStackTrace,
    );
  }

  /// Overriding ImageModel equality operator.
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

  /// Overriding ImageModel hashCode.
  @override
  int get hashCode =>
      imageName.hashCode ^
      imageBytes.hashCode ^
      imageErrorStatus.hashCode ^
      imageErrorMessage.hashCode ^
      imageErrorStackTrace.hashCode;

  /// Overriding ImageModel toString to make it easier to see information.
  /// when using the print statement.
  @override
  String toString() {
    return 'ImageModel{'
        'imageName: $imageName, '
        'imageBytes: $imageBytes, '
        'imageErrorStatus: $imageErrorStatus, '
        'imageErrorMessage: $imageErrorMessage, '
        'imageErrorStackTrace: $imageErrorStackTrace'
        '}';
  }
}
