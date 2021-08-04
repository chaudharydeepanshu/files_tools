import 'package:pdf_compressor/pdf_compressor.dart';
import 'package:files_tools/basicFunctionalityFunctions/deletingTempPDFFiles.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/basicFunctionalityFunctions/getExternalStorageFilePathFromFileName.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

Future<PdfDocument?> compressPDF(String pdfFilePath,
    Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
  late PdfDocument? document;

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

    //Compressing PDF file
    try {
      if (pdfChangesDataMap['PDF Compress Quality'] == "Qualities.medium") {
        await PdfCompressor.compressPdfFile(
            pdfFilePath,
            await getExternalStorageFilePathFromFileName(
                "${fileNameWithoutExtension + ' ' + 'compressed' + extensionOfFileName}"),
            CompressQuality.MEDIUM);
      } else if (pdfChangesDataMap['PDF Compress Quality'] == "Qualities.low") {
        await PdfCompressor.compressPdfFile(
            pdfFilePath,
            await getExternalStorageFilePathFromFileName(
                "${fileNameWithoutExtension + ' ' + 'compressed' + extensionOfFileName}"),
            CompressQuality.LOW);
      } else if (pdfChangesDataMap['PDF Compress Quality'] ==
          "Qualities.high") {
        await PdfCompressor.compressPdfFile(
            pdfFilePath,
            await getExternalStorageFilePathFromFileName(
                "${fileNameWithoutExtension + ' ' + 'compressed' + extensionOfFileName}"),
            CompressQuality.HIGH);
      }
    } catch (e) {
      print(e);
    }

    //passing final document to document variable
    document = PdfDocument(
        inputBytes: File(await getExternalStorageFilePathFromFileName(
                "${fileNameWithoutExtension + ' ' + 'compressed' + extensionOfFileName}"))
            .readAsBytesSync());

    //removing unnecessary documents from getExternalStorageDirectory
    deletingTempPDFFiles(
        "${fileNameWithoutExtension + ' ' + 'compressed' + extensionOfFileName}");

    // //creating and saving single documents from list called finalListOfDocument temporarily
    // List<String> tempPdfFilePaths = [];
    // for (var i = 0;
    //     i < finalListOfDocument.length && shouldDataBeProcessed == true;
    //     i++) {
    //   String newFileName =
    //       "${fileNameWithoutExtension + ' ' + 'range separated' + ' ' + i.toString() + extensionOfFileName}";
    //   Map map = Map();
    //   map['_pdfFileName'] = newFileName;
    //   map['_extraBetweenNameAndExtension'] = '';
    //   map['_document'] = finalListOfDocument[i];
    //   tempPdfFilePaths.add(await creatingAndSavingPDFFileTemporarily(map));
    // }
    // print("tempPdfFilePaths : $tempPdfFilePaths");
    //
    // //merge the documents
    // MergeMultiplePDFResponse response = await PdfMerger.mergeMultiplePDF(
    //     paths: tempPdfFilePaths,
    //     outputDirPath: await getPDFFilePathFromFileName(
    //         "${fileNameWithoutExtension + ' ' + 'final' + ' ' + 'merged' + extensionOfFileName}"));
    //
    // if (response.status == "success") {
    //   print(response.response); //for output path  in String
    //   print(response.message); // for success message  in String
    // }
    //
    // //passing final document to document variable
    // document = PdfDocument(
    //     inputBytes: File(await getPDFFilePathFromFileName(
    //             "${fileNameWithoutExtension + ' ' + 'final' + ' ' + 'merged' + extensionOfFileName}"))
    //         .readAsBytesSync());
    //
    // //removing unnecessary documents from getExternalStorageDirectory
    // for (int i = 0; i < tempPdfFilePaths.length; i++) {
    //   deletingTempPDFFiles("${getFileNameFromFilePath(tempPdfFilePaths[i])}");
    // }
    // deletingTempPDFFiles(
    //     "${fileNameWithoutExtension + ' ' + 'final' + ' ' + 'merged' + extensionOfFileName}");
  } else {
    document = null;
  }

  //return Future.delayed(const Duration(milliseconds: 500), () {
  return document;
  // });
}
