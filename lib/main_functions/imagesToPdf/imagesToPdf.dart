// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:files_tools/basicFunctionalityFunctions/deletingTempPDFFiles.dart';
// import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
// import 'package:files_tools/basicFunctionalityFunctions/getFileNameFromFilePath.dart';
// import 'package:files_tools/basicFunctionalityFunctions/getExternalStorageFilePathFromFileName.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'dart:io';
// import 'dart:async';
// import '../../basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';
// import 'package:pdf_merger/pdf_merger.dart';
// import 'package:flutter/material.dart';
//
// Future<PdfDocument?> imagesToPdf(List<String> imageFilePaths,
//     Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
//   late PdfDocument? document;
//   List<PdfDocument> listOfDocuments = [];
//   List<String> tempPdfFilePaths = [];
//
//   // generating extensionOfFileName and fileNameWithoutExtension
//   print(pdfChangesDataMap['PDF File Name']);
//   String extensionOfFileName =
//       extensionOfString(fileName: pdfChangesDataMap['PDF File Name']);
//   String fileNameWithoutExtension = stringWithoutExtension(
//       fileName: pdfChangesDataMap['PDF File Name'],
//       extensionOfString: extensionOfFileName);
//
//   Future<PdfDocument> _convertImageToPDF(int index) async {
//     //get file width and height
//     File image = new File(
//         imageFilePaths[index]); // Or any other way to get a File instance.
//     var decodedImage = await decodeImageFromList(image.readAsBytesSync());
//     double width = decodedImage.width.toDouble();
//     double height = decodedImage.height.toDouble();
//     print(decodedImage.width);
//     print(decodedImage.height);
//
//     //use this when getting height and width of asset image
//     // final Image image1 = Image.asset('images/Screenshot (1).png');
//     // Completer<ui.Image> completer = new Completer<ui.Image>();
//     // image1.image
//     //     .resolve(new ImageConfiguration())
//     //     .addListener(new ImageStreamListener((ImageInfo image1, bool _) {
//     //   completer.complete(image1.image);
//     // }));
//     // ui.Image info = await completer.future;
//     // double width = info.width.toDouble();
//     // double height = info.height.toDouble();
//     // print("${width.toString() + ',' + height.toString()}");
//
//     //Create the PDF document
//     PdfDocument document = PdfDocument();
//     //set document orientation according to image size width
//     if (height > width) {
//       document.pageSettings.orientation = PdfPageOrientation.portrait;
//     } else if (height < width) {
//       document.pageSettings.orientation = PdfPageOrientation.landscape;
//     }
//     //setting document size
//     document.pageSettings.size = Size(width, height);
//     //removing any margin from document
//     document.pageSettings.margins.all = 0;
//     //Add the page
//     PdfPage page = document.pages.add();
//
//     //getting imageData of image as File
//     Future<List<int>> _readImageData() async {
//       Uint8List bytes = image.readAsBytesSync();
//       final ByteData data = ByteData.view(bytes.buffer);
//       return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//     }
//
//     List<int> imageData = await _readImageData();
//
//     //Load the image.
//     final PdfImage pdfImage = PdfBitmap(imageData);
//
//     print(document.pageSettings.size);
//     //draw image to the first page
//     page.graphics.drawImage(
//         pdfImage, Rect.fromLTWH(0, 0, page.size.width, page.size.height));
//
//     return document;
//   }
//
//   for (int i = 0; i < imageFilePaths.length; i++) {
//     listOfDocuments.add(await _convertImageToPDF(i));
//   }
//
//   //for reorder
//   List<PdfDocument> reorderedListOfDocuments = [];
//   for (int i = 0;
//       i < pdfChangesDataMap['Reordered Page List'].length &&
//           shouldDataBeProcessed == true;
//       i++) {
//     int tmp = pdfChangesDataMap['Reordered Page List'][i] - 1;
//     PdfDocument pdfDocument = listOfDocuments[tmp];
//     //pdfDocument.pageSettings.rotate = PdfPageRotateAngle.rotateAngle180;
//     reorderedListOfDocuments.insert(i, pdfDocument);
//   }
//
//   //for rotation
//   for (int i = 0;
//       i < pdfChangesDataMap['Page Rotations List'].length &&
//           shouldDataBeProcessed == true;
//       i++) {
//     if (pdfChangesDataMap['Page Rotations List'][i] == 0) {
//       reorderedListOfDocuments[i].pageSettings.rotate =
//           PdfPageRotateAngle.rotateAngle0;
//     } else if (pdfChangesDataMap['Page Rotations List'][i] == 1) {
//       reorderedListOfDocuments[i].pageSettings.rotate =
//           PdfPageRotateAngle.rotateAngle90;
//     } else if (pdfChangesDataMap['Page Rotations List'][i] == 2) {
//       reorderedListOfDocuments[i].pageSettings.rotate =
//           PdfPageRotateAngle.rotateAngle180;
//     } else if (pdfChangesDataMap['Page Rotations List'][i] == 3) {
//       reorderedListOfDocuments[i].pageSettings.rotate =
//           PdfPageRotateAngle.rotateAngle270;
//     }
//   }
//
//   List<PdfDocument> listOfDocumentsToDelete = [];
//   for (var i = 0;
//       i < pdfChangesDataMap['Deleted Page List'].length &&
//           shouldDataBeProcessed == true;
//       i++) {
//     if (pdfChangesDataMap['Deleted Page List'][i] == false) {
//       PdfDocument documentToDelete = reorderedListOfDocuments[i];
//       listOfDocumentsToDelete.add(documentToDelete);
//     }
//   }
//
//   for (var i = 0;
//       i < listOfDocumentsToDelete.length && shouldDataBeProcessed == true;
//       i++) {
//     reorderedListOfDocuments.remove(listOfDocumentsToDelete[i]);
//   }
//
//   //save the documents
//   for (var i = 0;
//       i < reorderedListOfDocuments.length && shouldDataBeProcessed == true;
//       i++) {
//     String newFileName =
//         "${fileNameWithoutExtension + ' ' + i.toString() + extensionOfFileName}";
//     Map map = Map();
//     map['_pdfFileName'] = newFileName;
//     map['_extraBetweenNameAndExtension'] = '';
//     map['_document'] = reorderedListOfDocuments[i];
//     tempPdfFilePaths.add(await creatingAndSavingPDFFileTemporarily(map));
//   }
//   print("tempPdfFilePaths : $tempPdfFilePaths");
//
//   //merge the documents
//   MergeMultiplePDFResponse response = await PdfMerger.mergeMultiplePDF(
//       paths: tempPdfFilePaths,
//       outputDirPath: await getExternalStorageFilePathFromFileName(
//           "${fileNameWithoutExtension + ' ' + 'merged' + extensionOfFileName}"));
//
//   if (response.status == "success") {
//     print(response.response); //for output path  in String
//     print(response.message); // for success message  in String
//   }
//
//   //removing unnecessary documents from getExternalStorageDirectory
//   for (int i = 0; i < tempPdfFilePaths.length; i++) {
//     deletingTempPDFFiles("${getFileNameFromFilePath(tempPdfFilePaths[i])}");
//   }
//
//   //passing final document to document variable
//   document = PdfDocument(
//       inputBytes: await File(await getExternalStorageFilePathFromFileName(
//               "${fileNameWithoutExtension + ' ' + 'merged' + extensionOfFileName}"))
//           .readAsBytes());
//
//   //removing unnecessary documents from getExternalStorageDirectory
//   deletingTempPDFFiles(
//       "${fileNameWithoutExtension + ' ' + 'merged' + extensionOfFileName}");
//   // return Future.delayed(const Duration(milliseconds: 500), () {
//   return document;
//   //});
// }
import 'dart:typed_data';
import 'package:files_tools/basicFunctionalityFunctions/rotatingImageFile.dart';
// import 'package:flutter/services.dart';
import 'package:files_tools/basicFunctionalityFunctions/deletingTempPDFFiles.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/basicFunctionalityFunctions/getFileNameFromFilePath.dart';
import 'package:files_tools/basicFunctionalityFunctions/getExternalStorageFilePathFromFileName.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import 'dart:async';
import '../../basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';
import 'package:pdf_merger/pdf_merger.dart';
import 'package:flutter/material.dart';

