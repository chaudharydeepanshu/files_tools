import 'package:flutter/material.dart';
import 'package:files_tools/toolExpandingContainersAndFunctionsMaps/pdf%20_functions_details_maps.dart';
import 'package:files_tools/ui/functionsMainScaffold/pdfFunctionPagesScaffold.dart';
import '../navigation/page_routes_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//For PDF
Map<String, dynamic>? mapOfCardDetailsForPDF = {
  'Card Title': (context) {
    return AppLocalizations.of(context)!.pdfCardTitle;
  },
  'Card Subtitle': (context) {
    return AppLocalizations.of(context)!.pdfCardSubtitle;
  },
  'Card Asset': 'assets/images/tools_icons/pdf_tools_icon.svg',
  'Card Asset Color': null,
  'Card Asset BG Color': Colors.red.shade100,
  'Collapsed Card BG Color': Colors.red.shade50,
  'Card BG Effects Color': Colors.red.withOpacity(0.1),
  'Card Trailing Arrow Color': Colors.black,
  'Expanded Sublist BG Color': Colors.red.shade100,
  'Functions Details': <Map<String, dynamic>>[
    {
      'Function': 'Merge PDF',
      'Icon Asset': 'assets/images/functions_icons/merge_icon.svg',
      'Icon And Text Color': Colors.red.shade100,
      'Button Color': Colors.red,
      'Action': (context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfFunctionsPageScaffold,
          arguments: PDFFunctionsPageScaffoldArguments(
            pdfFunctionCurrentIndex: 0,
            mapOfFunctionDetails: mapOfMergeFunctionDetailsForPDFTools,
          ),
        );
        debugPrint('Merge PDF opened');
      },
    },
    {
      'Function': 'Split PDF',
      'Icon Asset': 'assets/images/functions_icons/split_icon.svg',
      'Icon And Text Color': Colors.red.shade100,
      'Button Color': Colors.red,
      'Action': (context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfFunctionsPageScaffold,
          arguments: PDFFunctionsPageScaffoldArguments(
            pdfFunctionCurrentIndex: 1,
            mapOfFunctionDetails: mapOfSplitFunctionDetailsForPDFTools,
          ),
        );
        debugPrint('Split PDF opened');
      },
    },
    {
      'Function': 'Modify PDF',
      'Icon Asset': 'assets/images/functions_icons/modify_pdf_icon.svg',
      'Icon And Text Color': Colors.red.shade100,
      'Button Color': Colors.red,
      'Action': (context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfFunctionsPageScaffold,
          arguments: PDFFunctionsPageScaffoldArguments(
            pdfFunctionCurrentIndex: 2,
            mapOfFunctionDetails: mapOfModifyFunctionDetailsForPDFTools,
          ),
        );
        debugPrint('Split PDF opened');
      },
    },
    {
      'Function': 'Compress PDF',
      'Icon Asset': 'assets/images/functions_icons/compress_icon.svg',
      'Icon And Text Color': Colors.red.shade100,
      'Button Color': Colors.red,
      'Action': (context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfFunctionsPageScaffold,
          arguments: PDFFunctionsPageScaffoldArguments(
            pdfFunctionCurrentIndex: 1,
            mapOfFunctionDetails: mapOfCompressFunctionDetailsForPDFTools,
          ),
        );
        debugPrint('Split PDF opened');
      },
    },
    {
      'Function': 'Protect PDF',
      'Icon Asset': 'assets/images/functions_icons/encrypt_decrypt_icon.svg',
      'Icon And Text Color': Colors.red.shade100,
      'Button Color': Colors.red,
      'Action': (context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfFunctionsPageScaffold,
          arguments: PDFFunctionsPageScaffoldArguments(
            pdfFunctionCurrentIndex: 1,
            mapOfFunctionDetails: mapOfProtectFunctionDetailsForPDFTools,
          ),
        );
        debugPrint('Split PDF opened');
      },
    },
    {
      'Function': 'Convert PDF',
      'Icon Asset': 'assets/images/functions_icons/convert_pdf_icon.svg',
      'Icon And Text Color': Colors.red.shade100,
      'Button Color': Colors.red,
      'Action': (context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfFunctionsPageScaffold,
          arguments: PDFFunctionsPageScaffoldArguments(
            pdfFunctionCurrentIndex: 1,
            mapOfFunctionDetails: mapOfConvertFunctionDetailsForPDFTools,
          ),
        );
        debugPrint('Split PDF opened');
      },
    },
    {
      'Function': 'Images to PDF',
      'Icon Asset': 'assets/images/functions_icons/images_to_pdf_icon.svg',
      'Icon And Text Color': Colors.red.shade100,
      'Button Color': Colors.red,
      'Action': (context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfFunctionsPageScaffold,
          arguments: PDFFunctionsPageScaffoldArguments(
            pdfFunctionCurrentIndex: 1,
            mapOfFunctionDetails: mapOfImageToPDFFunctionDetailsForPDFTools,
          ),
        );
        debugPrint('Split PDF opened');
      },
    },
    {
      'Function': 'Watermark PDF',
      'Icon Asset': 'assets/images/functions_icons/watermark_icon.svg',
      'Icon And Text Color': Colors.red.shade100,
      'Button Color': Colors.red,
      'Action': (context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfFunctionsPageScaffold,
          arguments: PDFFunctionsPageScaffoldArguments(
            pdfFunctionCurrentIndex: 1,
            mapOfFunctionDetails: mapOfWatermarkPDFFunctionDetailsForPDFTools,
          ),
        );
        debugPrint('Split PDF opened');
      },
    },
  ], //<Map<String, dynamic>> denotes a list of literals of type <Map<String, dynamic>>
};

