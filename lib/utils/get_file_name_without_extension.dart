import 'package:files_tools/utils/get_file_name_extension.dart';

String getFileNameWithoutExtension({required String fileName}) {
  String fileExt = getFileNameExtension(fileName: fileName);
  String fileNameWithoutExtension =
      fileName.substring(0, fileName.length - fileExt.length);
  return fileNameWithoutExtension;
}
