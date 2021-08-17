import 'dart:ui';

import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/basicFunctionalityFunctions/getExternalStorageFilePathFromFileName.dart';
import 'package:files_tools/basicFunctionalityFunctions/hexToDecimal.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import 'package:flutter_pdf_split/flutter_pdf_split.dart';

Future<PdfDocument?> watermarkPDFPages(String pdfFilePath,
    Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
  late PdfDocument? document;
  List<String>? rangesPdfsFilePaths = [];

  bool isEncryptedDocument() {
    bool isEncrypted = false;
    try {
      //Load the encrypted PDF document.
      document = PdfDocument(inputBytes: File(pdfFilePath).readAsBytesSync());
      //PdfDocument(inputBytes: File(pdfFilePath).readAsBytesSync());
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
    //Converting hex color to RGB
    var hexColor = pdfChangesDataMap['Color Of Watermark'].substring(4);
    var red = hexToDecimal(hexColor[0].toString() + hexColor[1].toString())!;
    print(red);
    var green = hexToDecimal(hexColor[2].toString() + hexColor[3].toString())!;
    print(green);
    var blue = hexToDecimal(hexColor[4].toString() + hexColor[5].toString())!;
    print(blue);
    //for over the pdf content
    if (pdfChangesDataMap['List Of Watermark Layer Buttons Status'][0] ==
        true) {
      for (int i = 0; i < document!.pages.count; i++) {
        //Get pages from document
        PdfPage page = document!.pages[i];
        //Get page size
        final Size pageSize = page.getClientSize();
        //Set a standard font
        PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 40);
        //Measure the text
        Size size = font.measureString(
            pdfChangesDataMap['Watermark TextEditingController']);
        //Create PDF graphics for the page
        PdfGraphics graphics = page.graphics;
        double x = pageSize.width / 2 - size.width / 2;
        double y = pageSize.height / 2;
        //Save the graphics state for the watermark text
        graphics.save();
        //Set transparency level for the text
        graphics.setTransparency(pdfChangesDataMap['Watermark Transparency']);
        //Rotate the text to x Degree
        graphics.rotateTransform(pdfChangesDataMap['Watermark Rotation Angle']);
        //Draw the watermark text to the desired position over the PDF page with red color
        graphics.drawString(
            pdfChangesDataMap['Watermark TextEditingController'],
            PdfStandardFont(PdfFontFamily.helvetica,
                pdfChangesDataMap['FontSize TextEditingController']),
            pen: PdfPen(PdfColor(red, green, blue)),
            brush: PdfSolidBrush(PdfColor(red, green, blue)),
            // brush: PdfBrushes.red,
            bounds: Rect.fromLTWH(x, y, size.width, size.height));
        //Restore the graphics
        graphics.restore();
      }
    } else {
      //Create new second document.
      PdfDocument newDocument = PdfDocument();
      for (int i = 0; i < document!.pages.count; i++) {
        //Get pages from document
        PdfPage page = document!.pages[i];

        //Get page rotation applied
        PdfPageRotateAngle rotationAngle = page.rotation;
        print("pageRealRotationAngle : $rotationAngle");

        int realAngle = 0;
        if (rotationAngle == PdfPageRotateAngle.rotateAngle0) {
          realAngle = 0;
        } else if (rotationAngle == PdfPageRotateAngle.rotateAngle90) {
          realAngle = 90;
        } else if (rotationAngle == PdfPageRotateAngle.rotateAngle180) {
          realAngle = 180;
        } else if (rotationAngle == PdfPageRotateAngle.rotateAngle270) {
          realAngle = 270;
        }

        PdfPageRotateAngle pdfPageRotateAngle = PdfPageRotateAngle.rotateAngle0;
        if (realAngle == 0 || realAngle == 360) {
          pdfPageRotateAngle = PdfPageRotateAngle.rotateAngle0;
        } else if (realAngle == 90) {
          pdfPageRotateAngle = PdfPageRotateAngle.rotateAngle90;
        } else if (realAngle == 180) {
          pdfPageRotateAngle = PdfPageRotateAngle.rotateAngle180;
        } else if (realAngle == 270) {
          pdfPageRotateAngle = PdfPageRotateAngle.rotateAngle270;
        }

        //Create the page as template.
        PdfTemplate template = page.createTemplate();
        print(
            "page.size.height: ${page.size.height}, page.size.width: ${page.size.width}");
        //Changing section orientation according to page height & width
        if (page.size.height < page.size.width) {
          newDocument.pageSettings.orientation = PdfPageOrientation.landscape;
          print('Page is landscape');
        } else {
          newDocument.pageSettings.orientation = PdfPageOrientation.portrait;
          print('Page is portrait');
        }
        //Set page size and add page.
        newDocument.pageSettings.size = page.size;

        //set document rotation
        newDocument.pageSettings.rotate = pdfPageRotateAngle;

        newDocument.pageSettings.margins.all = 0;
        PdfPage newPage = newDocument.pages.add();

        //--------------------adding watermark -------------------------------//
        //Get page size
        final Size pageSize = page.getClientSize();
        //Set a standard font
        PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 40);
        //Measure the text
        Size size = font.measureString(
            pdfChangesDataMap['Watermark TextEditingController']);
        //Create PDF graphics for the page
        PdfGraphics graphics = newPage.graphics;
        double x = pageSize.width / 2 - size.width / 2;
        double y = pageSize.height / 2;
        //Save the graphics state for the watermark text
        graphics.save();
        //Set transparency level for the text
        graphics.setTransparency(pdfChangesDataMap['Watermark Transparency']);
        //Rotate the text to x Degree
        graphics.rotateTransform(pdfChangesDataMap['Watermark Rotation Angle']);
        //Draw the watermark text to the desired position over the PDF page with red color
        graphics.drawString(
            pdfChangesDataMap['Watermark TextEditingController'],
            PdfStandardFont(PdfFontFamily.helvetica,
                pdfChangesDataMap['FontSize TextEditingController']),
            pen: PdfPen(PdfColor(red, green, blue)),
            brush: PdfSolidBrush(PdfColor(red, green, blue)),
            // brush: PdfBrushes.red,
            bounds: Rect.fromLTWH(x, y, size.width, size.height));
        //Restore the graphics
        graphics.restore();
        //--------------------adding watermark -------------------------------//

        //Draw the template to the new document page.
        newPage.graphics.drawPdfTemplate(template, Offset(0, 0));
      }
      document = newDocument;
    }
    // //creating and saving pdf as single page documents
    // String? path = await getExternalStorageDirectoryPath();
    // FlutterPdfSplitResult splitResult = await FlutterPdfSplit.split(
    //   FlutterPdfSplitArgs(pdfFilePath, path,
    //       outFilePrefix: "$fileNameWithoutExtension "),
    // );

    // rangesPdfsFilePaths = List.from(splitResult.pagePaths);

  } else {
    //rangesPdfsFilePaths = null;
  }

  //return Future.delayed(const Duration(milliseconds: 500), () {
  return document;
  // });
}
