import 'package:files_tools/basicFunctionalityFunctions/manage_app_directory_and_cache.dart';
import 'package:flutter/cupertino.dart';

Future<bool> directPop() async {
  //deleteCacheDir();
  deleteAppDir();
  debugPrint('Direct Pop');
  return true;
}
