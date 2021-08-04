import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'getExternalStorageFilePathFromFileName.dart';

Future<String> creatingAndSavingPDFFileTemporarily(map) async {
  String _pdfFileName = map['_pdfFileName'];
  PdfDocument _document = map['_document'];
  String filePathFromFileName =
      await getExternalStorageFilePathFromFileName(_pdfFileName);

  Future<List<int>> creatingPDFFile() async {
    PdfDocument document = _document;
    List<int> bytes = document.save();
    //document.dispose(); //if disposed would throw Unhandled Exception: Null check operator used on a null value
    return bytes;
  }

  Future<void> savingPDFFile() async {
    File? file = File(filePathFromFileName);
    List<int> bytes = await creatingPDFFile();
    await file.writeAsBytes(bytes, flush: true);
  }

  await savingPDFFile();

  return filePathFromFileName;
}
