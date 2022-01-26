import 'package:files_tools/basicFunctionalityFunctions/hex_to_decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

Future<PdfDocument?> watermarkPDFPages(String pdfFilePath,
    Map<String, dynamic> pdfChangesDataMap, bool shouldDataBeProcessed) async {
  late PdfDocument? document;

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
    //Converting hex color to RGB
    var hexColor = pdfChangesDataMap['Color Of Watermark'].substring(4);
    var red = hexToDecimal(hexColor[0].toString() + hexColor[1].toString())!;
    debugPrint(red.toString());
    var green = hexToDecimal(hexColor[2].toString() + hexColor[3].toString())!;
    debugPrint(green.toString());
    var blue = hexToDecimal(hexColor[4].toString() + hexColor[5].toString())!;
    debugPrint(blue.toString());
    //for over the pdf content

    if (pdfChangesDataMap['Watermark Rotation Angle'] == 0) {
      if (pdfChangesDataMap['List Of Watermark Layer Buttons Status'][0] ==
          true) {
        for (int i = 0; i < document!.pages.count; i++) {
          //Get pages from document
          PdfPage page = document!.pages[i];
          //Get page size
          final Size pageSize = page.getClientSize();
          //Set a standard font
          PdfFont font = PdfStandardFont(PdfFontFamily.helvetica,
              pdfChangesDataMap['FontSize TextEditingController']);
          //Create PDF graphics for the page
          PdfGraphics graphics = page.graphics;
          //Save the graphics state for the watermark text
          graphics.save();
          // //Translate the page graphics to be in center.
          // graphics.translateTransform(
          //     page.getClientSize().width / 2, page.getClientSize().height / 2);
          //Measure the text
          Size size = font.measureString(
              pdfChangesDataMap['Watermark TextEditingController']);
          //Calculate the center point
          double x = pageSize.width / 2;
          double y = pageSize.height / 2;
          //Set transparency level for the text
          graphics.setTransparency(pdfChangesDataMap['Watermark Transparency']);
          // //Rotate the text to x Degree
          // graphics.rotateTransform(pdfChangesDataMap['Watermark Rotation Angle']);
          //get bounds according to position
          Rect? bounds;
          if (pdfChangesDataMap['List Of Positions Status'][0] == true) {
            bounds = Rect.fromLTWH(0, 0, size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][1] == true) {
            bounds =
                Rect.fromLTWH(x - size.width / 2, 0, size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][2] == true) {
            bounds =
                Rect.fromLTWH(2 * x - size.width, 0, size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][3] == true) {
            bounds = Rect.fromLTWH(0, y, size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][4] == true) {
            bounds =
                Rect.fromLTWH(x - size.width / 2, y, size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][5] == true) {
            bounds =
                Rect.fromLTWH(2 * x - size.width, y, size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][6] == true) {
            bounds =
                Rect.fromLTWH(0, y + y - size.height, size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][7] == true) {
            bounds = Rect.fromLTWH(x - size.width / 2, y + y - size.height,
                size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][8] == true) {
            bounds = Rect.fromLTWH(2 * x - size.width, y + y - size.height,
                size.width, size.height);
          }
          //Draw the watermark text to the desired position over the PDF page with red color
          graphics.drawString(
            pdfChangesDataMap['Watermark TextEditingController'], font,
            pen: PdfPen(PdfColor(red, green, blue)),
            brush: PdfSolidBrush(PdfColor(red, green, blue)),
            // brush: PdfBrushes.red,
            bounds: bounds,
          );
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
          debugPrint("pageRealRotationAngle : $rotationAngle");

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

          PdfPageRotateAngle pdfPageRotateAngle =
              PdfPageRotateAngle.rotateAngle0;
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
          debugPrint(
              "page.size.height: ${page.size.height}, page.size.width: ${page.size.width}");
          //Changing section orientation according to page height & width
          if (page.size.height < page.size.width) {
            newDocument.pageSettings.orientation = PdfPageOrientation.landscape;
            debugPrint('Page is landscape');
          } else {
            newDocument.pageSettings.orientation = PdfPageOrientation.portrait;
            debugPrint('Page is portrait');
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
          PdfFont font = PdfStandardFont(PdfFontFamily.helvetica,
              pdfChangesDataMap['FontSize TextEditingController']);
          //Create PDF graphics for the page
          PdfGraphics graphics = newPage.graphics;
          //Save the graphics state for the watermark text
          graphics.save();
          // //Translate the page graphics to be in center.
          // graphics.translateTransform(
          //     page.getClientSize().width / 2, page.getClientSize().height / 2);
          //Measure the text
          Size size = font.measureString(
              pdfChangesDataMap['Watermark TextEditingController']);
          //calculate the x and y points
          double x = pageSize.width / 2;
          double y = pageSize.height / 2;
          //Set transparency level for the text
          graphics.setTransparency(pdfChangesDataMap['Watermark Transparency']);
          // //Rotate the text to x Degree
          // graphics.rotateTransform(pdfChangesDataMap['Watermark Rotation Angle']);
          //get bounds according to position
          Rect? bounds;
          if (pdfChangesDataMap['List Of Positions Status'][0] == true) {
            bounds = Rect.fromLTWH(0, 0, size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][1] == true) {
            bounds =
                Rect.fromLTWH(x - size.width / 2, 0, size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][2] == true) {
            bounds =
                Rect.fromLTWH(2 * x - size.width, 0, size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][3] == true) {
            bounds = Rect.fromLTWH(0, y, size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][4] == true) {
            bounds =
                Rect.fromLTWH(x - size.width / 2, y, size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][5] == true) {
            bounds =
                Rect.fromLTWH(2 * x - size.width, y, size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][6] == true) {
            bounds =
                Rect.fromLTWH(0, y + y - size.height, size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][7] == true) {
            bounds = Rect.fromLTWH(x - size.width / 2, y + y - size.height,
                size.width, size.height);
          } else if (pdfChangesDataMap['List Of Positions Status'][8] == true) {
            bounds = Rect.fromLTWH(2 * x - size.width, y + y - size.height,
                size.width, size.height);
          }
          //Draw the watermark text to the desired position over the PDF page with red color
          graphics.drawString(
            pdfChangesDataMap['Watermark TextEditingController'], font,
            pen: PdfPen(PdfColor(red, green, blue)),
            brush: PdfSolidBrush(PdfColor(red, green, blue)),
            // brush: PdfBrushes.red,
            bounds: bounds,
          );
          //Restore the graphics
          graphics.restore();
          //--------------------adding watermark -------------------------------//

          //Draw the template to the new document page.
          newPage.graphics.drawPdfTemplate(template, const Offset(0, 0));
        }
        document = newDocument;
      }
    } else {
      if (pdfChangesDataMap['List Of Watermark Layer Buttons Status'][0] ==
          true) {
        for (int i = 0; i < document!.pages.count; i++) {
          //Get pages from document
          PdfPage page = document!.pages[i];
          //Get page size
          final Size pageSize = page.getClientSize();
          //Set a standard font
          PdfFont font = PdfStandardFont(PdfFontFamily.helvetica,
              pdfChangesDataMap['FontSize TextEditingController']);
          //Create PDF graphics for the page
          PdfGraphics graphics = page.graphics;
          //Measure the text
          Size size = font.measureString(
              pdfChangesDataMap['Watermark TextEditingController']);
          //Calculate the center point
          double x = pageSize.width / 2;
          double y = pageSize.height / 2;
          //Save the graphics state for the watermark text
          graphics.save();
          if (pdfChangesDataMap['List Of Positions Status'][0] == true) {
            //Translate the page graphics to be in top left.
            graphics.translateTransform(
                x - x + size.width / 2, y - y + size.width / 2);
          } else if (pdfChangesDataMap['List Of Positions Status'][1] == true) {
            //Translate the page graphics to be in top center.
            graphics.translateTransform(x, y - y + size.width / 2);
          } else if (pdfChangesDataMap['List Of Positions Status'][2] == true) {
            //Translate the page graphics to be in top right.
            graphics.translateTransform(
                x + x - size.width / 2, y - y + size.width / 2);
          } else if (pdfChangesDataMap['List Of Positions Status'][3] == true) {
            //Translate the page graphics to be in left to center.
            graphics.translateTransform(x - x + size.width / 2, y);
          } else if (pdfChangesDataMap['List Of Positions Status'][4] == true) {
            //Translate the page graphics to be in center.
            graphics.translateTransform(x, y);
          } else if (pdfChangesDataMap['List Of Positions Status'][5] == true) {
            //Translate the page graphics to be in right to center.
            graphics.translateTransform(x + x - size.width / 2, y);
          } else if (pdfChangesDataMap['List Of Positions Status'][6] == true) {
            //Translate the page graphics to be in bottom left.
            graphics.translateTransform(
                x - x + size.width / 2, y + y - size.width / 2);
          } else if (pdfChangesDataMap['List Of Positions Status'][7] == true) {
            //Translate the page graphics to be in bottom center.
            graphics.translateTransform(x, y + y - size.width / 2);
          } else if (pdfChangesDataMap['List Of Positions Status'][8] == true) {
            //Translate the page graphics to be in bottom right.
            graphics.translateTransform(
                x + x - size.width / 2, y + y - size.width / 2);
          }
          //Set transparency level for the text
          graphics.setTransparency(pdfChangesDataMap['Watermark Transparency']);
          //Rotate the text to x Degree
          graphics
              .rotateTransform(pdfChangesDataMap['Watermark Rotation Angle']);
          //set bounds
          Rect? bounds = Rect.fromLTWH(
              -size.width / 2, -size.height / 2, size.width, size.height);
          //Draw the watermark text to the desired position over the PDF page with red color
          graphics.drawString(
            pdfChangesDataMap['Watermark TextEditingController'], font,
            pen: PdfPen(PdfColor(red, green, blue)),
            brush: PdfSolidBrush(PdfColor(red, green, blue)),
            // brush: PdfBrushes.red,
            bounds: bounds,
          );
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
          debugPrint("pageRealRotationAngle : $rotationAngle");

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

          PdfPageRotateAngle pdfPageRotateAngle =
              PdfPageRotateAngle.rotateAngle0;
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
          debugPrint(
              "page.size.height: ${page.size.height}, page.size.width: ${page.size.width}");
          //Changing section orientation according to page height & width
          if (page.size.height < page.size.width) {
            newDocument.pageSettings.orientation = PdfPageOrientation.landscape;
            debugPrint('Page is landscape');
          } else {
            newDocument.pageSettings.orientation = PdfPageOrientation.portrait;
            debugPrint('Page is portrait');
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
          PdfFont font = PdfStandardFont(PdfFontFamily.helvetica,
              pdfChangesDataMap['FontSize TextEditingController']);
          //Create PDF graphics for the page
          PdfGraphics graphics = newPage.graphics;
          //Measure the text
          Size size = font.measureString(
              pdfChangesDataMap['Watermark TextEditingController']);
          //Calculate the center point
          double x = pageSize.width / 2;
          double y = pageSize.height / 2;
          //Save the graphics state for the watermark text
          graphics.save();
          if (pdfChangesDataMap['List Of Positions Status'][0] == true) {
            //Translate the page graphics to be in top left.
            graphics.translateTransform(
                x - x + size.width / 2, y - y + size.width / 2);
          } else if (pdfChangesDataMap['List Of Positions Status'][1] == true) {
            //Translate the page graphics to be in top center.
            graphics.translateTransform(x, y - y + size.width / 2);
          } else if (pdfChangesDataMap['List Of Positions Status'][2] == true) {
            //Translate the page graphics to be in top right.
            graphics.translateTransform(
                x + x - size.width / 2, y - y + size.width / 2);
          } else if (pdfChangesDataMap['List Of Positions Status'][3] == true) {
            //Translate the page graphics to be in left to center.
            graphics.translateTransform(x - x + size.width / 2, y);
          } else if (pdfChangesDataMap['List Of Positions Status'][4] == true) {
            //Translate the page graphics to be in center.
            graphics.translateTransform(x, y);
          } else if (pdfChangesDataMap['List Of Positions Status'][5] == true) {
            //Translate the page graphics to be in right to center.
            graphics.translateTransform(x + x - size.width / 2, y);
          } else if (pdfChangesDataMap['List Of Positions Status'][6] == true) {
            //Translate the page graphics to be in bottom left.
            graphics.translateTransform(
                x - x + size.width / 2, y + y - size.width / 2);
          } else if (pdfChangesDataMap['List Of Positions Status'][7] == true) {
            //Translate the page graphics to be in bottom center.
            graphics.translateTransform(x, y + y - size.width / 2);
          } else if (pdfChangesDataMap['List Of Positions Status'][8] == true) {
            //Translate the page graphics to be in bottom right.
            graphics.translateTransform(
                x + x - size.width / 2, y + y - size.width / 2);
          }
          //Set transparency level for the text
          graphics.setTransparency(pdfChangesDataMap['Watermark Transparency']);
          //Rotate the text to x Degree
          graphics
              .rotateTransform(pdfChangesDataMap['Watermark Rotation Angle']);
          //set bounds
          Rect? bounds = Rect.fromLTWH(
              -size.width / 2, -size.height / 2, size.width, size.height);
          //Draw the watermark text to the desired position over the PDF page with red color
          graphics.drawString(
            pdfChangesDataMap['Watermark TextEditingController'], font,
            pen: PdfPen(PdfColor(red, green, blue)),
            brush: PdfSolidBrush(PdfColor(red, green, blue)),
            // brush: PdfBrushes.red,
            bounds: bounds,
          );
          //Restore the graphics
          graphics.restore();
          //--------------------adding watermark -------------------------------//

          //Draw the template to the new document page.
          newPage.graphics.drawPdfTemplate(template, const Offset(0, 0));
        }
        document = newDocument;
      }
    }
  } else {
    document = null;
  }

  //return Future.delayed(const Duration(milliseconds: 500), () {
  return document;
  // });
}
