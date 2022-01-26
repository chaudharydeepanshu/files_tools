// // import 'package:syncfusion_flutter_pdf/pdf.dart';
// // import 'dart:io';
// //
// // Future<PdfDocument?> extractSelectedPages(String pdfFilePath,
// //     List pdfPagesSelectedImages, bool shouldDataBeProcessed) async {
// //   late PdfDocument? document;
// //   List<PdfPage> selectedPages = [];
// //
// //   // document = PdfDocument(inputBytes: File(pdfFilePath).readAsBytesSync());
// //
// //   bool isEncryptedDocument() {
// //     bool isEncrypted = false;
// //     try {
// //       //Load the encrypted PDF document.
// //       document = PdfDocument(inputBytes: File(pdfFilePath).readAsBytesSync());
// //     } catch (exception) {
// //       if (exception.toString().contains('Cannot open an encrypted document.')) {
// //         isEncrypted = true;
// //       }
// //     }
// //     return isEncrypted;
// //   }
// //
// //   //isEncryptedDocument();
// //   if (!isEncryptedDocument()) {
// //     //Disable incremental update by set value as false. This helps decrease the size of pdf on page removal as it rewrites the whole document instead of updating the old one
// //     document!.fileStructure.incrementalUpdate = false;
// //
// //     // document.compressionLevel = PdfCompressionLevel.best;
// //
// //     for (var i = 0;
// //         i < pdfPagesSelectedImages.length && shouldDataBeProcessed == true;
// //         i++) {
// //       if (pdfPagesSelectedImages[i] == false) {
// //         PdfPage page = document!.pages[i];
// //         selectedPages.add(page);
// //       }
// //     }
// //
// //     for (var i = 0;
// //         i < selectedPages.length && shouldDataBeProcessed == true;
// //         i++) {
// //       document!.pages.remove(selectedPages[i]);
// //     }
// //
// //     // PdfDocument newDocument = PdfDocument();
// //     // Future<PdfDocument> creatingNewPdfDocumentFromOld() async {
// //     //   List<PdfPage> pageList = [];
// //     //   List<PdfTemplate> pageTemplateList = [];
// //     //   //Get pages from existing document.
// //     //   for (var i = 0;
// //     //       i < document!.pages.count && shouldDataBeProcessed == true;
// //     //       i++) {
// //     //     pageList.add(document!.pages[i]);
// //     //
// //     //     //Create the page as template and then add it to template list
// //     //     pageTemplateList.add(document!.pages[i].createTemplate());
// //     //   }
// //     //
// //     //   //Set page size and add page.
// //     //
// //     //   for (var i = 0;
// //     //       i < document!.pages.count && shouldDataBeProcessed == true;
// //     //       i++) {
// //     //     // pages of different size
// //     //     PdfSection section1 = newDocument.sections!.add();
// //     //
// //     //     //changing section orientation if page height is less than width
// //     //     if (pageList[i].size.height < pageList[i].size.width) {
// //     //       section1.pageSettings.orientation = PdfPageOrientation.landscape;
// //     //     } else {
// //     //       section1.pageSettings.orientation = PdfPageOrientation.portrait;
// //     //     }
// //     //
// //     //     section1.pageSettings.size = pageList[i].size;
// //     //
// //     //     section1.pageSettings.margins.all = 0;
// //     //     PdfPage newPage = section1.pages.add();
// //     //
// //     //     // newDocument.pageSettings.size = pageList[i].size;
// //     //     // newDocument.pageSettings.margins.all = 0;
// //     //     // PdfPage newPage = newDocument.pages.add();
// //     //
// //     //     //Draw the template to the new document page.
// //     //     newPage.graphics.drawPdfTemplate(pageTemplateList[i], Offset(0, 0));
// //     //   }
// //     //
// //     //   return newDocument;
// //     // }
// //     //
// //     // document = await creatingNewPdfDocumentFromOld();
// //     //
// //     // //Dispose documents.
// //     // //newDocument.dispose(); // calling it disables document view and save maybe it is also disposing or somehow connected with document
// //
// //   } else {
// //     document = null;
// //   }
// //
// //   //return Future.delayed(const Duration(milliseconds: 500), () {
// //   return document;
// //   // });
// // }
//
// import 'package:flutter_pdf_split/flutter_pdf_split.dart';
// import 'package:pdf_merger/pdf_merger.dart';
// import 'package:pdf_merger/pdf_merger_response.dart';
// import 'package:files_tools/basicFunctionalityFunctions/creating_and_saving_pdf_file_temporarily.dart';
// import 'package:files_tools/basicFunctionalityFunctions/deleting_temp_pdf_files.dart';
// import 'package:files_tools/basicFunctionalityFunctions/file_name_manager.dart';
// import 'package:files_tools/basicFunctionalityFunctions/get_file_name_from_file_path.dart';
// import 'package:files_tools/basicFunctionalityFunctions/get_external_storage_file_path_from_file_name.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'dart:io';
//
// Future<PdfDocument?> extractSelectedPages(
//     String pdfFilePath,
//     List pdfPagesSelectedImages,
//     Map<String, dynamic> pdfChangesDataMap,
//     bool shouldDataBeProcessed) async {
//   late PdfDocument? document;
//   List<PdfDocument> listOfDocuments = [];
//   List<PdfDocument> selectedDocuments = [];
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
//   //isEncryptedDocument();
//   if (!isEncryptedDocument()) {
//     //Disable incremental update by set value as false. This helps decrease the size of pdf on page removal as it rewrites the whole document instead of updating the old one
//     //document!.fileStructure.incrementalUpdate = false;
//
//     // document.compressionLevel = PdfCompressionLevel.best;
//
//     // generating extensionOfFileName and fileNameWithoutExtension
//     String extensionOfFileName =
//     extensionOfString(fileName: pdfChangesDataMap['PDF File Name']);
//     String fileNameWithoutExtension = stringWithoutExtension(
//         fileName: pdfChangesDataMap['PDF File Name'],
//         extensionOfString: extensionOfFileName);
//
//     //creating and saving pdf as single page documents
//     String? path = await getExternalStorageDirectoryPath();
//     FlutterPdfSplitResult splitResult = await FlutterPdfSplit.split(
//       FlutterPdfSplitArgs(pdfFilePath, path,
//           outFilePrefix: "$fileNameWithoutExtension "),
//     );
//     //creating single page documents list from single saved documents
//     for (var i = 0;
//     i < document!.pages.count && shouldDataBeProcessed == true;
//     i++) {
//       PdfDocument tempDocument = PdfDocument(
//           inputBytes: File(splitResult.pagePaths[i]).readAsBytesSync());
//       print("tempDocument.pages.count: ${tempDocument.pages.count}");
//       listOfDocuments.add(tempDocument);
//     }
//     print("listOfDocuments.length : ${listOfDocuments.length}");
//
//     //removing saved single page documents as they are loaded in a list already
//     for (int i = 0; i < splitResult.pagePaths.length; i++) {
//       deletingTempPDFFiles(
//           "${getFileNameFromFilePath(splitResult.pagePaths[i])}");
//     }
//
//     //adding selected documents to selectedDocuments list
//     for (var i = 0;
//     i < pdfPagesSelectedImages.length && shouldDataBeProcessed == true;
//     i++) {
//       if (pdfPagesSelectedImages[i] == true) {
//         PdfDocument pdfDocument = listOfDocuments[i];
//         selectedDocuments.add(pdfDocument);
//       }
//     }
//
//     //saving selected documents temporarily
//     List<String> tempPdfFilePaths = [];
//     for (var i = 0;
//     i < selectedDocuments.length && shouldDataBeProcessed == true;
//     i++) {
//       String newFileName =
//           "${fileNameWithoutExtension + ' ' + 'selected' + ' ' + i.toString() + extensionOfFileName}";
//       Map map = Map();
//       map['_pdfFileName'] = newFileName;
//       map['_extraBetweenNameAndExtension'] = '';
//       map['_document'] = selectedDocuments[i];
//       tempPdfFilePaths.add(await creatingAndSavingPDFFileTemporarily(map));
//     }
//     print("tempPdfFilePaths : $tempPdfFilePaths");
//
//     //merge the temporarily saved documents
//     MergeMultiplePDFResponse response = await PdfMerger.mergeMultiplePDF(
//         paths: tempPdfFilePaths,
//         outputDirPath: await getPDFFilePathFromFileName(
//             "${fileNameWithoutExtension + ' ' + 'extracted' + extensionOfFileName}"));
//
//     if (response.status == "success") {
//       print(response.response); //for output path  in String
//       print(response.message); // for success message  in String
//     }
//
//     //passing final document to document variable
//     document = PdfDocument(
//         inputBytes: File(await getPDFFilePathFromFileName(
//             "${fileNameWithoutExtension + ' ' + 'extracted' + extensionOfFileName}"))
//             .readAsBytesSync());
//
//     //removing unnecessary documents from getExternalStorageDirectory
//     for (int i = 0; i < tempPdfFilePaths.length; i++) {
//       deletingTempPDFFiles("${getFileNameFromFilePath(tempPdfFilePaths[i])}");
//     }
//     deletingTempPDFFiles(
//         "${fileNameWithoutExtension + ' ' + 'extracted' + extensionOfFileName}");
//   } else {
//     document = null;
//   }
//
//   //return Future.delayed(const Duration(milliseconds: 500), () {
//   return document;
//   // });
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter_pdf_split/flutter_pdf_split.dart';
import 'package:pdf_merger/pdf_merger.dart';
// import 'package:pdf_merger/pdf_merger_response.dart';
import 'package:files_tools/basicFunctionalityFunctions/deleting_temp_pdf_files.dart';
import 'package:files_tools/basicFunctionalityFunctions/file_name_manager.dart';
import 'package:files_tools/basicFunctionalityFunctions/get_file_name_from_file_path.dart';
import 'package:files_tools/basicFunctionalityFunctions/get_external_storage_file_path_from_file_name.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

