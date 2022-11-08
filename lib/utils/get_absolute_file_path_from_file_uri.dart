import 'package:pick_or_save/pick_or_save.dart';

Future<String> getAbsoluteFilePathFromFileUri({required String fileUri}) async {
  String? absoluteFilePath;

  absoluteFilePath = await PickOrSave().cacheFilePathFromUri(
      params: CacheFilePathFromUriParams(fileUri: fileUri));
  if (absoluteFilePath == null) {
    throw Exception('File cached file path from Uri was null.');
  }

  return absoluteFilePath;
}
