import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

Future<dynamic> decryptPDF(String pdfFilePath,
    Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
  late var document;

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

  if (isEncryptedDocument()) {
    debugPrint('document is encrypted');

    TextEditingController textEditingControllerOwnerPassword =
        pdfChangesDataMap['Owner Password TextEditingController'];
    TextEditingController textEditingControllerUserPassword =
        pdfChangesDataMap['User Password TextEditingController'];

    // String findHowDocumentIsProtected() {
    //   String documentType = 'Not Protected';
    //
    //   //open with user password
    //   if (PdfDocument(
    //                   inputBytes: File(pdfFilePath).readAsBytesSync(),
    //                   password:
    //                       "${textEditingControllerUserPassword.text.toString()}")
    //               .security
    //               .userPassword ==
    //           "${textEditingControllerUserPassword.text.toString()}" &&
    //       PdfDocument(
    //                   inputBytes: File(pdfFilePath).readAsBytesSync(),
    //                   password:
    //                       "${textEditingControllerUserPassword.text.toString()}")
    //               .security
    //               .ownerPassword ==
    //           "") {
    //     documentType = 'Secured With Both';
    //   } else if (PdfDocument(
    //                   inputBytes: File(pdfFilePath).readAsBytesSync(),
    //                   password:
    //                       "${textEditingControllerUserPassword.text.toString()}")
    //               .security
    //               .userPassword ==
    //           "${textEditingControllerUserPassword.text.toString()}" &&
    //       PdfDocument(
    //                   inputBytes: File(pdfFilePath).readAsBytesSync(),
    //                   password:
    //                       "${textEditingControllerUserPassword.text.toString()}")
    //               .security
    //               .ownerPassword ==
    //           "${textEditingControllerOwnerPassword.text.toString()}") {
    //     documentType = 'Secured With User';
    //   }
    //   //open with owner password
    //   else if (PdfDocument(
    //                   inputBytes: File(pdfFilePath).readAsBytesSync(),
    //                   password:
    //                       "${textEditingControllerOwnerPassword.text.toString()}")
    //               .security
    //               .userPassword ==
    //           "" &&
    //       PdfDocument(
    //                   inputBytes: File(pdfFilePath).readAsBytesSync(),
    //                   password:
    //                       "${textEditingControllerOwnerPassword.text.toString()}")
    //               .security
    //               .ownerPassword ==
    //           "${textEditingControllerOwnerPassword.text.toString()}") {
    //     documentType = 'Secured With Owner';
    //   } else if ((PdfDocument(
    //                       inputBytes: File(pdfFilePath).readAsBytesSync(),
    //                       password:
    //                           "${textEditingControllerOwnerPassword.text.toString()}")
    //                   .security
    //                   .userPassword ==
    //               "${textEditingControllerUserPassword.text.toString()}" ||
    //           PdfDocument(
    //                       inputBytes: File(pdfFilePath).readAsBytesSync(),
    //                       password:
    //                           "${textEditingControllerOwnerPassword.text.toString()}")
    //                   .security
    //                   .userPassword ==
    //               null) &&
    //       PdfDocument(
    //                   inputBytes: File(pdfFilePath).readAsBytesSync(),
    //                   password:
    //                       "${textEditingControllerOwnerPassword.text.toString()}")
    //               .security
    //               .ownerPassword ==
    //           "${textEditingControllerOwnerPassword.text.toString()}") {
    //     documentType = 'Secured With Both';
    //   }
    //
    //   return documentType;
    // } //only works if we know the passwords

    try {
      //Load the encrypted PDF document.
      document = PdfDocument(
          inputBytes: File(pdfFilePath).readAsBytesSync(),
          password: textEditingControllerUserPassword.text.toString());
      debugPrint('user password worked');
      //Change the user password as empty string
      document.security.userPassword = '';

      try {
        document.security.ownerPassword = '';
        //Clear the security permissions.
        document.security.permissions.clear();
      } catch (exception) {
        debugPrint('user password failed to unlock owner password');
        debugPrint(exception.toString());
      }
    } catch (exception) {
      if (exception.toString().contains('Cannot open an encrypted document.')) {
        document = 'userPasswordFailed';
      }
      try {
        //Load the encrypted PDF document.
        document = PdfDocument(
            inputBytes: File(pdfFilePath).readAsBytesSync(),
            password: textEditingControllerOwnerPassword.text.toString());

        debugPrint('owner password worked');
        //Change the user password as empty string
        document.security.ownerPassword = '';

        try {
          document.security.userPassword = '';
          //Clear the security permissions.
          document.security.permissions.clear();
        } catch (exception) {
          debugPrint('owner password failed to unlock user password');
          debugPrint(exception.toString());
        }
      } catch (exception) {
        if (exception
            .toString()
            .contains('Cannot open an encrypted document.')) {
          document = 'BothPasswordFailed';
        }
      }
    }
  }
  debugPrint(document);
  // if (!isEncryptedDocument()) {
  //   //Disable incremental update by set value as false. This helps decrease the size of pdf on page removal as it rewrites the whole document instead of updating the old one
  //   //document!.fileStructure.incrementalUpdate = false;
  //
  //   // document.compressionLevel = PdfCompressionLevel.best;
  //
  //   // generating extensionOfFileName and fileNameWithoutExtension
  //   String extensionOfFileName =
  //       extensionOfString(fileName: pdfChangesDataMap['PDF File Name']);
  //   String fileNameWithoutExtension = stringWithoutExtension(
  //       fileName: pdfChangesDataMap['PDF File Name'],
  //       extensionOfString: extensionOfFileName);
  //
  //   TextEditingController textEditingControllerOwnerPassword =
  //       pdfChangesDataMap['Owner Password TextEditingController'];
  //   TextEditingController textEditingControllerUserPassword =
  //       pdfChangesDataMap['User Password TextEditingController'];
  //
  //   Future<String> securePdf() async {
  //     String tempEncryptedPDFFilePath;
  //     //Load the existing PDF document.
  //     //Get the document security and set user and owner password.
  //     PdfSecurity security = document!.security;
  //     security.userPassword =
  //         '${textEditingControllerUserPassword.text.toString()}';
  //     if (textEditingControllerOwnerPassword.text.isNotEmpty) {
  //       print('ownerPassword set');
  //       security.ownerPassword =
  //           '${textEditingControllerOwnerPassword.text.toString()}';
  //     }
  //     //Set the encryption algorithm and permissions.
  //     document!.security.algorithm = PdfEncryptionAlgorithm.aesx128Bit;
  //     // document!.security.permissions
  //     //     .addAll([PdfPermissionsFlags.print, PdfPermissionsFlags.copyContent]);
  //
  //     //Save the document temporarily.
  //     String newFileName =
  //         "${fileNameWithoutExtension + ' ' + 'encrypted' + ' ' + extensionOfFileName}";
  //     Map map = Map();
  //     map['_pdfFileName'] = newFileName;
  //     map['_extraBetweenNameAndExtension'] = '';
  //     map['_document'] = document;
  //     tempEncryptedPDFFilePath = await creatingAndSavingPDFFileTemporarily(map);
  //     return tempEncryptedPDFFilePath;
  //   }
  //
  //   //passing final document to document variable
  //   document = PdfDocument(
  //       inputBytes: File(await securePdf()).readAsBytesSync(),
  //       password: '${textEditingControllerUserPassword.text.toString()}');
  //
  //   //removing unnecessary documents from getExternalStorageDirectory
  //   deletingTempPDFFiles(
  //       "${fileNameWithoutExtension + ' ' + 'encrypted' + ' ' + extensionOfFileName}");
  // } else {
  //   document = null;
  // }

  //return Future.delayed(const Duration(milliseconds: 500), () {
  return document;
  // });
}
