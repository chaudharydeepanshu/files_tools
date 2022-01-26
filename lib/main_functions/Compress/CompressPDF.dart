import 'package:files_tools/basicFunctionalityFunctions/deletingTempPDFFiles.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/basicFunctionalityFunctions/getExternalStorageFilePathFromFileName.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdf_compressor/pdf_compressor.dart';
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
          inputPath: pdfFilePath,
          outputPath: await getExternalStorageFilePathFromFileName(
              fileNameWithoutExtension +
                  ' ' +
                  'compressed' +
                  extensionOfFileName),
          quality: CompressQuality.MEDIUM,
        );
      } else if (pdfChangesDataMap['PDF Compress Quality'] == "Qualities.low") {
        await PdfCompressor.compressPdfFile(
          inputPath: pdfFilePath,
          outputPath: await getExternalStorageFilePathFromFileName(
              fileNameWithoutExtension +
                  ' ' +
                  'compressed' +
                  extensionOfFileName),
          quality: CompressQuality.LOW,
        );
      } else if (pdfChangesDataMap['PDF Compress Quality'] ==
          "Qualities.high") {
        await PdfCompressor.compressPdfFile(
          inputPath: pdfFilePath,
          outputPath: await getExternalStorageFilePathFromFileName(
              fileNameWithoutExtension +
                  ' ' +
                  'compressed' +
                  extensionOfFileName),
          quality: CompressQuality.HIGH,
        );
      } else if (pdfChangesDataMap['PDF Compress Quality'] ==
          "Qualities.custom") {
        await PdfCompressor.compressPdfFile(
          inputPath: pdfFilePath,
          outputPath: await getExternalStorageFilePathFromFileName(
              fileNameWithoutExtension +
                  ' ' +
                  'compressed' +
                  extensionOfFileName),
          quality: CompressQuality.CUSTOM,
          customQuality: pdfChangesDataMap['Quality Custom Value'],
        );
      }

      //passing final document to document variable
      document = PdfDocument(
          inputBytes: File(await getExternalStorageFilePathFromFileName(
                  fileNameWithoutExtension +
                      ' ' +
                      'compressed' +
                      extensionOfFileName))
              .readAsBytesSync());

      //removing unnecessary documents from getExternalStorageDirectory
      deletingTempPDFFiles(
          fileNameWithoutExtension + ' ' + 'compressed' + extensionOfFileName);
    } catch (e) {
      debugPrint(e.toString());
    }
  } else {
    document = null;
  }

  //return Future.delayed(const Duration(milliseconds: 500), () {
  return document;
  // });
}