Future<PdfDocument?> imagesToPdf(List<String> imageFilePaths,
    Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
  late PdfDocument? document;
  List<PdfDocument> listOfDocuments = [];
  List<String> tempPdfFilePaths = [];

  // generating extensionOfFileName and fileNameWithoutExtension
  debugPrint(pdfChangesDataMap['PDF File Name']);
  String extensionOfFileName =
      extensionOfString(fileName: pdfChangesDataMap['PDF File Name']);
  String fileNameWithoutExtension = stringWithoutExtension(
      fileName: pdfChangesDataMap['PDF File Name'],
      extensionOfString: extensionOfFileName);

  //getting imageData of image as File
  Future<List<int>> _readImageData(File image) async {
    Uint8List bytes = image.readAsBytesSync();
    final ByteData data = ByteData.view(bytes.buffer);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<PdfDocument> _convertImageToPDF(int index) async {
    File image =
        File(imageFilePaths[index]); // Or any other way to get a File instance.

    //for rotation
    //reassigning image variable with rotation
    if (pdfChangesDataMap['Page Rotations List'][index] == 0) {
      image = await rotateImage(
          rotation: 0,
          file: File(imageFilePaths[index]),
          imageFileName: getFileNameFromFilePath(imageFilePaths[index]));
    } else if (pdfChangesDataMap['Page Rotations List'][index] == 1) {
      image = await rotateImage(
          rotation: 90,
          file: File(imageFilePaths[index]),
          imageFileName: getFileNameFromFilePath(imageFilePaths[index]));
    } else if (pdfChangesDataMap['Page Rotations List'][index] == 2) {
      image = await rotateImage(
          rotation: 180,
          file: File(imageFilePaths[index]),
          imageFileName: getFileNameFromFilePath(imageFilePaths[index]));
    } else if (pdfChangesDataMap['Page Rotations List'][index] == 3) {
      image = await rotateImage(
          rotation: 270,
          file: File(imageFilePaths[index]),
          imageFileName: getFileNameFromFilePath(imageFilePaths[index]));
    }

    //Create the PDF document
    PdfDocument document = PdfDocument();

    //Create PDF section.
    PdfSection section = document.sections!.add();
    //Load the image.
    List<int> imageData = await _readImageData(image);
    final PdfImage pdfImage = PdfBitmap(imageData);

    double pageWidth = pdfImage.width.toDouble();
    double pageHeight = pdfImage.height.toDouble();

    if (pdfChangesDataMap['Is Same Width Enabled'] == true) {
      //Width for all PDF pages
      pageWidth = 960;
      //Caculating page height based on the fixed width and aspect ratio of the image
      double ratio = pageWidth / pdfImage.width;
      pageHeight = pdfImage.height * ratio;
    }

    //set section orientation according to image size width
    if (pageHeight >= pageWidth) {
      section.pageSettings.orientation = PdfPageOrientation.portrait;
    } else if (pageHeight < pageWidth) {
      section.pageSettings.orientation = PdfPageOrientation.landscape;
    }

    debugPrint(
        "Img $index - width: ${pageWidth.toString() + ', height: ' + pageHeight.toString()}");

    //setting section size
    section.pageSettings.size = Size(pageWidth, pageHeight);

    //removing any margin from document
    section.pageSettings.margins.all = 0;

    //Add the page
    PdfPage page = section.pages.add();
    //Load the image.

    //draw image to the first page
    page.graphics.drawImage(
        pdfImage, Rect.fromLTWH(0, 0, page.size.width, page.size.height));

    return document;
  }

  for (int i = 0; i < imageFilePaths.length; i++) {
    listOfDocuments.add(await _convertImageToPDF(i));
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

  // //for rotation
  // for (int i = 0;
  //     i < pdfChangesDataMap['Page Rotations List'].length &&
  //         shouldDataBeProcessed == true;
  //     i++) {
  //   if (pdfChangesDataMap['Page Rotations List'][i] == 0) {
  //     reorderedListOfDocuments[i].pageSettings.rotate =
  //         PdfPageRotateAngle.rotateAngle0;
  //   } else if (pdfChangesDataMap['Page Rotations List'][i] == 1) {
  //     reorderedListOfDocuments[i].pageSettings.rotate =
  //         PdfPageRotateAngle.rotateAngle90;
  //   } else if (pdfChangesDataMap['Page Rotations List'][i] == 2) {
  //     reorderedListOfDocuments[i].pageSettings.rotate =
  //         PdfPageRotateAngle.rotateAngle180;
  //   } else if (pdfChangesDataMap['Page Rotations List'][i] == 3) {
  //     reorderedListOfDocuments[i].pageSettings.rotate =
  //         PdfPageRotateAngle.rotateAngle270;
  //   }
  // }

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
              fileNameWithoutExtension + ' ' + 'merged' + extensionOfFileName))
          .readAsBytes());

  //removing unnecessary documents from getExternalStorageDirectory
  deletingTempPDFFiles(
      fileNameWithoutExtension + ' ' + 'merged' + extensionOfFileName);
  // return Future.delayed(const Duration(milliseconds: 500), () {
  return document;
  //});
}
