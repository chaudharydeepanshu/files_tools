// import 'package:flutter/cupertino.dart';
// import 'package:pdf_merger/pdf_merger.dart';
// import 'package:pdf_merger/pdf_merger_response.dart';
// import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';
// import 'package:files_tools/basicFunctionalityFunctions/deletingTempPDFFiles.dart';
// import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
// import 'package:files_tools/basicFunctionalityFunctions/getExternalStorageFilePathFromFileName.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'dart:io';
//
// Future<PdfDocument?> customRangePDFPagesAsSingleDocument(String pdfFilePath,
//     Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
//   late PdfDocument? document;
//   List<PdfDocument> listOfDocuments = [];
//   List<List<TextEditingController>> newListTextEditingControllerPairs = [];
//   List<List<bool>> newListOfQuartetsOfButtonsOfRanges = [];
//   List<List<PdfDocument>> listOfRangesDocumentsList = [];
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
//     // creating new reordered list of TextEditingControllerPairs and listOfQuartetsOfButtonsOfRanges. Also removed deleted ranges TextEditingControllerPairs and listOfQuartetsOfButtonsOfRanges.
//     for (int i = 0;
//         i < pdfChangesDataMap['Reordered Range List'].length &&
//             shouldDataBeProcessed == true;
//         i++) {
//       int temp = pdfChangesDataMap['Reordered Range List'][i];
//       newListTextEditingControllerPairs
//           .add(pdfChangesDataMap['listTextEditingControllerPairs'][temp - 1]);
//       newListOfQuartetsOfButtonsOfRanges
//           .add(pdfChangesDataMap['listOfQuartetsOfButtonsOfRanges'][temp - 1]);
//     }
//
//     //creating separate documents lists for each range and then add those list a list called listOfRangesDocumentsList
//     for (int i = 0;
//         i < pdfChangesDataMap['Reordered Range List'].length &&
//             shouldDataBeProcessed == true;
//         i++) {
//       int rangeFirstPageNumber = int.parse(
//           newListTextEditingControllerPairs[i][0].value.text.toString());
//       int rangeLastPageNumber = int.parse(
//           newListTextEditingControllerPairs[i][1].value.text.toString());
//       List<PdfDocument> tempListOfDocuments = [];
//       if (rangeFirstPageNumber == rangeLastPageNumber) {
//         PdfDocument tempDocument = listOfDocuments[rangeFirstPageNumber - 1];
//         tempListOfDocuments.add(tempDocument);
//         listOfRangesDocumentsList.add(tempListOfDocuments);
//         print('equal ranges : $rangeFirstPageNumber , $rangeLastPageNumber');
//         print('normal run');
//       } else if (rangeFirstPageNumber < rangeLastPageNumber) {
//         if (newListOfQuartetsOfButtonsOfRanges[i][0]) {
//           for (int x = rangeFirstPageNumber; x <= rangeLastPageNumber; x++) {
//             PdfDocument tempDocument = listOfDocuments[x - 1];
//             tempListOfDocuments.add(tempDocument);
//           }
//           print('normal run');
//         } else if (newListOfQuartetsOfButtonsOfRanges[i][1]) {
//           int temp = rangeFirstPageNumber;
//           int reversedRangeFirstPageNumber = rangeLastPageNumber;
//           int reversedRangeLastPageNumber = temp;
//           for (int x = reversedRangeFirstPageNumber;
//               x >= reversedRangeLastPageNumber;
//               x--) {
//             PdfDocument tempDocument = listOfDocuments[x - 1];
//             tempListOfDocuments.add(tempDocument);
//           }
//           print('reverse run');
//         } else if (newListOfQuartetsOfButtonsOfRanges[i][2]) {
//           for (int x = rangeFirstPageNumber; x <= rangeLastPageNumber; x++) {
//             if (x.isOdd) {
//               PdfDocument tempDocument = listOfDocuments[x - 1];
//               tempListOfDocuments.add(tempDocument);
//             }
//           }
//           print('odd run');
//         } else if (newListOfQuartetsOfButtonsOfRanges[i][3]) {
//           for (int x = rangeFirstPageNumber; x <= rangeLastPageNumber; x++) {
//             if (x.isEven) {
//               PdfDocument tempDocument = listOfDocuments[x - 1];
//               tempListOfDocuments.add(tempDocument);
//             }
//           }
//           print('even run');
//         }
//         listOfRangesDocumentsList.add(tempListOfDocuments);
//         print(
//             'not equal ranges : $rangeFirstPageNumber , $rangeLastPageNumber');
//       } else if (rangeFirstPageNumber > rangeLastPageNumber) {
//         if (newListOfQuartetsOfButtonsOfRanges[i][0]) {
//           for (int x = rangeFirstPageNumber; x >= rangeLastPageNumber; x--) {
//             PdfDocument tempDocument = listOfDocuments[x - 1];
//             tempListOfDocuments.add(tempDocument);
//           }
//           print('normal run');
//         } else if (newListOfQuartetsOfButtonsOfRanges[i][1]) {
//           int temp = rangeFirstPageNumber;
//           int reversedRangeFirstPageNumber = rangeLastPageNumber;
//           int reversedRangeLastPageNumber = temp;
//           for (int x = reversedRangeFirstPageNumber;
//               x <= reversedRangeLastPageNumber;
//               x++) {
//             PdfDocument tempDocument = listOfDocuments[x - 1];
//             tempListOfDocuments.add(tempDocument);
//           }
//           print('reverse run');
//         } else if (newListOfQuartetsOfButtonsOfRanges[i][2]) {
//           for (int x = rangeFirstPageNumber; x >= rangeLastPageNumber; x--) {
//             if (x.isOdd) {
//               PdfDocument tempDocument = listOfDocuments[x - 1];
//               tempListOfDocuments.add(tempDocument);
//             }
//           }
//           print('odd run');
//         } else if (newListOfQuartetsOfButtonsOfRanges[i][3]) {
//           for (int x = rangeFirstPageNumber; x >= rangeLastPageNumber; x--) {
//             if (x.isEven) {
//               PdfDocument tempDocument = listOfDocuments[x - 1];
//               tempListOfDocuments.add(tempDocument);
//             }
//           }
//           print('even run');
//         }
//         listOfRangesDocumentsList.add(tempListOfDocuments);
//         print(
//             'not equal ranges : $rangeFirstPageNumber , $rangeLastPageNumber');
//       }
//     }
//     print(
//         "listOfRangesDocumentsList[0].length : ${listOfRangesDocumentsList[0].length}");
//     print(
//         "listOfRangesDocumentsList.length : ${listOfRangesDocumentsList.length}");
//
//     // generating extensionOfFileName and fileNameWithoutExtension
//     String extensionOfFileName =
//         extensionOfString(fileName: pdfChangesDataMap['PDF File Name']);
//     String fileNameWithoutExtension = stringWithoutExtension(
//         fileName: pdfChangesDataMap['PDF File Name'],
//         extensionOfString: extensionOfFileName);
//
//     //save the pdf document of separate documents lists in a list called finalListOfDocument
//     List<PdfDocument> finalListOfDocument = [];
//     for (int x = 0;
//         x < listOfRangesDocumentsList.length && shouldDataBeProcessed == true;
//         x++) {
//       List<String> tempPdfFilePaths = [];
//       for (var i = 0;
//           i < listOfRangesDocumentsList[x].length &&
//               shouldDataBeProcessed == true;
//           i++) {
//         String newFileName =
//             "${fileNameWithoutExtension + ' ' + x.toString() + ' ' + i.toString() + extensionOfFileName}";
//         Map map = Map();
//         map['_pdfFileName'] = newFileName;
//         map['_extraBetweenNameAndExtension'] = '';
//         map['_document'] = listOfRangesDocumentsList[x][i];
//         tempPdfFilePaths.add(await creatingAndSavingPDFFileTemporarily(map));
//       }
//       print("tempPdfFilePaths : $tempPdfFilePaths");
//
//       //merge the documents
//       MergeMultiplePDFResponse response = await PdfMerger.mergeMultiplePDF(
//           paths: tempPdfFilePaths,
//           outputDirPath: await getPDFFilePathFromFileName(
//               "${fileNameWithoutExtension + ' ' + x.toString() + ' ' + 'merged' + extensionOfFileName}"));
//
//       if (response.status == "success") {
//         print(response.response); //for output path  in String
//         print(response.message); // for success message  in String
//       }
//
//       //passing final document to tempDocument variable
//       PdfDocument tempDocument = PdfDocument(
//           inputBytes: File(await getPDFFilePathFromFileName(
//                   "${fileNameWithoutExtension + ' ' + x.toString() + ' ' + 'merged' + extensionOfFileName}"))
//               .readAsBytesSync());
//
//       finalListOfDocument.add(tempDocument);
//
//       //removing unnecessary documents from getExternalStorageDirectory
//       for (int y = 0; y < tempPdfFilePaths.length; y++) {
//         deletingTempPDFFiles(
//             "${fileNameWithoutExtension + ' ' + x.toString() + ' ' + y.toString() + extensionOfFileName}");
//       }
//       deletingTempPDFFiles(
//           "${fileNameWithoutExtension + ' ' + x.toString() + ' ' + 'merged' + extensionOfFileName}");
//     }
//
//     //creating a single document from list called finalListOfDocument
//     List<String> tempPdfFilePaths = [];
//     for (var i = 0;
//         i < finalListOfDocument.length && shouldDataBeProcessed == true;
//         i++) {
//       String newFileName =
//           "${fileNameWithoutExtension + ' ' + i.toString() + extensionOfFileName}";
//       Map map = Map();
//       map['_pdfFileName'] = newFileName;
//       map['_extraBetweenNameAndExtension'] = '';
//       map['_document'] = finalListOfDocument[i];
//       tempPdfFilePaths.add(await creatingAndSavingPDFFileTemporarily(map));
//     }
//     print("tempPdfFilePaths : $tempPdfFilePaths");
//
//     //merge the documents
//     MergeMultiplePDFResponse response = await PdfMerger.mergeMultiplePDF(
//         paths: tempPdfFilePaths,
//         outputDirPath: await getPDFFilePathFromFileName(
//             "${fileNameWithoutExtension + ' ' + 'final' + ' ' + 'merged' + extensionOfFileName}"));
//
//     if (response.status == "success") {
//       print(response.response); //for output path  in String
//       print(response.message); // for success message  in String
//     }
//
//     //passing final document to document variable
//     document = PdfDocument(
//         inputBytes: File(await getPDFFilePathFromFileName(
//                 "${fileNameWithoutExtension + ' ' + 'final' + ' ' + 'merged' + extensionOfFileName}"))
//             .readAsBytesSync());
//
//     //removing unnecessary documents from getExternalStorageDirectory
//     for (int i = 0; i < tempPdfFilePaths.length; i++) {
//       deletingTempPDFFiles(
//           "${fileNameWithoutExtension + ' ' + i.toString() + extensionOfFileName}");
//     }
//     deletingTempPDFFiles(
//         "${fileNameWithoutExtension + ' ' + 'final' + ' ' + 'merged' + extensionOfFileName}");
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
import 'package:pdf_merger/pdf_merger_response.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/deletingTempPDFFiles.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/basicFunctionalityFunctions/getFileNameFromFilePath.dart';
import 'package:files_tools/basicFunctionalityFunctions/getExternalStorageFilePathFromFileName.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

