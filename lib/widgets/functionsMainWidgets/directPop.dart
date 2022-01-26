import 'package:files_tools/basicFunctionalityFunctions/manageAppDirectoryAndCache.dart';
import 'package:flutter/cupertino.dart';

Future<bool> directPop() async {
  //deleteCacheDir();
  deleteAppDir();
  debugPrint('Direct Pop');
  return true;
}