Future<PdfDocument?> extractSelectedPages(
    String pdfFilePath,
    List pdfPagesSelectedImages,
    Map<String, dynamic> pdfChangesDataMap,
    bool shouldDataBeProcessed) async {
  late PdfDocument? document;
  List<String> selectedDocumentsPath = [];

  // document = PdfDocument(inputBytes: File(pdfFilePath).readAsBytesSync());

  bool isEncryptedDocument() {
    bool isEncrypted = false;
    try {
      //Load the encrypted PDF document.
      document = PdfDocument(inputBytes: File(pdfFilePath).readAsBytesSync());
    } catch (exception) {
      if (exception.toString().contains('Cannot open an encrypted document.')) {
        isEncrypted = true;
      }
    }
    return isEncrypted;
  }

  //isEncryptedDocument();
  if (!isEncryptedDocument()) {
    //Disable incremental update by set value as false. This helps decrease the size of pdf on page removal as it rewrites the whole document instead of updating the old one
    //document!.fileStructure.incrementalUpdate = false;

    // document.compressionLevel = PdfCompressionLevel.best;

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

    //adding selected documents to selectedDocuments list
    for (var i = 0;
        i < pdfPagesSelectedImages.length && shouldDataBeProcessed == true;
        i++) {
      if (pdfPagesSelectedImages[i] == true) {
        selectedDocumentsPath.add(splitResult.pagePaths[i]);
      }
    }

    MergeMultiplePDFResponse response = await PdfMerger.mergeMultiplePDF(
        paths: selectedDocumentsPath,
        outputDirPath: await getExternalStorageFilePathFromFileName(
            fileNameWithoutExtension + ' ' + 'merged' + extensionOfFileName));

    if (response.status == "success") {
      debugPrint(response.response); //for output path  in String
      debugPrint(response.message); // for success message  in String
    }

    //removing saved single page documents as they are loaded in a list already
    for (int i = 0; i < splitResult.pagePaths.length; i++) {
      deletingTempPDFFiles(getFileNameFromFilePath(splitResult.pagePaths[i]));
    }

    //passing final document to document variable
    document = PdfDocument(
        inputBytes: File(await getExternalStorageFilePathFromFileName(
                fileNameWithoutExtension +
                    ' ' +
                    'merged' +
                    extensionOfFileName))
            .readAsBytesSync());

    deletingTempPDFFiles(
        fileNameWithoutExtension + ' ' + 'merged' + extensionOfFileName);
  } else {
    document = null;
  }

  //return Future.delayed(const Duration(milliseconds: 500), () {
  return document;
  // });
}
