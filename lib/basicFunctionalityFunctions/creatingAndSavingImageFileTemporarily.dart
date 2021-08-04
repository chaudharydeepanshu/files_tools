import 'dart:io';
import 'getExternalStorageFilePathFromFileName.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as pdfRenderer;

Future<String> creatingAndSavingImageFileTemporarily(map) async {
  String _pdfPageImageName = map['_pdfPageImageName'];
  pdfRenderer.PdfPageImage _pdfPageImage = map['_pdfPageImage'];
  String filePathFromFileName =
      await getExternalStorageFilePathFromFileName(_pdfPageImageName);

  Future<List<int>> creatingImageFile() async {
    pdfRenderer.PdfPageImage pdfPageImage = _pdfPageImage;
    List<int> bytes = pdfPageImage.bytes;
    return bytes;
  }

  Future<void> savingImageFile() async {
    File? imageFile = File(filePathFromFileName);
    List<int> bytes = await creatingImageFile();
    await imageFile.writeAsBytes(bytes, flush: true);
  }

  await savingImageFile();

  return filePathFromFileName;
}
