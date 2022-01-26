import 'package:flutter/cupertino.dart';
import 'package:files_tools/basicFunctionalityFunctions/creating_and_saving_pdf_file_temporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/deleting_temp_pdf_files.dart';
import 'package:files_tools/basicFunctionalityFunctions/file_name_manager.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

Future<PdfDocument?> encryptPDF(String pdfFilePath,
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

    TextEditingController textEditingControllerOwnerPassword =
        pdfChangesDataMap['Owner Password TextEditingController'];
    TextEditingController textEditingControllerUserPassword =
        pdfChangesDataMap['User Password TextEditingController'];

    Future<String> securePdf() async {
      String tempEncryptedPDFFilePath;
      //Load the existing PDF document.
      //Get the document security and set user and owner password.
      PdfSecurity security = document!.security;
      security.userPassword = textEditingControllerUserPassword.text.toString();
      if (textEditingControllerOwnerPassword.text.isNotEmpty) {
        debugPrint('ownerPassword set');
        security.ownerPassword =
            textEditingControllerOwnerPassword.text.toString();
      }
      //Set the encryption algorithm and permissions.
      document!.security.algorithm = PdfEncryptionAlgorithm.aesx128Bit;

      // document!.security.permissions
      //     .addAll([PdfPermissionsFlags.print, PdfPermissionsFlags.copyContent]);

      //Save the document temporarily.
      String newFileName = fileNameWithoutExtension +
          ' ' +
          'encrypted' +
          ' ' +
          extensionOfFileName;
      Map map = {};
      map['_pdfFileName'] = newFileName;
      map['_extraBetweenNameAndExtension'] = '';
      map['_document'] = document;
      tempEncryptedPDFFilePath = await creatingAndSavingPDFFileTemporarily(map);
      return tempEncryptedPDFFilePath;
    }

    //passing final document to document variable
    document = PdfDocument(
        inputBytes: File(await securePdf()).readAsBytesSync(),
        password: textEditingControllerUserPassword.text.toString());

    //removing unnecessary documents from getExternalStorageDirectory
    deletingTempPDFFiles(fileNameWithoutExtension +
        ' ' +
        'encrypted' +
        ' ' +
        extensionOfFileName);
  } else {
    debugPrint('document is encrypted');
    document = null;
  }

  //return Future.delayed(const Duration(milliseconds: 500), () {
  return document;
  // });
}
