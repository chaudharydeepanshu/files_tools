import 'package:path_provider/path_provider.dart';

Future<void> deleteCacheDir() async {
  final cacheDir = await getTemporaryDirectory();

  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
}

Future<void> deleteAppDir() async {
  final appSupportDir = await getApplicationSupportDirectory();

  if (appSupportDir.existsSync()) {
    appSupportDir.deleteSync(recursive: true);
  }

  final appExternalStorageDir = await getExternalStorageDirectory();

  if (appExternalStorageDir!.existsSync()) {
    appExternalStorageDir.deleteSync(recursive: true);
  }
}
