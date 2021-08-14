import 'package:flutter/services.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingPDFRendererImageFileTemporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as pdfRenderer;

Future<List<String>?> pdfToImages(String pdfFilePath,
    Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
  List<String>? rangesPdfsFilePaths = [];
  List<pdfRenderer.PdfPageImage?> pdfPagesImages = [];
  List<String> filesPaths = [];

  bool isEncryptedDocument() {
    bool isEncrypted = false;
    try {
      //Load the encrypted PDF document.
      //document = PdfDocument(inputBytes: File(pdfFilePath).readAsBytesSync());
      PdfDocument(inputBytes: File(pdfFilePath).readAsBytesSync());
    } catch (exception) {
      if (exception.toString().contains('Cannot open an encrypted document.')) {
        isEncrypted = true;
      }
    }
    return isEncrypted;
  }

  if (!isEncryptedDocument()) {
    // generating extensionOfFileName and fileNameWithoutExtension
    String extensionOfFileName =
        extensionOfString(fileName: pdfChangesDataMap['PDF File Name']);
    String fileNameWithoutExtension = stringWithoutExtension(
        fileName: pdfChangesDataMap['PDF File Name'],
        extensionOfString: extensionOfFileName);

    //creating and saving pdf as single page documents
    try {
      final newDocument = await pdfRenderer.PdfDocument.openFile(pdfFilePath);
      final pagesCount = newDocument.pagesCount;

      pdfPagesImages = [];

      for (var i = 1; i <= pagesCount && shouldDataBeProcessed == true; i++) {
        //Text('Item $i');
        pdfRenderer.PdfPage page =
            await newDocument.getPage(i); //always start from 1
        //pages.add(page);

        print('height: ' +
            page.height.toString() +
            ' width: ' +
            page.width.toString());

        int pageHeight = ((page.height) / 1).round();
        int pageWidth = ((page.width) / 1).round();

        pdfRenderer.PdfPageImage? pageImage = await page.render(
          width: pageWidth,
          height: pageHeight,
          format: pdfRenderer.PdfPageFormat.JPEG,
        );

        pdfPagesImages.add(pageImage);
        await page.close();
        print(i);
      }

      newDocument.close();
    } on PlatformException catch (error) {
      print(error);
    }

    //save the images temporarily
    for (int i = 0; i < pdfPagesImages.length; i++) {
      String newFileName =
          "${fileNameWithoutExtension + ' ' + i.toString() + '.jpg'}";
      Map map = Map();
      map['_pdfPageImageName'] = newFileName;
      map['_extraBetweenNameAndExtension'] = '';
      map['_pdfPageImage'] = pdfPagesImages[i];
      filesPaths
          .add(await creatingAndSavingPDFRendererImageFileTemporarily(map));
    }

    rangesPdfsFilePaths = List.from(filesPaths);
  } else {
    rangesPdfsFilePaths = null;
  }

  //return Future.delayed(const Duration(milliseconds: 500), () {
  return rangesPdfsFilePaths;
  // });
}
