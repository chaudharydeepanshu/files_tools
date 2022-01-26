import 'package:files_tools/main_functions/Compress/compress_pdf.dart';
import 'package:files_tools/main_functions/Compress_images/compress_images.dart';
import 'package:files_tools/main_functions/Protect/decrypt_pdf.dart';
import 'package:files_tools/main_functions/Protect/encrypt_pdf.dart';
import 'package:files_tools/main_functions/convertPDF/pdf_to_images.dart';
import 'package:files_tools/main_functions/imagesToPdf/images_to_pdf.dart';
import 'package:files_tools/main_functions/merge/merge_pdf_pages_as_single_document.dart';
import 'package:files_tools/main_functions/modify_image/modify_image.dart';
import 'package:files_tools/main_functions/modify_pdf/modifying_pdf.dart';
import 'package:files_tools/main_functions/split/customRanges/custom_range_pdf_pages_as_separate_document.dart';
import 'package:files_tools/main_functions/split/customRanges/custom_range_pdf_pages_as_single_document.dart';
import 'package:files_tools/main_functions/split/extractAllPages/extract_all_pages.dart';
import 'package:files_tools/main_functions/split/extractSelectedPages/extract_selected_pages.dart';
import 'package:files_tools/main_functions/split/fixedRange/fixed_range_pdf_pages.dart';
import 'package:files_tools/main_functions/watermarkPdf/watermark_pdf_pages.dart';
import 'package:flutter/cupertino.dart';

Future<dynamic> processSelectedDataFromUser(
    {List<bool>? selectedData, //for selection type processes
    Map<String, dynamic>? pdfChangesDataMap, //for complex type processes
    required String processType,
    String? filePath,
    List<String>? filesPaths,
    required bool shouldDataBeProcessed}) async {
  debugPrint('processSelectedDataFromUser called');
  dynamic dataFromFunctions;
  if (processType == 'Modify PDF Data') {
    dataFromFunctions = await modifyingPDFPagesUsingModifiedPDFDataMap(
        filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for modifyingPDFPagesUsingModifiedPDFDataMap');
    return dataFromFunctions;
  } else if (processType == 'Extract Selected PDF Pages') {
    dataFromFunctions = await extractSelectedPages(
        filePath!, selectedData!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for extractSelectedPages');
    return dataFromFunctions;
  } else if (processType ==
      'Extract Custom Range PDF Pages As Single Document') {
    dataFromFunctions = await customRangePDFPagesAsSingleDocument(
        filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for customRangePDFPagesAsSingleDocument');
    return dataFromFunctions;
  } else if (processType ==
      'Extract Custom Range PDF Pages As Separate Documents') {
    dataFromFunctions = await customRangePDFPagesAsSeparateDocument(
        filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for customRangePDFPagesAsSeparateDocument');
    return dataFromFunctions;
  } else if (processType == 'Extract Fixed Range PDF Pages') {
    dataFromFunctions = await fixedRangePDFPages(
        filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for fixedRangePDFPages');
    return dataFromFunctions;
  } else if (processType == 'Extract All PDF Pages') {
    dataFromFunctions = await extractAllPDFPages(
        filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for extractAllPDFPages');
    return dataFromFunctions;
  } else if (processType == 'Merge Selected PDFs') {
    dataFromFunctions = await mergePDFPagesAsSingleDocument(
        filesPaths!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for mergePDFPagesAsSingleDocument');
    return dataFromFunctions;
  } else if (processType == 'Compress PDF Data') {
    dataFromFunctions =
        await compressPDF(filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for compressPDF');
    return dataFromFunctions;
  } else if (processType == 'Encrypt PDF') {
    dataFromFunctions =
        await encryptPDF(filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for encryptPDF');
    return dataFromFunctions;
  } else if (processType == 'Decrypt PDF') {
    dataFromFunctions =
        await decryptPDF(filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for decryptPDF');
    return dataFromFunctions;
  } else if (processType == 'Images To PDF') {
    dataFromFunctions = await imagesToPdf(
        filesPaths!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for imagesToPdf');
    return dataFromFunctions;
  } else if (processType == 'PDF TO Images') {
    dataFromFunctions =
        await pdfToImages(filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for pdfToImages');
    return dataFromFunctions;
  } else if (processType == 'Modify Image') {
    dataFromFunctions =
        await modifyImage(filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for modifyImage');
    return dataFromFunctions;
  } else if (processType == 'Compress Images') {
    dataFromFunctions = await compressImages(
        filesPaths!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for compressImages');
    return dataFromFunctions;
  } else if (processType == 'Watermark PDF') {
    dataFromFunctions = await watermarkPDFPages(
        filePath!, pdfChangesDataMap!, shouldDataBeProcessed);
    debugPrint('waiting for watermarkPDFPages');
    return dataFromFunctions;
  } else {
    debugPrint(
        'Unidentified Process Type! Please provide process type to processSelectedDataFromUser');
    return null;
  }
}