//For Images
Map<String, dynamic>? mapOfCardDetailsForImages = {
  'Card Title': (context) {
    return AppLocalizations.of(context)!.imageCardTitle;
  },
  'Card Title Color': Colors.black,
  'Card Subtitle': (context) {
    return AppLocalizations.of(context)!.imageCardSubtitle;
  },
  'Card Subtitle Color': Colors.black,
  'Card Asset': 'assets/images/tools_icons/image_tools_icon.svg',
  'Card Asset Color': null,
  'Card Asset BG Color': Colors.blue.shade100,
  'Collapsed Card BG Color': Colors.lightBlue.shade50,
  'Card BG Effects Color': Colors.lightBlue.withOpacity(0.1),
  'Card Trailing Arrow Color': Colors.black,
  'Expanded Sublist BG Color': Colors.blue.shade100,
  'Functions Details': <Map<String, dynamic>>[
    {
      'Function': 'Convert Images',
      'Icon Asset': 'assets/images/functions_icons/convert_pdf_icon.svg',
      'Icon And Text Color': Colors.blue.shade100,
      'Button Color': Colors.blue,
      'Action': (context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfFunctionsPageScaffold,
          arguments: PDFFunctionsPageScaffoldArguments(
            pdfFunctionCurrentIndex: 1,
            mapOfFunctionDetails: mapOfImageToPDFFunctionDetailsForImageTools,
          ),
        );
        debugPrint('Split PDF opened');
      },
    },
    {
      'Function': 'Modify Image',
      'Icon Asset': 'assets/images/functions_icons/modify_image_icon.svg',
      'Icon And Text Color': Colors.blue.shade100,
      'Button Color': Colors.blue,
      'Action': (context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfFunctionsPageScaffold,
          arguments: PDFFunctionsPageScaffoldArguments(
            pdfFunctionCurrentIndex: 1,
            mapOfFunctionDetails: mapOfModifyImageFunctionDetailsForImageTools,
          ),
        );
        debugPrint('Split PDF opened');
      },
    },
    {
      'Function': 'Compress Images',
      'Icon Asset': 'assets/images/functions_icons/compress_icon.svg',
      'Icon And Text Color': Colors.blue.shade100,
      'Button Color': Colors.blue,
      'Action': (context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfFunctionsPageScaffold,
          arguments: PDFFunctionsPageScaffoldArguments(
            pdfFunctionCurrentIndex: 1,
            mapOfFunctionDetails:
                mapOfCompressImagesFunctionDetailsForImageTools,
          ),
        );
        debugPrint('Split PDF opened');
      },
    },
  ],
};

//for darkMode //same for now but could be changed //see home initState & didChangePlatformBrightness to see how to change according to dark mode
Map<String, dynamic>? mapOfCardDetailsForImagesForDarkMode = {
  'Card Title': (context) {
    return AppLocalizations.of(context)!.imageCardTitle;
  },
  'Card Title Color': Colors.black,
  'Card Subtitle': (context) {
    return AppLocalizations.of(context)!.imageCardSubtitle;
  },
  'Card Subtitle Color': Colors.black,
  'Card Asset': 'assets/images/tools_icons/image_tools_icon.svg',
  'Card Asset Color': null,
  'Card Asset BG Color': Colors.blue.shade100,
  'Collapsed Card BG Color': Colors.lightBlue.shade50,
  'Card BG Effects Color': Colors.lightBlue.withOpacity(0.1),
  'Card Trailing Arrow Color': Colors.black,
  'Expanded Sublist BG Color': Colors.blue.shade100,
  'Functions Details': <Map<String, dynamic>>[
    {
      'Function': 'Convert Images',
      'Icon Asset': 'assets/images/functions_icons/convert_pdf_icon.svg',
      'Icon And Text Color': Colors.blue.shade100,
      'Button Color': Colors.blue,
      'Action': (context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfFunctionsPageScaffold,
          arguments: PDFFunctionsPageScaffoldArguments(
            pdfFunctionCurrentIndex: 1,
            mapOfFunctionDetails: mapOfImageToPDFFunctionDetailsForImageTools,
          ),
        );
        debugPrint('Split PDF opened');
      },
    },
    {
      'Function': 'Modify Image',
      'Icon Asset': 'assets/images/functions_icons/modify_image_icon.svg',
      'Icon And Text Color': Colors.blue.shade100,
      'Button Color': Colors.blue,
      'Action': (context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfFunctionsPageScaffold,
          arguments: PDFFunctionsPageScaffoldArguments(
            pdfFunctionCurrentIndex: 1,
            mapOfFunctionDetails: mapOfModifyImageFunctionDetailsForImageTools,
          ),
        );
        debugPrint('Split PDF opened');
      },
    },
    {
      'Function': 'Compress Images',
      'Icon Asset': 'assets/images/functions_icons/compress_icon.svg',
      'Icon And Text Color': Colors.blue.shade100,
      'Button Color': Colors.blue,
      'Action': (context) {
        Navigator.pushNamed(
          context,
          PageRoutes.pdfFunctionsPageScaffold,
          arguments: PDFFunctionsPageScaffoldArguments(
            pdfFunctionCurrentIndex: 1,
            mapOfFunctionDetails:
                mapOfCompressImagesFunctionDetailsForImageTools,
          ),
        );
        debugPrint('Split PDF opened');
      },
    },
  ],
};
