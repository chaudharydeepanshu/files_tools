// import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';
// import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'dart:io';
//
// Future<List<String>?> extractAllPDFPages(String pdfFilePath,
//     Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
//   late PdfDocument? document;
//   List<PdfDocument> listOfDocuments = [];
//   List<String>? rangesPdfsFilePaths = [];
//
//   // document = PdfDocument(inputBytes: File(pdfFilePath).readAsBytesSync());
//
//   bool isEncryptedDocument() {
//     bool isEncrypted = false;
//     try {
//       //Load the encrypted PDF document.
//       document = PdfDocument(inputBytes: File(pdfFilePath).readAsBytesSync());
//     } catch (exception) {
//       if (exception.toString().contains('Cannot open an encrypted document.')) {
//         isEncrypted = true;
//       }
//     }
//     return isEncrypted;
//   }
//
//   if (!isEncryptedDocument()) {
//     //Disable incremental update by set value as false. This helps decrease the size of pdf on page removal as it rewrites the whole document instead of updating the old one
//     //document!.fileStructure.incrementalUpdate = false;
//
//     // document.compressionLevel = PdfCompressionLevel.best;
//
//     //creating single page documents
//     for (var i = 0;
//         i < document!.pages.count && shouldDataBeProcessed == true;
//         i++) {
//       PdfDocument tempDocument =
//           PdfDocument(inputBytes: File(pdfFilePath).readAsBytesSync());
//       tempDocument.fileStructure.incrementalUpdate = false;
//       List<PdfPage> pagesToBeRemoved = [];
//       for (var x = 0; x < document!.pages.count; x++) {
//         if (x != i) {
//           PdfPage page = tempDocument.pages[x];
//           pagesToBeRemoved.add(page);
//           print('Page To Be Removed: $x');
//         }
//       }
//       for (var y = 0; y < pagesToBeRemoved.length; y++) {
//         tempDocument.pages.remove(pagesToBeRemoved[y]);
//       }
//       print("tempDocument.pages.count: ${tempDocument.pages.count}");
//       listOfDocuments.add(tempDocument);
//     }
//     print("listOfDocuments.length : ${listOfDocuments.length}");
//
//     // generating extensionOfFileName and fileNameWithoutExtension
//     String extensionOfFileName =
//         extensionOfString(fileName: pdfChangesDataMap['PDF File Name']);
//     String fileNameWithoutExtension = stringWithoutExtension(
//         fileName: pdfChangesDataMap['PDF File Name'],
//         extensionOfString: extensionOfFileName);
//
//     //saving ranges single document from list called finalListOfDocument
//     List<String> tempPdfFilePaths = [];
//     for (var i = 0;
//         i < listOfDocuments.length && shouldDataBeProcessed == true;
//         i++) {
//       String newFileName =
//           "${fileNameWithoutExtension + ' ' + i.toString() + extensionOfFileName}";
//       Map map = Map();
//       map['_pdfFileName'] = newFileName;
//       map['_extraBetweenNameAndExtension'] = '';
//       map['_document'] = listOfDocuments[i];
//       tempPdfFilePaths.add(await creatingAndSavingPDFFileTemporarily(map));
//     }
//     print("tempPdfFilePaths : $tempPdfFilePaths");
//
//     rangesPdfsFilePaths = List.from(tempPdfFilePaths);
//   } else {
//     rangesPdfsFilePaths = null;
//   }
//
//   //return Future.delayed(const Duration(milliseconds: 500), () {
//   return rangesPdfsFilePaths;
//   // });
// }

import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/basicFunctionalityFunctions/getExternalStorageFilePathFromFileName.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import 'package:flutter_pdf_split/flutter_pdf_split.dart';

Future<List<String>?> extractAllPDFPages(String pdfFilePath,
    Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
  //late PdfDocument? document;
  List<String>? rangesPdfsFilePaths = [];

  bool isEncryptedDocument() {
    bool isEncrypted = false;
    try {
      //Load the encrypted PDF document.
      //document = PdfDocument(inputBytes: File(pdfFilePath).readAsBytesSync());
      PdfDocument(inputBytes: File(pdfFilePath).readAsBytesSync());
    } catch (exception) {
      if (exception.toString().contains('Cannot open an encrypted document.')) {
        isEncrypted = true;
      }
    }
    return isEncrypted;
  }

  if (!isEncryptedDocument()) {
    // generating extensionOfFileName and fileNameWithoutExtension
    String extensionOfFileName =
        extensionOfString(fileName: pdfChangesDataMap['PDF File Name']);
    String fileNameWithoutExtension = stringWithoutExtension(
        fileName: pdfChangesDataMap['PDF File Name'],
        extensionOfString: extensionOfFileName);

    //creating and saving pdf as single page documents
    String? path = await getExternalStorageDirectoryPath();
    FlutterPdfSplitResult splitResult = await FlutterPdfSplit.split(
      FlutterPdfSplitArgs(pdfFilePath, path,
          outFilePrefix: "$fileNameWithoutExtension "),
    );

    rangesPdfsFilePaths = List.from(splitResult.pagePaths);
  } else {
    rangesPdfsFilePaths = null;
  }

  //return Future.delayed(const Duration(milliseconds: 500), () {
  return rangesPdfsFilePaths;
  // });
}
