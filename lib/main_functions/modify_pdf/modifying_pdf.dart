// // import 'dart:ui';
// // import 'package:syncfusion_flutter_pdf/pdf.dart';
// // import 'dart:io';
// //
// // Future<PdfDocument?> modifyingPDFPagesUsingModifiedPDFDataMap(
// //     String pdfFilePath,
// //     Map<String, dynamic> modifiedPDFDataMap,
// //     bool shouldDataBeProcessed) async {
// //   late PdfDocument? document;
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
// //   if (!isEncryptedDocument()) {
// //     //Disable incremental update by set value as false. This helps decrease the size of pdf on page removal as it rewrites the whole document instead of updating the old one
// //     document!.fileStructure.incrementalUpdate = false;
// //
// //     PdfDocument newDocument = PdfDocument();
// //     Future<PdfDocument> creatingNewPdfDocumentFromOld() async {
// //       List<PdfPage> pageList = [];
// //       List<PdfTemplate> pageTemplateList = [];
// //       //Get pages from existing document.
// //       for (var i = 0;
// //           i < document!.pages.count && shouldDataBeProcessed == true;
// //           i++) {
// //         pageList.add(document!.pages[i]);
// //
// //         //Create the page as template and then add it to template list
// //         pageTemplateList.add(document!.pages[i].createTemplate());
// //       }
// //
// //       //for reorder
// //       List<PdfTemplate> reorderedPageTemplateList = [];
// //       List<PdfPage> reorderedPageList = [];
// //       for (int i = 0;
// //           i < modifiedPDFDataMap['Reordered Page List'].length &&
// //               shouldDataBeProcessed == true;
// //           i++) {
// //         int tmp = modifiedPDFDataMap['Reordered Page List'][i] - 1;
// //         PdfTemplate pdfTemplate = pageTemplateList[tmp];
// //         reorderedPageTemplateList.insert(i, pdfTemplate);
// //
// //         int tmp2 = modifiedPDFDataMap['Reordered Page List'][i] - 1;
// //         PdfPage pdfPage = pageList[tmp2];
// //         reorderedPageList.insert(i, pdfPage);
// //       }
// //
// //       //for deletion
// //       List<PdfTemplate> deletedPageTemplate = [];
// //       List<PdfPage> deletedPdfPage = [];
// //       List<int> modifiedPageRotationList =
// //           List.from(modifiedPDFDataMap['Page Rotations List']);
// //       List<int> deletedPageRotations = [];
// //       for (var i = 0;
// //           i < document!.pages.count && shouldDataBeProcessed == true;
// //           i++) {
// //         if (modifiedPDFDataMap['Deleted Page List'][i] == false) {
// //           PdfTemplate pdfTemplate = reorderedPageTemplateList[i];
// //           deletedPageTemplate.add(pdfTemplate);
// //           PdfPage pdfPage = reorderedPageList[i];
// //           deletedPdfPage.add(pdfPage);
// //           int pageRotation = modifiedPageRotationList[i];
// //           deletedPageRotations.add(pageRotation);
// //         }
// //       }
// //       for (var i = 0;
// //           i < deletedPageTemplate.length && shouldDataBeProcessed == true;
// //           i++) {
// //         reorderedPageTemplateList.remove(deletedPageTemplate[i]);
// //         reorderedPageList.remove(deletedPdfPage[i]);
// //         modifiedPageRotationList.remove(deletedPageRotations[i]);
// //       }
// //
// //       //Set page size and add page.
// //       for (var i = 0;
// //           i < reorderedPageTemplateList.length && shouldDataBeProcessed == true;
// //           i++) {
// //         // pages of different size
// //         PdfSection section1 = newDocument.sections!.add();
// //
// //         //changing section orientation if page height is less than width
// //         if (reorderedPageList[i].size.height <
// //             reorderedPageList[i].size.width) {
// //           section1.pageSettings.orientation = PdfPageOrientation.landscape;
// //         } else {
// //           section1.pageSettings.orientation = PdfPageOrientation.portrait;
// //         }
// //
// //         section1.pageSettings.size = reorderedPageList[i].size;
// //         print('section1.pageSettings.size : ${reorderedPageList[i].size}');
// //         section1.pageSettings.margins.all = 0;
// //
// //         //for rotation
// //         if (modifiedPageRotationList[i] == 1) {
// //           section1.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
// //         } else if (modifiedPageRotationList[i] == 2) {
// //           section1.pageSettings.rotate = PdfPageRotateAngle.rotateAngle180;
// //         } else if (modifiedPageRotationList[i] == 3) {
// //           section1.pageSettings.rotate = PdfPageRotateAngle.rotateAngle270;
// //         }
// //
// //         PdfPage newPage = section1.pages.add();
// //
// //         // newDocument.pageSettings.size = pageList[i].size;
// //         // newDocument.pageSettings.margins.all = 0;
// //         // PdfPage newPage = newDocument.pages.add();
// //
// //         //Draw the template to the new document page.
// //         newPage.graphics
// //             .drawPdfTemplate(reorderedPageTemplateList[i], Offset(0, 0));
// //       }
// //
// //       return newDocument;
// //     }
// //
// //     document = await creatingNewPdfDocumentFromOld();
// //   } else {
// //     document = null;
// //   }
// //   // return Future.delayed(const Duration(milliseconds: 500), () {
// //   return document;
// //   //});
// // }
//
// import 'dart:ui';
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'dart:io';
// import '../../basicFunctionalityFunctions/creating_and_saving_pdf_file_temporarily.dart';
// import 'package:pdf_merger/pdf_merger.dart';
//
// Future<PdfDocument?> modifyingPDFPagesUsingModifiedPDFDataMap(
//     String pdfFilePath,
//     Map<String, dynamic> pdfChangesDataMap,
//     bool shouldDataBeProcessed) async {
//   late PdfDocument? document;
//   late PdfDocument? tempDocument;
//   List<PdfDocument> listOfDocuments = [];
//   List<String> tempPdfFilePaths = [];
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
//     //creating single page documents
//     for (var i = 0;
//         i < document!.pages.count && shouldDataBeProcessed == true;
//         i++) {
//       tempDocument =
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
//     //for reorder
//     List<PdfDocument> reorderedListOfDocuments = [];
//     for (int i = 0;
//         i < pdfChangesDataMap['Reordered Page List'].length &&
//             shouldDataBeProcessed == true;
//         i++) {
//       int tmp = pdfChangesDataMap['Reordered Page List'][i] - 1;
//       PdfDocument pdfDocument = listOfDocuments[tmp];
//       //pdfDocument.pageSettings.rotate = PdfPageRotateAngle.rotateAngle180;
//       reorderedListOfDocuments.insert(i, pdfDocument);
//     }
//
//     //for rotation
//     for (int i = 0;
//         i < pdfChangesDataMap['Page Rotations List'].length &&
//             shouldDataBeProcessed == true;
//         i++) {
//       void newAngleDocumentCreator(int angle) {
//         //Create new second document.
//         PdfDocument newDocument = PdfDocument();
//         PdfPage page = reorderedListOfDocuments[i].pages[0];
//         //Create the page as template.
//         PdfTemplate template = page.createTemplate();
//         print(
//             "page.size.height: ${page.size.height}, page.size.width: ${page.size.width}");
//         //Changing section orientation according to page height & width
//         if (page.size.height < page.size.width) {
//           newDocument.pageSettings.orientation = PdfPageOrientation.landscape;
//           print('Page is landscape');
//         } else {
//           newDocument.pageSettings.orientation = PdfPageOrientation.portrait;
//           print('Page is portrait');
//         }
//         //Set page size and add page.
//         newDocument.pageSettings.size = page.size;
//         if (angle == 0) {
//           newDocument.pageSettings.rotate = PdfPageRotateAngle.rotateAngle0;
//         } else if (angle == 90) {
//           newDocument.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
//         } else if (angle == 180) {
//           newDocument.pageSettings.rotate = PdfPageRotateAngle.rotateAngle180;
//         } else if (angle == 270) {
//           newDocument.pageSettings.rotate = PdfPageRotateAngle.rotateAngle270;
//         }
//         newDocument.pageSettings.margins.all = 0;
//         PdfPage newPage = newDocument.pages.add();
//         //Draw the template to the new document page.
//         newPage.graphics.drawPdfTemplate(template, Offset(0, 0));
//         reorderedListOfDocuments[i].pageSettings.rotate =
//             PdfPageRotateAngle.rotateAngle0;
//         reorderedListOfDocuments[i] = newDocument;
//       }
//
//       if (pdfChangesDataMap['Page Rotations List'][i] == 0) {
//         newAngleDocumentCreator(0);
//       } else if (pdfChangesDataMap['Page Rotations List'][i] == 1) {
//         newAngleDocumentCreator(90);
//       } else if (pdfChangesDataMap['Page Rotations List'][i] == 2) {
//         newAngleDocumentCreator(180);
//       } else if (pdfChangesDataMap['Page Rotations List'][i] == 3) {
//         newAngleDocumentCreator(270);
//       }
//     }
//
//     //for deletion
//     List<PdfDocument> listOfDocumentsToDelete = [];
//     for (var i = 0;
//         i < pdfChangesDataMap['Deleted Page List'].length &&
//             shouldDataBeProcessed == true;
//         i++) {
//       if (pdfChangesDataMap['Deleted Page List'][i] == false) {
//         PdfDocument documentToDelete = reorderedListOfDocuments[i];
//         listOfDocumentsToDelete.add(documentToDelete);
//       }
//     }
//
//     for (var i = 0;
//         i < listOfDocumentsToDelete.length && shouldDataBeProcessed == true;
//         i++) {
//       reorderedListOfDocuments.remove(listOfDocumentsToDelete[i]);
//     }
//
//     //save the documents
//     String fileNameExtension = pdfChangesDataMap['PDF File Name']
//         .substring(pdfChangesDataMap['PDF File Name'].lastIndexOf('.'))
//         .substring(0);
//     String replaceLast(String string, String substring, String replacement) {
//       int index = string.lastIndexOf(substring);
//       if (index == -1) return string;
//       return string.substring(0, index) +
//           replacement +
//           string.substring(index + substring.length);
//     }
//
//     String fileNameWithoutExtension =
//         replaceLast(pdfChangesDataMap['PDF File Name'], fileNameExtension, "");
//     for (var i = 0;
//         i < reorderedListOfDocuments.length && shouldDataBeProcessed == true;
//         i++) {
//       String newFileName =
//           "${fileNameWithoutExtension + ' ' + i.toString() + fileNameExtension}";
//       Map map = Map();
//       map['_pdfFileName'] = newFileName;
//       map['_extraBetweenNameAndExtension'] = '';
//       map['_document'] = reorderedListOfDocuments[i];
//       tempPdfFilePaths.add(await creatingAndSavingPDFFileTemporarily(map));
//     }
//     print("tempPdfFilePaths : $tempPdfFilePaths");
//
//     //merge the documents
//     Future<String> saveFileTemporarily(String fileName) async {
//       final directory = await getExternalStorageDirectory();
//       String? path;
//       path = directory!.path;
//       String filePath = '$path/$fileName';
//       return filePath;
//     }
//
//     MergeMultiplePDFResponse response = await PdfMerger.mergeMultiplePDF(
//         paths: tempPdfFilePaths,
//         outputDirPath: await saveFileTemporarily(
//             "${fileNameWithoutExtension + ' ' + 'merged' + fileNameExtension}"));
//
//     if (response.status == "success") {
//       print(response.response); //for output path  in String
//       print(response.message); // for success message  in String
//     }
//
//     //passing final document to document variable
//     document = PdfDocument(
//         inputBytes: File(await saveFileTemporarily(
//                 "${fileNameWithoutExtension + ' ' + 'merged' + fileNameExtension}"))
//             .readAsBytesSync());
//
//     //removing unnecessary documents from getExternalStorageDirectory
//     Future<void> deletingTempFiles(String fileName) async {
//       try {
//         final file = File(await saveFileTemporarily(fileName));
//         await file.delete();
//       } catch (e) {
//         print(e);
//       }
//     }
//
//     for (int i = 0; i < tempPdfFilePaths.length; i++) {
//       deletingTempFiles(
//           "${fileNameWithoutExtension + ' ' + i.toString() + fileNameExtension}");
//     }
//     deletingTempFiles(
//         "${fileNameWithoutExtension + ' ' + 'merged' + fileNameExtension}");
//   } else {
//     document = null;
//   }
//   // return Future.delayed(const Duration(milliseconds: 500), () {
//   return document;
//   //});
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter_pdf_split/flutter_pdf_split.dart';
import 'package:files_tools/basicFunctionalityFunctions/deleting_temp_pdf_files.dart';
import 'package:files_tools/basicFunctionalityFunctions/file_name_manager.dart';
import 'package:files_tools/basicFunctionalityFunctions/get_file_name_from_file_path.dart';
import 'package:files_tools/basicFunctionalityFunctions/get_external_storage_file_path_from_file_name.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import '../../basicFunctionalityFunctions/creating_and_saving_pdf_file_temporarily.dart';
import 'package:pdf_merger/pdf_merger.dart';

