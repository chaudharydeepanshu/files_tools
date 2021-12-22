// import 'package:flutter/cupertino.dart';
// import 'package:pdf_merger/pdf_merger.dart';
// import 'package:pdf_merger/pdf_merger_response.dart';
// import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';
// import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
// import 'package:files_tools/basicFunctionalityFunctions/getExternalStorageFilePathFromFileName.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'dart:io';
// import 'package:files_tools/basicFunctionalityFunctions/deletingTempPDFFiles.dart';
//
// Future<List<String>?> fixedRangePDFPages(String pdfFilePath,
//     Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
//   late PdfDocument? document;
//   List<PdfDocument> listOfDocuments = [];
//   List<List<PdfDocument>> listOfRangesDocumentsList = [];
//   List<String>? rangesPdfsFilePaths = [];
//   TextEditingController textEditingController =
//       pdfChangesDataMap['TextEditingController'];
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
//     //creating separate documents lists for each range and then add those list a list called listOfRangesDocumentsList
//     int splitRangeNumber =
//         int.parse(textEditingController.value.text.toString());
//     for (int i = 0;
//         i < pdfChangesDataMap['Number Of PDFs'] &&
//             shouldDataBeProcessed == true;
//         i++) {
//       if (i < pdfChangesDataMap['Number Of PDFs'] - 1) {
//         List<PdfDocument> tempListOfDocuments = [];
//         List<PdfDocument> listOfDocumentsAddedToTempListOfDocuments =
//             List<PdfDocument>.generate(splitRangeNumber, (int index) {
//           return listOfDocuments[
//               (listOfRangesDocumentsList.length * splitRangeNumber) + index];
//         }); // generating list of documents for different intervals based on how many list of Ranges Documents List already added
//         tempListOfDocuments.addAll(listOfDocumentsAddedToTempListOfDocuments);
//         listOfRangesDocumentsList.add(tempListOfDocuments);
//       } //for document lists other than last interval document lists
//       else if (i == pdfChangesDataMap['Number Of PDFs'] - 1) {
//         List<PdfDocument> tempListOfDocuments = [];
//         List<PdfDocument> listOfDocumentsAddedToTempListOfDocuments =
//             List<PdfDocument>.generate(
//                 listOfDocuments.length -
//                     (listOfRangesDocumentsList.length * splitRangeNumber),
//                 (int index) {
//           return listOfDocuments[
//               (listOfRangesDocumentsList.length * splitRangeNumber) + index];
//         }); // generating list of documents for last interval on the basis of how many range lis are present and how many documents are left out
//         tempListOfDocuments.addAll(listOfDocumentsAddedToTempListOfDocuments);
//         listOfRangesDocumentsList.add(tempListOfDocuments);
//       } // for last document list as last document list could have non perfect number of documents // fox example a pdf of 4 pages split with interval 3 as then first document would have 3 pages and other will have 1. So in this we decide what and how many documents to send in the last interval
//     }
//
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
//     //save the pdf documents of separate documents lists in a list called finalListOfDocument //for example a range contain 3 documents then save them to a single document and add to list finalListOfDocument
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
//       //adding the prepared final document of range to finalListOfDocument
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
//     //saving ranges single document from list called finalListOfDocument
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
//     rangesPdfsFilePaths = List.from(tempPdfFilePaths);
//   } else {
//     rangesPdfsFilePaths = null;
//   }
//
//   //return Future.delayed(const Duration(milliseconds: 500), () {
//   return rangesPdfsFilePaths;
//   // });
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter_pdf_split/flutter_pdf_split.dart';
import 'package:pdf_merger/pdf_merger.dart';
// import 'package:pdf_merger/pdf_merger_response.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/basicFunctionalityFunctions/getFileNameFromFilePath.dart';
import 'package:files_tools/basicFunctionalityFunctions/getExternalStorageFilePathFromFileName.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import 'package:files_tools/basicFunctionalityFunctions/deletingTempPDFFiles.dart';

Future<List<String>?> fixedRangePDFPages(String pdfFilePath,
    Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
  late PdfDocument? document;
  List<PdfDocument> listOfDocuments = [];
  List<List<PdfDocument>> listOfRangesDocumentsList = [];
  List<String>? rangesPdfsFilePaths = [];
  TextEditingController textEditingController =
      pdfChangesDataMap['TextEditingController'];

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
          "${fileNameWithoutExtension + ' ' + (i + 1).toString() + extensionOfFileName}");
    }

    //creating separate documents lists for each range and then add those list a list called listOfRangesDocumentsList
    int splitRangeNumber =
        int.parse(textEditingController.value.text.toString());
    for (int i = 0;
        i < pdfChangesDataMap['Number Of PDFs'] &&
            shouldDataBeProcessed == true;
        i++) {
      if (i < pdfChangesDataMap['Number Of PDFs'] - 1) {
        List<PdfDocument> tempListOfDocuments = [];
        List<PdfDocument> listOfDocumentsAddedToTempListOfDocuments =
            List<PdfDocument>.generate(splitRangeNumber, (int index) {
          return listOfDocuments[
              (listOfRangesDocumentsList.length * splitRangeNumber) + index];
        }); // generating list of documents for different intervals based on how many list of Ranges Documents List already added
        tempListOfDocuments.addAll(listOfDocumentsAddedToTempListOfDocuments);
        listOfRangesDocumentsList.add(tempListOfDocuments);
      } //for document lists other than last interval document lists
      else if (i == pdfChangesDataMap['Number Of PDFs'] - 1) {
        List<PdfDocument> tempListOfDocuments = [];
        List<PdfDocument> listOfDocumentsAddedToTempListOfDocuments =
            List<PdfDocument>.generate(
                listOfDocuments.length -
                    (listOfRangesDocumentsList.length * splitRangeNumber),
                (int index) {
          return listOfDocuments[
              (listOfRangesDocumentsList.length * splitRangeNumber) + index];
        }); // generating list of documents for last interval on the basis of how many range lis are present and how many documents are left out
        tempListOfDocuments.addAll(listOfDocumentsAddedToTempListOfDocuments);
        listOfRangesDocumentsList.add(tempListOfDocuments);
      } // for last document list as last document list could have non perfect number of documents // fox example a pdf of 4 pages split with interval 3 as then first document would have 3 pages and other will have 1. So in this we decide what and how many documents to send in the last interval
    }

    print(
        "listOfRangesDocumentsList[0].length : ${listOfRangesDocumentsList[0].length}");
    print(
        "listOfRangesDocumentsList.length : ${listOfRangesDocumentsList.length}");

    //save the pdf documents of separate documents lists in a list called finalListOfDocument //for example a range contain 3 documents then save them to a single document and add to list finalListOfDocument
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

      //adding the prepared final document of range to finalListOfDocument
      finalListOfDocument.add(tempDocument);

      //removing unnecessary documents from getExternalStorageDirectory
      for (int y = 0; y < tempPdfFilePaths.length; y++) {
        deletingTempPDFFiles("${getFileNameFromFilePath(tempPdfFilePaths[y])}");
      }
      deletingTempPDFFiles(
          "${fileNameWithoutExtension + ' ' + x.toString() + ' ' + 'merged' + extensionOfFileName}");
    }

    //creating and saving single documents from list called finalListOfDocument
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

    rangesPdfsFilePaths = List.from(tempPdfFilePaths);
  } else {
    rangesPdfsFilePaths = null;
  }

  //return Future.delayed(const Duration(milliseconds: 500), () {
  return rangesPdfsFilePaths;
  // });
}
