import 'dart:developer';

import 'package:files_tools/models/pdf_page_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf_bitmaps/pdf_bitmaps.dart';

Future<PdfPageModel> getUpdatedPdfPage({
  required int index,
  required String? pdfUri,
  required String? pdfPath,
  int? quality,
}) async {
  Uint8List? bytes = await PdfBitmaps().pdfBitmap(
      params: PDFBitmapParams(
          pdfUri: pdfUri,
          pdfPath: pdfPath,
          pageIndex: index,
          quality: quality ?? 25));
  PdfPageModel updatedPdfPage;
  if (bytes != null) {
    updatedPdfPage = PdfPageModel(
        pageIndex: index,
        pageBytes: bytes,
        pageErrorStatus: false,
        pageSelected: false,
        pageRotationAngle: 0,
        pageHidden: false);
  } else {
    updatedPdfPage = PdfPageModel(
        pageIndex: index,
        pageBytes: null,
        pageErrorStatus: true,
        pageSelected: false,
        pageRotationAngle: 0,
        pageHidden: false);
  }
  return updatedPdfPage;
}

Future<int?> generatePdfPageCount(
    {required String? pdfUri, required String? pdfPath}) async {
  int? pdfPageCount;
  try {
    pdfPageCount = await PdfBitmaps().pdfPageCount(
        params: PDFPageCountParams(pdfUri: pdfUri, pdfPath: pdfPath));
  } on PlatformException catch (e) {
    log(e.toString());
  } catch (e) {
    log(e.toString());
  }
  return pdfPageCount;
}

Future<List<PdfPageModel>> generatePdfPagesList(
    {required String? pdfUri, required String? pdfPath, int? pageCount}) async {
  List<PdfPageModel> pdfPages = [];
  int? pdfPageCount;

  pdfPageCount =
      pageCount ?? await generatePdfPageCount(pdfUri: pdfUri, pdfPath: pdfPath);
  if (pdfPageCount != null) {
    pdfPages = List<PdfPageModel>.generate(
        pdfPageCount,
        (int index) => PdfPageModel(
            pageIndex: index,
            pageBytes: null,
            pageErrorStatus: false,
            pageSelected: false,
            pageRotationAngle: 0,
            pageHidden: false));
  }

  return pdfPages;
}