Future<PdfDocument?> modifyingPDFPagesUsingModifiedPDFDataMap(
    String pdfFilePath,
    Map<String, dynamic> pdfChangesDataMap,
    bool shouldDataBeProcessed) async {
  late PdfDocument? document;
  List<PdfDocument> listOfDocuments = [];
  List<String> tempPdfFilePaths = [];

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

  if (!isEncryptedDocument()) {
    //Disable incremental update by set value as false. This helps decrease the size of pdf on page removal as it rewrites the whole document instead of updating the old one
    //document!.fileStructure.incrementalUpdate = false;

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
    //creating single page documents list from single saved documents
    for (var i = 0;
        i < document!.pages.count && shouldDataBeProcessed == true;
        i++) {
      PdfDocument tempDocument = PdfDocument(
          inputBytes: File(splitResult.pagePaths[i]).readAsBytesSync());
      debugPrint("tempDocument.pages.count: ${tempDocument.pages.count}");
      listOfDocuments.add(tempDocument);
    }
    debugPrint("listOfDocuments.length : ${listOfDocuments.length}");

    //removing saved single page documents as they are loaded in a list already
    for (int i = 0; i < splitResult.pagePaths.length; i++) {
      deletingTempPDFFiles(getFileNameFromFilePath(splitResult.pagePaths[i]));
    }

    //for reorder
    List<PdfDocument> reorderedListOfDocuments = [];
    for (int i = 0;
        i < pdfChangesDataMap['Reordered Page List'].length &&
            shouldDataBeProcessed == true;
        i++) {
      int tmp = pdfChangesDataMap['Reordered Page List'][i] - 1;
      PdfDocument pdfDocument = listOfDocuments[tmp];
      //pdfDocument.pageSettings.rotate = PdfPageRotateAngle.rotateAngle180;
      reorderedListOfDocuments.insert(i, pdfDocument);
    }

    //for rotation
    for (int i = 0;
        i < pdfChangesDataMap['Page Rotations List'].length &&
            shouldDataBeProcessed == true;
        i++) {
      void newAngleDocumentCreator(int angle) {
        //Create new second document.
        PdfDocument newDocument = PdfDocument();
        PdfPage page = reorderedListOfDocuments[i].pages[0];

        //Get page rotation applied
        PdfPageRotateAngle rotationAngle = page.rotation;
        debugPrint("pageRealRotationAngle : $rotationAngle");

        int realAngle = 0;
        if (rotationAngle == PdfPageRotateAngle.rotateAngle0) {
          realAngle = 0;
        } else if (rotationAngle == PdfPageRotateAngle.rotateAngle90) {
          realAngle = 90;
        } else if (rotationAngle == PdfPageRotateAngle.rotateAngle180) {
          realAngle = 180;
        } else if (rotationAngle == PdfPageRotateAngle.rotateAngle270) {
          realAngle = 270;
        }

        PdfPageRotateAngle pdfPageRotateAngle = PdfPageRotateAngle.rotateAngle0;
        if (realAngle + angle == 0 || realAngle + angle == 360) {
          pdfPageRotateAngle = PdfPageRotateAngle.rotateAngle0;
        } else if (realAngle + angle == 90) {
          pdfPageRotateAngle = PdfPageRotateAngle.rotateAngle90;
        } else if (realAngle + angle == 180) {
          pdfPageRotateAngle = PdfPageRotateAngle.rotateAngle180;
        } else if (realAngle + angle == 270) {
          pdfPageRotateAngle = PdfPageRotateAngle.rotateAngle270;
        }

        //Create the page as template.
        PdfTemplate template = page.createTemplate();
        debugPrint(
            "page.size.height: ${page.size.height}, page.size.width: ${page.size.width}");
        //Changing section orientation according to page height & width
        if (page.size.height < page.size.width) {
          newDocument.pageSettings.orientation = PdfPageOrientation.landscape;
          debugPrint('Page is landscape');
        } else {
          newDocument.pageSettings.orientation = PdfPageOrientation.portrait;
          debugPrint('Page is portrait');
        }
        //Set page size and add page.
        newDocument.pageSettings.size = page.size;

        //set document rotation
        newDocument.pageSettings.rotate = pdfPageRotateAngle;

        newDocument.pageSettings.margins.all = 0;
        PdfPage newPage = newDocument.pages.add();
        //Draw the template to the new document page.
        newPage.graphics.drawPdfTemplate(template, const Offset(0, 0));
        // reorderedListOfDocuments[i].pageSettings.rotate =
        //     PdfPageRotateAngle.rotateAngle0;
        reorderedListOfDocuments[i] = newDocument;
      }

      if (pdfChangesDataMap['Page Rotations List'][i] == 0) {
        newAngleDocumentCreator(0);
      } else if (pdfChangesDataMap['Page Rotations List'][i] == 1) {
        newAngleDocumentCreator(90);
      } else if (pdfChangesDataMap['Page Rotations List'][i] == 2) {
        newAngleDocumentCreator(180);
      } else if (pdfChangesDataMap['Page Rotations List'][i] == 3) {
        newAngleDocumentCreator(270);
      }
    }

    //for deletion
    List<PdfDocument> listOfDocumentsToDelete = [];
    for (var i = 0;
        i < pdfChangesDataMap['Deleted Page List'].length &&
            shouldDataBeProcessed == true;
        i++) {
      if (pdfChangesDataMap['Deleted Page List'][i] == false) {
        PdfDocument documentToDelete = reorderedListOfDocuments[i];
        listOfDocumentsToDelete.add(documentToDelete);
      }
    }

    for (var i = 0;
        i < listOfDocumentsToDelete.length && shouldDataBeProcessed == true;
        i++) {
      reorderedListOfDocuments.remove(listOfDocumentsToDelete[i]);
    }

    //save the documents
    for (var i = 0;
        i < reorderedListOfDocuments.length && shouldDataBeProcessed == true;
        i++) {
      String newFileName =
          fileNameWithoutExtension + ' ' + i.toString() + extensionOfFileName;
      Map map = {};
      map['_pdfFileName'] = newFileName;
      map['_extraBetweenNameAndExtension'] = '';
      map['_document'] = reorderedListOfDocuments[i];
      tempPdfFilePaths.add(await creatingAndSavingPDFFileTemporarily(map));
    }
    debugPrint("tempPdfFilePaths : $tempPdfFilePaths");

    //merge the documents
    MergeMultiplePDFResponse response = await PdfMerger.mergeMultiplePDF(
        paths: tempPdfFilePaths,
        outputDirPath: await getExternalStorageFilePathFromFileName(
            fileNameWithoutExtension + ' ' + 'merged' + extensionOfFileName));

    if (response.status == "success") {
      debugPrint(response.response); //for output path  in String
      debugPrint(response.message); // for success message  in String
    }

    //removing unnecessary documents from getExternalStorageDirectory
    for (int i = 0; i < tempPdfFilePaths.length; i++) {
      deletingTempPDFFiles(getFileNameFromFilePath(tempPdfFilePaths[i]));
    }

    //passing final document to document variable
    document = PdfDocument(
        inputBytes: await File(await getExternalStorageFilePathFromFileName(
                fileNameWithoutExtension +
                    ' ' +
                    'merged' +
                    extensionOfFileName))
            .readAsBytes());

    //removing unnecessary documents from getExternalStorageDirectory
    deletingTempPDFFiles(
        fileNameWithoutExtension + ' ' + 'merged' + extensionOfFileName);
  } else {
    document = null;
  }
  // return Future.delayed(const Duration(milliseconds: 500), () {
  return document;
  //});
}
