import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

bool checkEncryptedDocument(String filePath) {
  bool isEncrypted = false;
  try {
    //Load the encrypted PDF document.
    PdfDocument(inputBytes: File(filePath).readAsBytesSync());
  } catch (exception) {
    if (exception.toString().contains('Cannot open an encrypted document.')) {
      isEncrypted = true;
    }
  }
  return isEncrypted;
}
