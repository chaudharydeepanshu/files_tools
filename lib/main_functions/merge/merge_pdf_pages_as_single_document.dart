import 'package:flutter/cupertino.dart';
import 'package:pdf_merger/pdf_merger.dart';
// import 'package:pdf_merger/pdf_merger_response.dart';
import 'package:files_tools/basicFunctionalityFunctions/creating_and_saving_pdf_file_temporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/deleting_temp_pdf_files.dart';
import 'package:files_tools/basicFunctionalityFunctions/file_name_manager.dart';
import 'package:files_tools/basicFunctionalityFunctions/get_file_name_from_file_path.dart';
import 'package:files_tools/basicFunctionalityFunctions/get_external_storage_file_path_from_file_name.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

Future<PdfDocument?> mergePDFPagesAsSingleDocument(List<String> pdfFilesPaths,
    Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
  late PdfDocument? document;
  List<PdfDocument> listOfDocuments = [];

  bool isEncryptedDocument() {
    bool isEncrypted = false;
    try {
      for (int i = 0; i < pdfFilesPaths.length; i++) {
        //Load the encrypted PDF document.
        document =
            PdfDocument(inputBytes: File(pdfFilesPaths[i]).readAsBytesSync());
        listOfDocuments.add(document!);
        debugPrint(listOfDocuments.length.toString());
        debugPrint(pdfFilesPaths[i]);
      }
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

    //reordering Documents
    List<PdfDocument> reorderedListOfDocuments = [];
    for (int i = 0;
        i < pdfChangesDataMap['Files Reorder Recorder'].length &&
            shouldDataBeProcessed == true;
        i++) {
      int tmp = pdfChangesDataMap['Files Reorder Recorder'][i] - 1;
      PdfDocument pdfDocument = listOfDocuments[tmp];
      reorderedListOfDocuments.insert(i, pdfDocument);
    }

    //creating and saving single documents from list called finalListOfDocument temporarily
    List<String> tempPdfFilePaths = [];
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

    //passing final document to document variable
    document = PdfDocument(
        inputBytes: File(await getExternalStorageFilePathFromFileName(
                fileNameWithoutExtension +
                    ' ' +
                    'merged' +
                    extensionOfFileName))
            .readAsBytesSync());

    //removing unnecessary documents from getExternalStorageDirectory
    for (int i = 0; i < tempPdfFilePaths.length; i++) {
      deletingTempPDFFiles(getFileNameFromFilePath(tempPdfFilePaths[i]));
    }
    deletingTempPDFFiles(
        fileNameWithoutExtension + ' ' + 'merged' + extensionOfFileName);
  } else {
    document = null;
  }

  //return Future.delayed(const Duration(milliseconds: 500), () {
  return document;
  // });
}