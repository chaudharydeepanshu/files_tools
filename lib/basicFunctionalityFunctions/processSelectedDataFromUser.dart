import 'package:files_tools/basic_pdf_functions/Compress/CompressPDF.dart';
import 'package:files_tools/basic_pdf_functions/Protect/DecryptPDF.dart';
import 'package:files_tools/basic_pdf_functions/Protect/EncryptPDF.dart';
import 'package:files_tools/basic_pdf_functions/convertPDF/PDFToImages.dart';
import 'package:files_tools/basic_pdf_functions/imagesToPdf/imagesToPdf.dart';
import 'package:files_tools/basic_pdf_functions/merge/mergePDFPagesAsSingleDocument.dart';
import 'package:files_tools/basic_pdf_functions/removingPDFPages.dart';
import 'package:files_tools/basic_pdf_functions/split/customRanges/customRangePDFPagesAsSeparateDocument.dart';
import 'package:files_tools/basic_pdf_functions/split/customRanges/customRangePDFPagesAsSingleDocument.dart';
import 'package:files_tools/basic_pdf_functions/split/extractAllPages/extractAllPages.dart';
import 'package:files_tools/basic_pdf_functions/split/extractSelectedPages/extractSelectedPages.dart';
import 'package:files_tools/basic_pdf_functions/split/fixedRange/fixedRangePDFPages.dart';
import '../basic_pdf_functions/modify/modifying_PDF.dart';

Future<dynamic> processSelectedDataFromUser(
    {List<bool>? selectedData, //for selection type processes
    Map<String, dynamic>? pdfChangesDataMap, //for complex type processes
    required String processType,
    String? filePath,
    List<String>? filesPaths,
    required bool shouldDataBeProcessed}) async {
  print('processSelectedDataFromUser called');
  dynamic dataFromFunctions;
  if (processType == 'Remove PDF Data') {
    dataFromFunctions = await removingPDFPagesUsingSelectedImagesList(
        filePath!, selectedData!, shouldDataBeProcessed);
    print('waiting for removingPDFPagesUsingSelectedImagesList');
    return dataFromFunctions;
  } else if (processType == 'Modify PDF Data') {
    dataFromFunctions = await modifyingPDFPagesUsingModifiedPDFDataMap(
        filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    print('waiting for modifyingPDFPagesUsingModifiedPDFDataMap');
    return dataFromFunctions;
  } else if (processType == 'Extract Selected PDF Pages') {
    dataFromFunctions = await extractSelectedPages(
        filePath!, selectedData!, pdfChangesDataMap!, shouldDataBeProcessed);
    print('waiting for extractSelectedPages');
    return dataFromFunctions;
  } else if (processType ==
      'Extract Custom Range PDF Pages As Single Document') {
    dataFromFunctions = await customRangePDFPagesAsSingleDocument(
        filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    print('waiting for customRangePDFPagesAsSingleDocument');
    return dataFromFunctions;
  } else if (processType ==
      'Extract Custom Range PDF Pages As Separate Documents') {
    dataFromFunctions = await customRangePDFPagesAsSeparateDocument(
        filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    print('waiting for customRangePDFPagesAsSeparateDocument');
    return dataFromFunctions;
  } else if (processType == 'Extract Fixed Range PDF Pages') {
    dataFromFunctions = await fixedRangePDFPages(
        filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    print('waiting for fixedRangePDFPages');
    return dataFromFunctions;
  } else if (processType == 'Extract All PDF Pages') {
    dataFromFunctions = await extractAllPDFPages(
        filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    print('waiting for extractAllPDFPages');
    return dataFromFunctions;
  } else if (processType == 'Merge Selected PDFs') {
    dataFromFunctions = await mergePDFPagesAsSingleDocument(
        filesPaths!, pdfChangesDataMap!, shouldDataBeProcessed);
    print('waiting for mergePDFPagesAsSingleDocument');
    return dataFromFunctions;
  } else if (processType == 'Compress PDF Data') {
    dataFromFunctions =
        await compressPDF(filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    print('waiting for compressPDF');
    return dataFromFunctions;
  } else if (processType == 'Encrypt PDF') {
    dataFromFunctions =
        await encryptPDF(filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    print('waiting for encryptPDF');
    return dataFromFunctions;
  } else if (processType == 'Decrypt PDF') {
    dataFromFunctions =
        await decryptPDF(filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    print('waiting for decryptPDF');
    return dataFromFunctions;
  } else if (processType == 'Images To PDF') {
    dataFromFunctions = await imagesToPdf(
        filesPaths!, pdfChangesDataMap!, shouldDataBeProcessed);
    print('waiting for imagesToPdf');
    return dataFromFunctions;
  } else if (processType == 'PDF TO Images') {
    dataFromFunctions =
        await pdfToImages(filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    print('waiting for pdfToImages');
    return dataFromFunctions;
  } else {
    print(
        'Unidentified Process Type! Please provide process type to processSelectedDataFromUser');
    return null;
  }
}
