import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

Future<PdfDocument?> removingPDFPagesUsingSelectedImagesList(String pdfFilePath,
    List pdfPagesSelectedImages, bool shouldDataBeProcessed) async {
  late PdfDocument? document;
  List<PdfPage> selectedPages = [];

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

  //isEncryptedDocument();
  if (!isEncryptedDocument()) {
    //Disable incremental update by set value as false. This helps decrease the size of pdf on page removal as it rewrites the whole document instead of updating the old one
    document!.fileStructure.incrementalUpdate = false;

    // document.compressionLevel = PdfCompressionLevel.best;

    for (var i = 0;
        i < pdfPagesSelectedImages.length && shouldDataBeProcessed == true;
        i++) {
      if (pdfPagesSelectedImages[i] == true) {
        PdfPage page = document!.pages[i];
        selectedPages.add(page);
      }
    }

    for (var i = 0;
        i < selectedPages.length && shouldDataBeProcessed == true;
        i++) {
      document!.pages.remove(selectedPages[i]);
    }

    // PdfDocument newDocument = PdfDocument();
    // Future<PdfDocument> creatingNewPdfDocumentFromOld() async {
    //   List<PdfPage> pageList = [];
    //   List<PdfTemplate> pageTemplateList = [];
    //   //Get pages from existing document.
    //   for (var i = 0;
    //       i < document!.pages.count && shouldDataBeProcessed == true;
    //       i++) {
    //     pageList.add(document!.pages[i]);
    //
    //     //Create the page as template and then add it to template list
    //     pageTemplateList.add(document!.pages[i].createTemplate());
    //   }
    //
    //   //Set page size and add page.
    //
    //   for (var i = 0;
    //       i < document!.pages.count && shouldDataBeProcessed == true;
    //       i++) {
    //     // pages of different size
    //     PdfSection section1 = newDocument.sections!.add();
    //
    //     //changing section orientation if page height is less than width
    //     if (pageList[i].size.height < pageList[i].size.width) {
    //       section1.pageSettings.orientation = PdfPageOrientation.landscape;
    //     } else {
    //       section1.pageSettings.orientation = PdfPageOrientation.portrait;
    //     }
    //
    //     section1.pageSettings.size = pageList[i].size;
    //
    //     section1.pageSettings.margins.all = 0;
    //     PdfPage newPage = section1.pages.add();
    //
    //     // newDocument.pageSettings.size = pageList[i].size;
    //     // newDocument.pageSettings.margins.all = 0;
    //     // PdfPage newPage = newDocument.pages.add();
    //
    //     //Draw the template to the new document page.
    //     newPage.graphics.drawPdfTemplate(pageTemplateList[i], Offset(0, 0));
    //   }
    //
    //   return newDocument;
    // }
    //
    // document = await creatingNewPdfDocumentFromOld();
    //
    // //Dispose documents.
    // //newDocument.dispose(); // calling it disables document view and save maybe it is also disposing or somehow connected with document

  } else {
    document = null;
  }

  //return Future.delayed(const Duration(milliseconds: 500), () {
  return document;
  // });
}
