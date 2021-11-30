import 'package:files_tools/ui/functionsActionsScaffold/ModifyImageScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/compressImage.dart';
import 'package:files_tools/ui/functionsActionsScaffold/watermarkPDF.dart';
import 'package:flutter/material.dart';
import 'package:files_tools/ui/functionsActionsScaffold/CompressPDFScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/DecryptPDFScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/EncryptPDFScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/ExtractAllPDFPagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/FixedRangePDFPagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/PDFToImagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/customRangePDFPagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/imagesToPDFScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/mergePDFPagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/pdfPagesModificationScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/pdfPagesSelectionScaffold.dart';
import '../navigation/page_routes_model.dart';

//For PDF
Map<String, dynamic>? mapOfMergeFunctionDetailsForPDFTools = {
  'Title': 'Merge PDF',
  'Subtitle': 'Easily merge pages from PDF file',
  'Icon Asset': 'assets/images/functions_icons/merge_icon.svg',
  'Icon And Text Color': Colors.red,
  'BG Color': Colors.red.shade100,
  'Select File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
  'Select File Icon Color': null,
  'Select File Button Color': Colors.lightBlue.shade50,
  'Select File Button Effects Color': Colors.lightBlue.withOpacity(0.1),
  'Select File Type': 'Select Multiple File',
  'Function Body Type': 'Multiple File Body',
  'Encrypted Files Allowed': false,
  'Sublist Functions': <Map<String, dynamic>>[
    {
      'File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.red,
      'Button Color': Colors.red.shade100,
      'Button Effects Color': Colors.red.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'Merge selected PDFs',
      'Subtitle': 'Rearrange selected PDFs then merge in 1 PDF file',
      'File Loading Required': false,
      'Action': (files, listOfListPDFPagesImages, pdfFilesPaths, pdfFilesNames,
          pdfFilesSizes, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.mergePDFPagesScaffold,
          arguments: MergePDFPagesScaffoldArguments(
            pdfFiles: files,
            processType: 'Merge Selected PDFs',
            listOfListPDFPagesImages: listOfListPDFPagesImages,
            pdfFilesPaths: pdfFilesPaths,
            pdfFilesNames: pdfFilesNames,
            pdfFilesSizes: pdfFilesSizes,
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
  ],
};

Map<String, dynamic>? mapOfSplitFunctionDetailsForPDFTools = {
  'Title': 'Split PDF',
  'Subtitle': 'Easily extract pages from PDF file',
  'Icon Asset': 'assets/images/functions_icons/split_icon.svg',
  'Icon And Text Color': Colors.red,
  'BG Color': Colors.red.shade100,
  'Select File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
  'Select File Icon Color': null,
  'Select File Button Color': Colors.lightBlue.shade50,
  'Select File Button Effects Color': Colors.lightBlue.withOpacity(0.1),
  'Select File Type': 'Select Single File',
  'Function Body Type': 'Single File Body',
  'Encrypted Files Allowed': false,
  'Sublist Functions': <Map<String, dynamic>>[
    {
      'File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.red,
      'Button Color': Colors.red.shade100,
      'Button Effects Color': Colors.red.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'Extract select pages',
      'Subtitle': 'All selected page will be extracted in 1 PDF file',
      'File Loading Required': true,
      'Action': (file, pdfPagesImages, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfPagesSelectionScaffold,
          arguments: PDFPagesSelectionScaffoldArguments(
            pdfPagesImages: pdfPagesImages,
            pdfFile: file,
            processType: 'Extract Selected PDF Pages',
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
    {
      'File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.red,
      'Button Color': Colors.red.shade100,
      'Button Effects Color': Colors.red.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'Custom ranges',
      'Subtitle': 'Extract page ranges into 1 or separate PDF files',
      'File Loading Required': false,
      'Action': (file, pdfPagesImages, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.customRangePDFPagesScaffold,
          arguments: CustomRangePDFPagesScaffoldArguments(
            pdfPagesImages: pdfPagesImages,
            pdfFile: file,
            processType: 'Extract Custom Range PDF Pages',
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
    {
      'File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.red,
      'Button Color': Colors.red.shade100,
      'Button Effects Color': Colors.red.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'Fixed range',
      'Subtitle': 'Split PDF pages in fixed interval',
      'File Loading Required': false,
      'Action': (file, pdfPagesImages, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.fixedRangePDFPagesScaffold,
          arguments: FixedRangePDFPagesScaffoldArguments(
            pdfPagesImages: pdfPagesImages,
            pdfFile: file,
            processType: 'Extract Fixed Range PDF Pages',
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
    {
      'File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.red,
      'Button Color': Colors.red.shade100,
      'Button Effects Color': Colors.red.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'Extract all pages',
      'Subtitle': 'Extract every page into separate PDF files',
      'File Loading Required': false,
      'Action': (file, pdfPagesImages, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.extractAllPDFPagesScaffold,
          arguments: ExtractAllPDFPagesScaffoldArguments(
            pdfPagesImages: pdfPagesImages,
            pdfFile: file,
            processType: 'Extract All PDF Pages',
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
  ],
};

Map<String, dynamic>? mapOfModifyFunctionDetailsForPDFTools = {
  'Title': 'Modify PDF',
  'Subtitle': 'Easily modify pdf pages from PDF file',
  'Icon Asset': 'assets/images/functions_icons/modify_pdf_icon.svg',
  'Icon And Text Color': Colors.red,
  'BG Color': Colors.red.shade100,
  'Select File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
  'Select File Icon Color': null,
  'Select File Button Color': Colors.lightBlue.shade50,
  'Select File Button Effects Color': Colors.lightBlue.withOpacity(0.1),
  'Select File Type': 'Select Single File',
  'Function Body Type': 'Single File Body',
  'Encrypted Files Allowed': false,
  'Sublist Functions': <Map<String, dynamic>>[
    {
      'File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.red,
      'Button Color': Colors.red.shade100,
      'Button Effects Color': Colors.red.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'Modify pages',
      'Subtitle': 'Perform operations like delete, rotate, reorder',
      'File Loading Required': true,
      'Action': (file, pdfPagesImages, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfPagesModificationScaffold,
          arguments: PDFPagesModificationScaffoldArguments(
            pdfPagesImages: pdfPagesImages,
            pdfFile: file,
            processType: 'Modify PDF Data',
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
  ],
};

Map<String, dynamic>? mapOfCompressFunctionDetailsForPDFTools = {
  'Title': 'Compress PDF',
  'Subtitle': 'Easily decrease PDF file size by compressing',
  'Icon Asset': 'assets/images/functions_icons/compress_icon.svg',
  'Icon And Text Color': Colors.red,
  'BG Color': Colors.red.shade100,
  'Select File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
  'Select File Icon Color': null,
  'Select File Button Color': Colors.lightBlue.shade50,
  'Select File Button Effects Color': Colors.lightBlue.withOpacity(0.1),
  'Select File Type': 'Select Single File',
  'Function Body Type': 'Single File Body',
  'Encrypted Files Allowed': false,
  'Sublist Functions': <Map<String, dynamic>>[
    {
      'File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.red,
      'Button Color': Colors.red.shade100,
      'Button Effects Color': Colors.red.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'Compress PDF Offline (Beta)',
      'Subtitle': 'Compress PDF in low, medium and high quality',
      'File Loading Required': false,
      'Action': (file, pdfPagesImages, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.compressPDFScaffold,
          arguments: CompressPDFScaffoldArguments(
            pdfPagesImages: pdfPagesImages,
            pdfFile: file,
            processType: 'Compress PDF Data',
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
  ],
};

Map<String, dynamic>? mapOfProtectFunctionDetailsForPDFTools = {
  'Title': 'Encrypt & Decrypt PDF',
  'Subtitle': 'Easily protect & unlock PDF file',
  'Icon Asset': 'assets/images/functions_icons/encrypt_decrypt_icon.svg',
  'Icon And Text Color': Colors.red,
  'BG Color': Colors.red.shade100,
  'Select File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
  'Select File Icon Color': null,
  'Select File Button Color': Colors.lightBlue.shade50,
  'Select File Button Effects Color': Colors.lightBlue.withOpacity(0.1),
  'Select File Type': 'Select Single File',
  'Function Body Type': 'Single File Body',
  'Encrypted Files Allowed': true,
  'Sublist Functions': <Map<String, dynamic>>[
    {
      'File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.red,
      'Button Color': Colors.red.shade100,
      'Button Effects Color': Colors.red.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'Encrypt PDF',
      'Subtitle': 'Set owner & user password',
      'File Loading Required': false,
      'Action': (file, pdfPagesImages, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.encryptPDFScaffold,
          arguments: EncryptPDFScaffoldArguments(
            pdfPagesImages: pdfPagesImages,
            pdfFile: file,
            processType: 'Encrypt PDF',
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
    {
      'File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.red,
      'Button Color': Colors.red.shade100,
      'Button Effects Color': Colors.red.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'Decrypt PDF',
      'Subtitle': 'Remove owner & user password',
      'File Loading Required': false,
      'Action': (file, pdfPagesImages, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.decryptPDFScaffold,
          arguments: DecryptPDFScaffoldArguments(
            pdfPagesImages: pdfPagesImages,
            pdfFile: file,
            processType: 'Decrypt PDF',
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
    // {
    //   'File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
    //   'File Icon Color': null,
    //   'Main Color': Colors.red,
    //   'Button Color': Colors.red.shade100,
    //   'Button Effects Color': Colors.red.withOpacity(0.1),
    //   'Button Text Color': Colors.black,
    //   'Title': 'Manage PDF Permissions',
    //   'Subtitle': 'Add or remove PDF security permissions',
    //   'File Loading Required': false,
    //   'Action': (file, pdfPagesImages, mapOfSubFunctionDetails, context) {
    //     Navigator.pushNamed(
    //       context,
    //       PageRoutes.pdfPagesModificationScaffold,
    //       arguments: PDFPagesModificationScaffoldArguments(
    //         pdfPagesImages: pdfPagesImages,
    //         pdfFile: file,
    //         processType: 'Modify PDF Data',
    //         mapOfSubFunctionDetails: mapOfSubFunctionDetails,
    //       ),
    //     );
    //   },
    // },
  ],
};

Map<String, dynamic>? mapOfConvertFunctionDetailsForPDFTools = {
  'Title': 'Convert PDF',
  'Subtitle': 'Easily convert PDF file to other formats',
  'Icon Asset': 'assets/images/functions_icons/convert_pdf_icon.svg',
  'Icon And Text Color': Colors.red,
  'BG Color': Colors.red.shade100,
  'Select File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
  'Select File Icon Color': null,
  'Select File Button Color': Colors.lightBlue.shade50,
  'Select File Button Effects Color': Colors.lightBlue.withOpacity(0.1),
  'Select File Type': 'Select Single File',
  'Function Body Type': 'Single File Body',
  'Encrypted Files Allowed': false,
  'Sublist Functions': <Map<String, dynamic>>[
    {
      'File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.red,
      'Button Color': Colors.red.shade100,
      'Button Effects Color': Colors.red.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'PDF to Images',
      'Subtitle': 'Convert PDF file to images',
      'File Loading Required': false,
      'Action': (file, pdfPagesImages, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfToImagesScaffold,
          arguments: PDFToImagesScaffoldArguments(
            pdfPagesImages: pdfPagesImages,
            pdfFile: file,
            processType: 'PDF TO Images',
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
  ],
};

Map<String, dynamic>? mapOfImageToPDFFunctionDetailsForPDFTools = {
  'Title': 'Images To PDF',
  'Subtitle': 'Easily convert images to PDF file',
  'Icon Asset': 'assets/images/functions_icons/images_to_pdf_icon.svg',
  'Icon And Text Color': Colors.red,
  'BG Color': Colors.red.shade100,
  'Select File Icon Asset': 'assets/images/tools_icons/image_tools_icon.svg',
  'Select File Icon Color': null,
  'Select File Button Color': Colors.lightBlue.shade50,
  'Select File Button Effects Color': Colors.lightBlue.withOpacity(0.1),
  'Select File Type': 'Select Single And Multiple File',
  'Function Body Type': 'Single And Multiple Images Body',
  'Encrypted Files Allowed': false,
  'Sublist Functions': <Map<String, dynamic>>[
    {
      'File Icon Asset': 'assets/images/functions_icons/image_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.red,
      'Button Color': Colors.red.shade100,
      'Button Effects Color': Colors.red.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'Images to PDF',
      'Subtitle': 'Reorder, rotate images & then convert to PDF',
      'File Loading Required': true,
      'Action': (files, compressedFiles, filePaths, compressedFilesPaths,
          fileNames, fileSizes, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.imagesToPDFScaffold,
          arguments: ImagesToPDFScaffoldArguments(
            //imagesList: imagesList,
            files: files,
            compressedFiles: compressedFiles,
            processType: 'Images To PDF',
            filePaths: filePaths,
            compressedFilesPaths: compressedFilesPaths,
            fileNames: fileNames,
            fileSizes: fileSizes,
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
  ],
};

Map<String, dynamic>? mapOfWatermarkPDFFunctionDetailsForPDFTools = {
  'Title': 'Watermark PDF',
  'Subtitle': 'Easily add watermark to PDF file',
  'Icon Asset': 'assets/images/functions_icons/watermark_icon.svg',
  'Icon And Text Color': Colors.red,
  'BG Color': Colors.red.shade100,
  'Select File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
  'Select File Icon Color': null,
  'Select File Button Color': Colors.lightBlue.shade50,
  'Select File Button Effects Color': Colors.lightBlue.withOpacity(0.1),
  'Select File Type': 'Select Single File',
  'Function Body Type': 'Single File Body',
  'Encrypted Files Allowed': false,
  'Sublist Functions': <Map<String, dynamic>>[
    {
      'File Icon Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.red,
      'Button Color': Colors.red.shade100,
      'Button Effects Color': Colors.red.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'Watermark PDF',
      'Subtitle': 'Easily add watermark to PDF file',
      'File Loading Required': true,
      'Action': (file, pdfPagesImages, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.watermarkPDFPagesScaffold,
          arguments: WatermarkPDFPagesScaffoldArguments(
            pdfPagesImages: pdfPagesImages,
            pdfFile: file,
            processType: 'Watermark PDF',
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
  ],
};

//For Images
Map<String, dynamic>? mapOfImageToPDFFunctionDetailsForImageTools = {
  'Title': 'Convert Images',
  'Subtitle': 'Easily convert images to another file',
  'Icon Asset': 'assets/images/functions_icons/convert_pdf_icon.svg',
  'Icon And Text Color': Colors.blue,
  'BG Color': Colors.blue.shade100,
  'Select File Icon Asset': 'assets/images/tools_icons/image_tools_icon.svg',
  'Select File Icon Color': null,
  'Select File Button Color': Colors.lightBlue.shade50,
  'Select File Button Effects Color': Colors.lightBlue.withOpacity(0.1),
  'Select File Type': 'Select Single And Multiple File',
  'Function Body Type': 'Single And Multiple Images Body',
  'Sublist Functions': <Map<String, dynamic>>[
    {
      'File Icon Asset': 'assets/images/functions_icons/image_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.blue,
      'Button Color': Colors.blue.shade100,
      'Button Effects Color': Colors.blue.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'Images to PDF',
      'Subtitle': 'Reorder, rotate images & then convert to PDF',
      'File Loading Required': true,
      'Action': (files, compressedFiles, filePaths, compressedFilesPaths,
          fileNames, fileSizes, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.imagesToPDFScaffold,
          arguments: ImagesToPDFScaffoldArguments(
            //imagesList: imagesList,
            files: files,
            compressedFiles: compressedFiles,
            processType: 'Images To PDF',
            filePaths: filePaths,
            compressedFilesPaths: compressedFilesPaths,
            fileNames: fileNames,
            fileSizes: fileSizes,
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
  ],
};

Map<String, dynamic>? mapOfModifyImageFunctionDetailsForImageTools = {
  'Title': 'Modify Image',
  'Subtitle': 'Crop, rotate, flip or set a fixed aspect ratio',
  'Icon Asset': 'assets/images/functions_icons/modify_image_icon.svg',
  'Icon And Text Color': Colors.blue,
  'BG Color': Colors.blue.shade100,
  'Select File Icon Asset': 'assets/images/tools_icons/image_tools_icon.svg',
  'Select File Icon Color': null,
  'Select File Button Color': Colors.lightBlue.shade50,
  'Select File Button Effects Color': Colors.lightBlue.withOpacity(0.1),
  'Select File Type': 'Select Single File',
  'Function Body Type': 'Single Image Body',
  'Sublist Functions': <Map<String, dynamic>>[
    {
      'File Icon Asset': 'assets/images/functions_icons/image_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.blue,
      'Button Color': Colors.blue.shade100,
      'Button Effects Color': Colors.blue.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'Modify Image',
      'Subtitle': 'Crop, rotate, flip or set a fixed aspect ratio',
      'File Loading Required': true,
      'Action': (file, compressedFile, filePath, compressedFilesPath, fileName,
          fileSize, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.modifyImageScaffold,
          arguments: ModifyImageScaffoldArguments(
            //imagesList: imagesList,
            file: file,
            compressedFile: compressedFile,
            processType: 'Modify Image',
            filePath: filePath,
            compressedFilesPath: compressedFilesPath,
            fileName: fileName,
            fileSize: fileSize,
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
  ],
};

Map<String, dynamic>? mapOfCompressImagesFunctionDetailsForImageTools = {
  'Title': 'Compress Images',
  'Subtitle': 'Reduce any image size by compressing it',
  'Icon Asset': 'assets/images/functions_icons/compress_icon.svg',
  'Icon And Text Color': Colors.blue,
  'BG Color': Colors.blue.shade100,
  'Select File Icon Asset': 'assets/images/tools_icons/image_tools_icon.svg',
  'Select File Icon Color': null,
  'Select File Button Color': Colors.lightBlue.shade50,
  'Select File Button Effects Color': Colors.lightBlue.withOpacity(0.1),
  'Select File Type': 'Select Single And Multiple File',
  'Function Body Type': 'Single And Multiple Images Body',
  'Sublist Functions': <Map<String, dynamic>>[
    {
      'File Icon Asset': 'assets/images/functions_icons/image_tools_icon.svg',
      'File Icon Color': null,
      'Main Color': Colors.blue,
      'Button Color': Colors.blue.shade100,
      'Button Effects Color': Colors.blue.withOpacity(0.1),
      'Button Text Color': Colors.black,
      'Title': 'Compress Images',
      'Subtitle': 'Reduce any image size by compressing it',
      'File Loading Required': true,
      'Action': (files, compressedFiles, filePaths, compressedFilesPaths,
          fileNames, fileSizes, mapOfSubFunctionDetails, context) {
        Navigator.pushNamed(
          context,
          PageRoutes.compressImagesScaffold,
          arguments: CompressImagesScaffoldArguments(
            //imagesList: imagesList,
            files: files,
            compressedFiles: compressedFiles,
            processType: 'Compress Images',
            filePaths: filePaths,
            compressedFilesPaths: compressedFilesPaths,
            fileNames: fileNames,
            fileSizes: fileSizes,
            mapOfSubFunctionDetails: mapOfSubFunctionDetails,
          ),
        );
      },
    },
  ],
};
