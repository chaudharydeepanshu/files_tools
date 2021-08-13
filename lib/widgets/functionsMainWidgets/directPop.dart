import 'package:files_tools/basicFunctionalityFunctions/manageAppDirectoryAndCache.dart';

Future<bool> directPop() async {
  //deleteCacheDir();
  deleteAppDir();
  print('Direct Pop');
  return true;
}
