import 'package:files_tools/ui/screens/about_page.dart';
import 'package:files_tools/ui/screens/homescreen/homescreen.dart';
import 'package:files_tools/ui/screens/homescreen/pages/components/image_tools_section.dart';
import 'package:files_tools/ui/screens/homescreen/pages/components/pdf_tools_section.dart';
import 'package:files_tools/ui/screens/image_tools_screens/compress_image/compress_image_screen.dart';
import 'package:files_tools/ui/screens/image_tools_screens/compress_image/compress_image_tool_screen.dart';
import 'package:files_tools/ui/screens/image_tools_screens/crop_rotate_flip_images/crop_rotate_flip_images_screen.dart';
import 'package:files_tools/ui/screens/image_tools_screens/crop_rotate_flip_images/crop_rotate_flip_images_tools_screen.dart';
import 'package:files_tools/ui/screens/image_tools_screens/pdf_to_image/pdf_to_image_screen.dart';
import 'package:files_tools/ui/screens/image_viewer.dart';
import 'package:files_tools/ui/screens/onboarding_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/compress_pdf/compress_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/compress_pdf/compress_pdf_tool_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/convert_pdf/convert_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/convert_pdf/convert_pdf_tool_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/decrypt_pdf/decrypt_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/decrypt_pdf/decrypt_pdf_tools_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/encrypt_pdf/encrypt_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/encrypt_pdf/encrypt_pdf_tools_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/image_to_pdf/image_to_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/image_to_pdf/image_to_pdf_tools_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/merge_pdfs_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/modify_pdf/modify_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/modify_pdf/modify_pdf_tool_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/split_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/split_pdf_tools_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/watermark_pdf/watermark_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/watermark_pdf/watermark_pdf_tool_screen.dart';
import 'package:files_tools/ui/screens/pdf_viewer.dart';
import 'package:files_tools/ui/screens/result_screen.dart';
import 'package:files_tools/ui/screens/settings_page.dart';
import 'package:flutter/material.dart';

/// App routes names.
///
/// Note: When using path "/" in routes names then the initial route will always
/// have to be "/" and will always run "/" no matter what initial route is.
class AppRoutes {
  /// [OnBoardingScreen] screen route name.
  static const String onBoardingPage = 'onBoarding';

  /// [HomePage] screen route name.
  static const String homePage = 'homePage';

  /// [AboutPage] screen route name.
  static const String aboutPage = 'about';

  /// [SettingsPage] screen route name.
  static const String settingsPage = 'settings';

  /// [PdfViewer] screen route name.
  static const String pdfViewer = 'pdfViewer';

  /// [ImageViewer] screen route name.
  static const String imageViewer = 'imageViewer';

  /// [PDFToolsPage] screen route name.
  static const String pdfToolsPage = 'pdfTools';

  /// [MergePDFsPage] screen route name.
  static const String mergePDFsPage = 'mergePDFs';

  /// [SplitPDFPage] screen route name.
  static const String splitPDFPage = 'splitPDF';

  /// [ModifyPDFPage] screen route name.
  static const String modifyPDFPage = 'modifyPDF';

  /// [ConvertPDFPage] screen route name.
  static const String convertPDFPage = 'convertPDF';

  /// [CompressPDFPage] screen route name.
  static const String compressPDFPage = 'CompressPDF';

  /// [WatermarkPDFPage] screen route name.
  static const String watermarkPDFPage = 'WatermarkPDF';

  /// [EncryptPDFPage] screen route name.
  static const String encryptPDFPage = 'EncryptPDF';

  /// [DecryptPDFPage] screen route name.
  static const String decryptPDFPage = 'DecryptPDF';

  /// [ImageToPDFPage] screen route name.
  static const String imageToPDFPage = 'ImageToPDF';

  /// [SplitPDFToolsPage] screen route name.
  static const String splitPDFToolsPage = 'SplitPDFTools';

  /// [ModifyPDFToolsPage] screen route name.
  static const String modifyPDFToolsPage = 'ModifyPDFTools';

  /// [ConvertPDFToolsPage] screen route name.
  static const String convertPDFToolsPage = 'ConvertPDFTools';

  /// [CompressPDFToolsPage] screen route name.
  static const String compressPDFToolsPage = 'CompressPDFTools';

  /// [WatermarkPDFToolsPage] screen route name.
  static const String watermarkPDFToolsPage = 'WatermarkPDFTools';

  /// [EncryptPDFToolsPage] screen route name.
  static const String encryptPDFToolsPage = 'EncryptPDFTools';

  /// [DecryptPDFToolsPage] screen route name.
  static const String decryptPDFToolsPage = 'DecryptPDFTools';

  /// [ImageToPDFToolsPage] screen route name.
  static const String imageToPDFToolsPage = 'ImageToPDFTools';

  /// [ImageToolsPage] screen route name.
  static const String imageToolsPage = 'imageTools';

  /// [CompressImagePage] screen route name.
  static const String compressImagePage = 'CompressImage';

  /// [CompressImageToolsPage] screen route name.
  static const String compressImageToolsPage = 'CompressImageTools';

  /// [PdfToImagePage] screen route name.
  static const String pdfToImagePage = 'pdfToImage';

  /// [CropRotateFlipImagesPage] screen route name.
  static const String cropRotateFlipImagesPage = 'CropRotateFlipImages';

  /// [CropRotateFlipImagesToolsPage] screen route name.
  static const String cropRotateFlipImagesToolsPage =
      'CropRotateFlipImagesTools';

  /// [ActionResultPage] screen route name.
  static const String resultPage = 'Result';

