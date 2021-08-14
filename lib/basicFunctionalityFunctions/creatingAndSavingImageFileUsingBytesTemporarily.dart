import 'dart:io';
import 'getExternalStorageFilePathFromFileName.dart';

Future<String> creatingAndSavingImageFileUsingBytesTemporarily(map) async {
  String _imageName = map['_imageName'];
  var _imageBytes = map['_imageBytes'];
  String filePathFromFileName =
      await getExternalStorageFilePathFromFileName(_imageName);

  Future<List<int>> creatingImageFile() async {
    List<int> bytes = _imageBytes;
    return bytes;
  }

  Future<void> savingImageFile() async {
    File? imageFile = File(filePathFromFileName);
    List<int> bytes = await creatingImageFile();
    await imageFile.writeAsBytes(bytes, flush: true);
  }

  await savingImageFile();

  print(filePathFromFileName);
  return filePathFromFileName;
}
