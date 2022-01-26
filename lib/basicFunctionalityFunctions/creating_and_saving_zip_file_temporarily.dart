import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'file_name_manager.dart';

Future<String?> creatingAndSavingZipFileTemporarily(map) async {
  var _pdfFileName = map['_pdfFileName'];
  var _rangesPdfsFilePaths = map['_rangesPdfsFilePaths'];

  String extensionOfFileName = extensionOfString(fileName: _pdfFileName);
  String fileNameWithoutExtension = stringWithoutExtension(
      fileName: _pdfFileName, extensionOfString: extensionOfFileName);

  //removing unnecessary documents from getExternalStorageDirectory
  // void removingTempPDFFiles() {
  //   for (int i = 0; i < _rangesPdfsFilePaths.length; i++) {
  //     deletingTempPDFFiles(
  //         "${getFileNameFromFilePath(_rangesPdfsFilePaths[i])}");
  //   }
  // }

  //creating a zip archive of the pdf documents and saving temporarily
  Future<String?> saveFileTemporarily(String fileName) async {
    final sourceDirectory = await getExternalStorageDirectory();
    String? sourceDirectoryPath = sourceDirectory!.path;
    List<File> filesList =
        List<File>.generate(_rangesPdfsFilePaths.length, (i) {
      return File(_rangesPdfsFilePaths[i]);
    });
    final zipFile = File(sourceDirectoryPath +
        "/" +
        fileNameWithoutExtension +
        ' ' +
        'Zip' +
        ' ' +
        'file' +
        ".zip");

    await ZipFile.createFromFiles(
            sourceDir: sourceDirectory, files: filesList, zipFile: zipFile)
        .whenComplete(() {
      //removingTempPDFFiles();//disables as these individual file paths are required for saving files individually in gallery and downloads instead of regenerating from zip
      //also it is not required as the automatically get removed
    });
    return sourceDirectoryPath +
        "/" +
        fileNameWithoutExtension +
        ' ' +
        'Zip' +
        ' ' +
        'file' +
        ".zip";
  }

  return await saveFileTemporarily(_pdfFileName);
}
