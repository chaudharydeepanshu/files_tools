import 'dart:developer';

import 'package:files_tools/models/pdf_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_bitmaps/pdf_bitmaps.dart';

Future<Uint8List?> getPdfPageBitmap({
  required int index,
  required String pdfPath,
  double? scale,
  int? rotationAngle,
  Color? backgroundColor,
}) async {
  Uint8List? bytes = await PdfBitmaps().pdfBitmap(
      params: PDFBitmapParams(
          pdfPath: pdfPath,
          pageInfo: BitmapConfigForPage(
              pageNumber: index + 1,
              scale: scale ?? 1,
              rotationAngle: rotationAngle ?? 0,
              backgroundColor: backgroundColor ?? Colors.white)));
  return bytes;
}

Future<PdfPageModel> getUpdatedPdfPage({
  required int index,
  required String pdfPath,
  required PdfPageModel pdfPageModel,
  double? scale,
  int? rotationAngle,
  Color? backgroundColor,
}) async {
  Uint8List? bytes = await getPdfPageBitmap(
      index: index,
      pdfPath: pdfPath,
      scale: scale,
      rotationAngle: rotationAngle,
      backgroundColor: backgroundColor);

  PdfPageModel updatedPdfPage;
  if (bytes != null) {
    updatedPdfPage = PdfPageModel(
        pageIndex: pdfPageModel.pageIndex,
        pageBytes: bytes,
        pageErrorStatus: false,
        pageSelected: pdfPageModel.pageSelected,
        pageRotationAngle: pdfPageModel.pageRotationAngle,
        pageHidden: pdfPageModel.pageHidden);
  } else {
    updatedPdfPage = PdfPageModel(
        pageIndex: pdfPageModel.pageIndex,
        pageBytes: null,
        pageErrorStatus: true,
        pageSelected: pdfPageModel.pageSelected,
        pageRotationAngle: pdfPageModel.pageRotationAngle,
        pageHidden: pdfPageModel.pageHidden);
  }
  return updatedPdfPage;
}

Future<int?> getPdfPageCount({required String pdfPath}) async {
  int? pdfPageCount;
  try {
    pdfPageCount = await PdfBitmaps()
        .pdfPageCount(params: PDFPageCountParams(pdfPath: pdfPath));
  } on PlatformException catch (e) {
    log(e.toString());
  } catch (e) {
    log(e.toString());
  }
  return pdfPageCount;
}

Future<List<PdfPageModel>> generatePdfPagesList(
    {required String pdfPath, int? pageCount}) async {
  List<PdfPageModel> pdfPages = [];
  int? pdfPageCount;

  pdfPageCount = pageCount ?? await getPdfPageCount(pdfPath: pdfPath);
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