Future<PdfDocument?> customRangePDFPagesAsSingleDocument(String pdfFilePath,
    Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
  late PdfDocument? document;
  List<PdfDocument> listOfDocuments = [];
  List<List<TextEditingController>> newListTextEditingControllerPairs = [];
  List<List<bool>> newListOfQuartetsOfButtonsOfRanges = [];
  List<List<PdfDocument>> listOfRangesDocumentsList = [];

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
    //creating single page documents list from single saved documents
    for (var i = 0;
        i < document!.pages.count && shouldDataBeProcessed == true;
        i++) {
      PdfDocument tempDocument = PdfDocument(
          inputBytes: File(splitResult.pagePaths[i]).readAsBytesSync());
      print("tempDocument.pages.count: ${tempDocument.pages.count}");
      listOfDocuments.add(tempDocument);
    }
    print("listOfDocuments.length : ${listOfDocuments.length}");

    //removing saved single page documents as they are loaded in a list already
    for (int i = 0; i < splitResult.pagePaths.length; i++) {
      deletingTempPDFFiles(
          "${getFileNameFromFilePath(splitResult.pagePaths[i])}");
    }

    // creating new reordered list of TextEditingControllerPairs and listOfQuartetsOfButtonsOfRanges. Also removed deleted ranges TextEditingControllerPairs and listOfQuartetsOfButtonsOfRanges.
    for (int i = 0;
        i < pdfChangesDataMap['Reordered Range List'].length &&
            shouldDataBeProcessed == true;
        i++) {
      int temp = pdfChangesDataMap['Reordered Range List'][i];
      newListTextEditingControllerPairs
          .add(pdfChangesDataMap['listTextEditingControllerPairs'][temp - 1]);
      newListOfQuartetsOfButtonsOfRanges
          .add(pdfChangesDataMap['listOfQuartetsOfButtonsOfRanges'][temp - 1]);
    }

    //creating separate documents lists for each range and then add those list a list called listOfRangesDocumentsList
    for (int i = 0;
        i < pdfChangesDataMap['Reordered Range List'].length &&
            shouldDataBeProcessed == true;
        i++) {
      int rangeFirstPageNumber = int.parse(
          newListTextEditingControllerPairs[i][0].value.text.toString());
      int rangeLastPageNumber = int.parse(
          newListTextEditingControllerPairs[i][1].value.text.toString());
      List<PdfDocument> tempListOfDocuments = [];
      if (rangeFirstPageNumber == rangeLastPageNumber) {
        PdfDocument tempDocument = listOfDocuments[rangeFirstPageNumber - 1];
        tempListOfDocuments.add(tempDocument);
        listOfRangesDocumentsList.add(tempListOfDocuments);
        print('equal ranges : $rangeFirstPageNumber , $rangeLastPageNumber');
        print('normal run');
      } else if (rangeFirstPageNumber < rangeLastPageNumber) {
        if (newListOfQuartetsOfButtonsOfRanges[i][0]) {
          for (int x = rangeFirstPageNumber; x <= rangeLastPageNumber; x++) {
            PdfDocument tempDocument = listOfDocuments[x - 1];
            tempListOfDocuments.add(tempDocument);
          }
          print('normal run');
        } else if (newListOfQuartetsOfButtonsOfRanges[i][1]) {
          int temp = rangeFirstPageNumber;
          int reversedRangeFirstPageNumber = rangeLastPageNumber;
          int reversedRangeLastPageNumber = temp;
          for (int x = reversedRangeFirstPageNumber;
              x >= reversedRangeLastPageNumber;
              x--) {
            PdfDocument tempDocument = listOfDocuments[x - 1];
            tempListOfDocuments.add(tempDocument);
          }
          print('reverse run');
        } else if (newListOfQuartetsOfButtonsOfRanges[i][2]) {
          for (int x = rangeFirstPageNumber; x <= rangeLastPageNumber; x++) {
            if (x.isOdd) {
              PdfDocument tempDocument = listOfDocuments[x - 1];
              tempListOfDocuments.add(tempDocument);
            }
          }
          print('odd run');
        } else if (newListOfQuartetsOfButtonsOfRanges[i][3]) {
          for (int x = rangeFirstPageNumber; x <= rangeLastPageNumber; x++) {
            if (x.isEven) {
              PdfDocument tempDocument = listOfDocuments[x - 1];
              tempListOfDocuments.add(tempDocument);
            }
          }
          print('even run');
        }
        listOfRangesDocumentsList.add(tempListOfDocuments);
        print(
            'not equal ranges : $rangeFirstPageNumber , $rangeLastPageNumber');
      } else if (rangeFirstPageNumber > rangeLastPageNumber) {
        if (newListOfQuartetsOfButtonsOfRanges[i][0]) {
          for (int x = rangeFirstPageNumber; x >= rangeLastPageNumber; x--) {
            PdfDocument tempDocument = listOfDocuments[x - 1];
            tempListOfDocuments.add(tempDocument);
          }
          print('normal run');
        } else if (newListOfQuartetsOfButtonsOfRanges[i][1]) {
          int temp = rangeFirstPageNumber;
          int reversedRangeFirstPageNumber = rangeLastPageNumber;
          int reversedRangeLastPageNumber = temp;
          for (int x = reversedRangeFirstPageNumber;
              x <= reversedRangeLastPageNumber;
              x++) {
            PdfDocument tempDocument = listOfDocuments[x - 1];
            tempListOfDocuments.add(tempDocument);
          }
          print('reverse run');
        } else if (newListOfQuartetsOfButtonsOfRanges[i][2]) {
          for (int x = rangeFirstPageNumber; x >= rangeLastPageNumber; x--) {
            if (x.isOdd) {
              PdfDocument tempDocument = listOfDocuments[x - 1];
              tempListOfDocuments.add(tempDocument);
            }
          }
          print('odd run');
        } else if (newListOfQuartetsOfButtonsOfRanges[i][3]) {
          for (int x = rangeFirstPageNumber; x >= rangeLastPageNumber; x--) {
            if (x.isEven) {
              PdfDocument tempDocument = listOfDocuments[x - 1];
              tempListOfDocuments.add(tempDocument);
            }
          }
          print('even run');
        }
        listOfRangesDocumentsList.add(tempListOfDocuments);
        print(
            'not equal ranges : $rangeFirstPageNumber , $rangeLastPageNumber');
      }
    }
    print(
        "listOfRangesDocumentsList[0].length : ${listOfRangesDocumentsList[0].length}");
    print(
        "listOfRangesDocumentsList.length : ${listOfRangesDocumentsList.length}");

    //save the pdf document of separate documents lists in a list called finalListOfDocument
    List<PdfDocument> finalListOfDocument = [];
    for (int x = 0;
        x < listOfRangesDocumentsList.length && shouldDataBeProcessed == true;
        x++) {
      List<String> tempPdfFilePaths = [];
      for (var i = 0;
          i < listOfRangesDocumentsList[x].length &&
              shouldDataBeProcessed == true;
          i++) {
        String newFileName =
            "${fileNameWithoutExtension + ' ' + x.toString() + ' ' + i.toString() + extensionOfFileName}";
        Map map = Map();
        map['_pdfFileName'] = newFileName;
        map['_extraBetweenNameAndExtension'] = '';
        map['_document'] = listOfRangesDocumentsList[x][i];
        tempPdfFilePaths.add(await creatingAndSavingPDFFileTemporarily(map));
      }
      print("tempPdfFilePaths : $tempPdfFilePaths");

      //merge the documents
      MergeMultiplePDFResponse response = await PdfMerger.mergeMultiplePDF(
          paths: tempPdfFilePaths,
          outputDirPath: await getExternalStorageFilePathFromFileName(
              "${fileNameWithoutExtension + ' ' + x.toString() + ' ' + 'merged' + extensionOfFileName}"));

      if (response.status == "success") {
        print(response.response); //for output path  in String
        print(response.message); // for success message  in String
      }

      //passing final document to tempDocument variable
      PdfDocument tempDocument = PdfDocument(
          inputBytes: File(await getExternalStorageFilePathFromFileName(
                  "${fileNameWithoutExtension + ' ' + x.toString() + ' ' + 'merged' + extensionOfFileName}"))
              .readAsBytesSync());

      finalListOfDocument.add(tempDocument);

      //removing unnecessary documents from getExternalStorageDirectory
      for (int y = 0; y < tempPdfFilePaths.length; y++) {
        deletingTempPDFFiles("${getFileNameFromFilePath(tempPdfFilePaths[y])}");
      }
      deletingTempPDFFiles(
          "${fileNameWithoutExtension + ' ' + x.toString() + ' ' + 'merged' + extensionOfFileName}");
    }

    //creating and saving single documents from list called finalListOfDocument temporarily
    List<String> tempPdfFilePaths = [];
    for (var i = 0;
        i < finalListOfDocument.length && shouldDataBeProcessed == true;
        i++) {
      String newFileName =
          "${fileNameWithoutExtension + ' ' + 'range separated' + ' ' + i.toString() + extensionOfFileName}";
      Map map = Map();
      map['_pdfFileName'] = newFileName;
      map['_extraBetweenNameAndExtension'] = '';
      map['_document'] = finalListOfDocument[i];
      tempPdfFilePaths.add(await creatingAndSavingPDFFileTemporarily(map));
    }
    print("tempPdfFilePaths : $tempPdfFilePaths");

    //merge the documents
    MergeMultiplePDFResponse response = await PdfMerger.mergeMultiplePDF(
        paths: tempPdfFilePaths,
        outputDirPath: await getExternalStorageFilePathFromFileName(
            "${fileNameWithoutExtension + ' ' + 'final' + ' ' + 'merged' + extensionOfFileName}"));

    if (response.status == "success") {
      print(response.response); //for output path  in String
      print(response.message); // for success message  in String
    }

    //passing final document to document variable
    document = PdfDocument(
        inputBytes: File(await getExternalStorageFilePathFromFileName(
                "${fileNameWithoutExtension + ' ' + 'final' + ' ' + 'merged' + extensionOfFileName}"))
            .readAsBytesSync());

    //removing unnecessary documents from getExternalStorageDirectory
    for (int i = 0; i < tempPdfFilePaths.length; i++) {
      deletingTempPDFFiles("${getFileNameFromFilePath(tempPdfFilePaths[i])}");
    }
    deletingTempPDFFiles(
        "${fileNameWithoutExtension + ' ' + 'final' + ' ' + 'merged' + extensionOfFileName}");
  } else {
    document = null;
  }

  //return Future.delayed(const Duration(milliseconds: 500), () {
  return document;
  // });
}