  /// Controls app page routes flow.
  static Route<Widget> controller(RouteSettings settings) {
    switch (settings.name) {
      case onBoardingPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const OnBoardingScreen(),
          settings: RouteSettings(name: settings.name),
        );
      case homePage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const HomePage(),
          settings: RouteSettings(name: settings.name),
        );
      case aboutPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const AboutPage(),
          settings: RouteSettings(name: settings.name),
        );
      case settingsPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const SettingsPage(),
          settings: RouteSettings(name: settings.name),
        );
      case pdfViewer:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) =>
              PdfViewer(arguments: settings.arguments as PdfViewerArguments),
          settings: RouteSettings(name: settings.name),
        );
      case imageViewer:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => ImageViewer(
            arguments: settings.arguments as ImageViewerArguments,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case pdfToolsPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => PDFToolsPage(
            arguments: settings.arguments as PDFToolsPageArguments,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case mergePDFsPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const MergePDFsPage(),
          settings: RouteSettings(name: settings.name),
        );
      case splitPDFPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const SplitPDFPage(),
          settings: RouteSettings(name: settings.name),
        );
      case splitPDFToolsPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => SplitPDFToolsPage(
            arguments: settings.arguments as SplitPDFToolsPageArguments,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case modifyPDFPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const ModifyPDFPage(),
          settings: RouteSettings(name: settings.name),
        );
      case modifyPDFToolsPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => ModifyPDFToolsPage(
            arguments: settings.arguments as ModifyPDFToolsPageArguments,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case convertPDFPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const ConvertPDFPage(),
          settings: RouteSettings(name: settings.name),
        );
      case convertPDFToolsPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => ConvertPDFToolsPage(
            arguments: settings.arguments as ConvertPDFToolsPageArguments,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case compressPDFPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const CompressPDFPage(),
          settings: RouteSettings(name: settings.name),
        );
      case compressPDFToolsPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => CompressPDFToolsPage(
            arguments: settings.arguments as CompressPDFToolsPageArguments,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case watermarkPDFPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const WatermarkPDFPage(),
          settings: RouteSettings(name: settings.name),
        );
      case watermarkPDFToolsPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => WatermarkPDFToolsPage(
            arguments: settings.arguments as WatermarkPDFToolsPageArguments,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case encryptPDFPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const EncryptPDFPage(),
          settings: RouteSettings(name: settings.name),
        );
      case encryptPDFToolsPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => EncryptPDFToolsPage(
            arguments: settings.arguments as EncryptPDFToolsPageArguments,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case decryptPDFPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const DecryptPDFPage(),
          settings: RouteSettings(name: settings.name),
        );
      case decryptPDFToolsPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => DecryptPDFToolsPage(
            arguments: settings.arguments as DecryptPDFToolsPageArguments,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case imageToPDFPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const ImageToPDFPage(),
          settings: RouteSettings(name: settings.name),
        );
      case imageToPDFToolsPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => ImageToPDFToolsPage(
            arguments: settings.arguments as ImageToPDFToolsPageArguments,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case imageToolsPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => ImageToolsPage(
            arguments: settings.arguments as ImageToolsPageArguments,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case compressImagePage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const CompressImagePage(),
          settings: RouteSettings(name: settings.name),
        );
      case compressImageToolsPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => CompressImageToolsPage(
            arguments: settings.arguments as CompressImageToolsPageArguments,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case pdfToImagePage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const PdfToImagePage(),
          settings: RouteSettings(name: settings.name),
        );
      case cropRotateFlipImagesPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const CropRotateFlipImagesPage(),
          settings: RouteSettings(name: settings.name),
        );
      case cropRotateFlipImagesToolsPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => CropRotateFlipImagesToolsPage(
            arguments:
                settings.arguments as CropRotateFlipImagesToolsPageArguments,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case resultPage:
        return MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const ActionResultPage(),
          settings: RouteSettings(name: settings.name),
        );
      default:
        throw ('This route name does not exist');
    }
  }
}

/// Use MaterialPageRoute<Widget>() which uses a default animation and for
/// different animation, use PageRouteBuilder() or CupertinoPageRoute().
///
/// To pass an argument while routing between pages consider this example:
/// Ex: To pass an argument from loginPage to homePage, first add argument
/// request in HomePage stateless widget. Like so:
/// home.dart
/// ```
/// class HomePage extends StatelessWidget {
///   final Object argument;
///
///   HomePage({required this.argument});
///
///   @override
///   Widget build(BuildContext context) {
///   return SizedBox();
///   }
/// }
/// ```
/// Then, add settings.arguments option to
/// Route<dynamic> controller(RouteSettings settings) for HomePage. Like so:
/// ```
/// Route<Widget> controller(RouteSettings settings) {
///   switch (settings.name) {
///   ...
///   case homePage:
///     return MaterialPageRoute<Widget>(
///       builder: (context) => HomePage(arguments: settings.arguments));
///   ...
///   }
/// }
/// ```
/// Finally, pass any objects e.g text, data when you use
/// Navigator.pushNamed();. Like so:
/// AnyOtherPage.dart
/// ```
/// class AnyOtherPage extends StatelessWidget {
///   const AnyOtherPage({Key? key}) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return ElevatedButton(
///       onPressed: () => Navigator.pushNamed(context, AppRoutes.homePage,
///           arguments: 'My object As Text'),
///       child: const Text("Push HomePage"),
///     );
///   }
/// }
/// ```
///
/// Credits to https://web.archive.org/web/20221203142623/https://oflutter.com/organized-navigation-named-route-in-flutter/ for tutorial.
