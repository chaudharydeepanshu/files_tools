import 'package:files_tools/ui/screens/about_page.dart';
import 'package:files_tools/ui/screens/homescreen/pages/components/image_tools_section.dart';
import 'package:files_tools/ui/screens/image_tools_screens/compress_image/compress_image_screen.dart';
import 'package:files_tools/ui/screens/image_tools_screens/compress_image/compress_image_tool_screen.dart';
import 'package:files_tools/ui/screens/image_tools_screens/crop_rotate_flip_images/crop_rotate_flip_images_screen.dart';
import 'package:files_tools/ui/screens/image_tools_screens/crop_rotate_flip_images/crop_rotate_flip_images_tools_screen.dart';
import 'package:files_tools/ui/screens/image_tools_screens/pdf_to_image/pdf_to_image_screen.dart';
import 'package:files_tools/ui/screens/image_viewer.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/compress_pdf/compress_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/compress_pdf/compress_pdf_tool_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/decrypt_pdf/decrypt_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/decrypt_pdf/decrypt_pdf_tools_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/image_to_pdf/image_to_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/image_to_pdf/image_to_pdf_tools_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/watermark_pdf/watermark_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/watermark_pdf/watermark_pdf_tool_screen.dart';
import 'package:files_tools/ui/screens/pdf_viewer.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/convert_pdf/convert_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/convert_pdf/convert_pdf_tool_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/modify_pdf/modify_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/modify_pdf/modify_pdf_tool_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/split_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/split_pdf_tools_screen.dart';
import 'package:files_tools/ui/screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:files_tools/ui/screens/homescreen/homescreen.dart';
import 'package:files_tools/ui/screens/homescreen/pages/components/pdf_tools_section.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/merge_pdfs_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/encrypt_pdf/encrypt_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/encrypt_pdf/encrypt_pdf_tools_screen.dart';

// Note: When using path "/" in routes then the initial route will always have to be "/".

// Route Names
const String homePage = '/';
const String aboutPage = '/about';
const String pdfViewer = '/pdfViewer';
const String imageViewer = '/imageViewer';
const String pdfToolsPage = '/pdfTools';
const String mergePDFsPage = '/mergePDFs';
const String splitPDFPage = '/splitPDF';
const String modifyPDFPage = '/modifyPDF';
const String convertPDFPage = '/convertPDF';
const String compressPDFPage = '/CompressPDF';
const String watermarkPDFPage = '/WatermarkPDF';
const String encryptPDFPage = '/EncryptPDF';
const String decryptPDFPage = '/DecryptPDF';
const String imageToPDFPage = '/ImageToPDF';
const String splitPDFToolsPage = '/SplitPDFTools';
const String modifyPDFToolsPage = '/ModifyPDFTools';
const String convertPDFToolsPage = '/ConvertPDFTools';
const String compressPDFToolsPage = '/CompressPDFTools';
const String watermarkPDFToolsPage = '/WatermarkPDFTools';
const String encryptPDFToolsPage = '/EncryptPDFTools';
const String decryptPDFToolsPage = '/DecryptPDFTools';
const String imageToPDFToolsPage = '/ImageToPDFTools';
const String imageToolsPage = '/imageTools';
const String compressImagePage = '/CompressImage';
const String compressImageToolsPage = '/CompressImageTools';
const String pdfToImagePage = '/pdfToImage';
const String cropRotateFlipImagesPage = '/CropRotateFlipImages';
const String cropRotateFlipImagesToolsPage = '/CropRotateFlipImagesTools';
const String resultPage = '/Result';

// Control our page route flow
Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case homePage:
      return MaterialPageRoute(
          builder: (context) => const HomePage(),
          settings: RouteSettings(name: settings.name));
    case aboutPage:
      return MaterialPageRoute(
          builder: (context) => const AboutPage(),
          settings: RouteSettings(name: settings.name));
    case pdfViewer:
      return MaterialPageRoute(
          builder: (context) =>
              PdfViewer(arguments: settings.arguments as PdfViewerArguments),
          settings: RouteSettings(name: settings.name));
    case imageViewer:
      return MaterialPageRoute(
          builder: (context) => ImageViewer(
              arguments: settings.arguments as ImageViewerArguments),
          settings: RouteSettings(name: settings.name));
    case pdfToolsPage:
      return MaterialPageRoute(
          builder: (context) => PDFToolsPage(
              arguments: settings.arguments as PDFToolsPageArguments),
          settings: RouteSettings(name: settings.name));
    case mergePDFsPage:
      return MaterialPageRoute(
          builder: (context) => const MergePDFsPage(),
          settings: RouteSettings(name: settings.name));
    case splitPDFPage:
      return MaterialPageRoute(
          builder: (context) => const SplitPDFPage(),
          settings: RouteSettings(name: settings.name));
    case splitPDFToolsPage:
      return MaterialPageRoute(
          builder: (context) => SplitPDFToolsPage(
              arguments: settings.arguments as SplitPDFToolsPageArguments),
          settings: RouteSettings(name: settings.name));
    case modifyPDFPage:
      return MaterialPageRoute(
          builder: (context) => const ModifyPDFPage(),
          settings: RouteSettings(name: settings.name));
    case modifyPDFToolsPage:
      return MaterialPageRoute(
          builder: (context) => ModifyPDFToolsPage(
              arguments: settings.arguments as ModifyPDFToolsPageArguments),
          settings: RouteSettings(name: settings.name));
    case convertPDFPage:
      return MaterialPageRoute(
          builder: (context) => const ConvertPDFPage(),
          settings: RouteSettings(name: settings.name));
    case convertPDFToolsPage:
      return MaterialPageRoute(
          builder: (context) => ConvertPDFToolsPage(
              arguments: settings.arguments as ConvertPDFToolsPageArguments),
          settings: RouteSettings(name: settings.name));
    case compressPDFPage:
      return MaterialPageRoute(
          builder: (context) => const CompressPDFPage(),
          settings: RouteSettings(name: settings.name));
    case compressPDFToolsPage:
      return MaterialPageRoute(
          builder: (context) => CompressPDFToolsPage(
              arguments: settings.arguments as CompressPDFToolsPageArguments),
          settings: RouteSettings(name: settings.name));
    case watermarkPDFPage:
      return MaterialPageRoute(
          builder: (context) => const WatermarkPDFPage(),
          settings: RouteSettings(name: settings.name));
    case watermarkPDFToolsPage:
      return MaterialPageRoute(
          builder: (context) => WatermarkPDFToolsPage(
              arguments: settings.arguments as WatermarkPDFToolsPageArguments),
          settings: RouteSettings(name: settings.name));
    case encryptPDFPage:
      return MaterialPageRoute(
          builder: (context) => const EncryptPDFPage(),
          settings: RouteSettings(name: settings.name));
    case encryptPDFToolsPage:
      return MaterialPageRoute(
          builder: (context) => EncryptPDFToolsPage(
              arguments: settings.arguments as EncryptPDFToolsPageArguments),
          settings: RouteSettings(name: settings.name));
    case decryptPDFPage:
      return MaterialPageRoute(
          builder: (context) => const DecryptPDFPage(),
          settings: RouteSettings(name: settings.name));
    case decryptPDFToolsPage:
      return MaterialPageRoute(
          builder: (context) => DecryptPDFToolsPage(
              arguments: settings.arguments as DecryptPDFToolsPageArguments),
          settings: RouteSettings(name: settings.name));
    case imageToPDFPage:
      return MaterialPageRoute(
          builder: (context) => const ImageToPDFPage(),
          settings: RouteSettings(name: settings.name));
    case imageToPDFToolsPage:
      return MaterialPageRoute(
          builder: (context) => ImageToPDFToolsPage(
              arguments: settings.arguments as ImageToPDFToolsPageArguments),
          settings: RouteSettings(name: settings.name));
    case imageToolsPage:
      return MaterialPageRoute(
          builder: (context) => ImageToolsPage(
              arguments: settings.arguments as ImageToolsPageArguments),
          settings: RouteSettings(name: settings.name));
    case compressImagePage:
      return MaterialPageRoute(
          builder: (context) => const CompressImagePage(),
          settings: RouteSettings(name: settings.name));
    case compressImageToolsPage:
      return MaterialPageRoute(
          builder: (context) => CompressImageToolsPage(
              arguments: settings.arguments as CompressImageToolsPageArguments),
          settings: RouteSettings(name: settings.name));
    case pdfToImagePage:
      return MaterialPageRoute(
          builder: (context) => const PdfToImagePage(),
          settings: RouteSettings(name: settings.name));
    case cropRotateFlipImagesPage:
      return MaterialPageRoute(
          builder: (context) => const CropRotateFlipImagesPage(),
          settings: RouteSettings(name: settings.name));
    case cropRotateFlipImagesToolsPage:
      return MaterialPageRoute(
          builder: (context) => CropRotateFlipImagesToolsPage(
              arguments:
                  settings.arguments as CropRotateFlipImagesToolsPageArguments),
          settings: RouteSettings(name: settings.name));
    case resultPage:
      return MaterialPageRoute(
          builder: (context) => const ResultPage(),
          settings: RouteSettings(name: settings.name));
    default:
      throw ('This route name does not exist');
  }
}

/*
Follows https://oflutter.com/organized-navigation-named-route-in-flutter/ route approach.

Use MaterialPageRoute() which uses a default animation. For different one, use PageRouteBuilder() or CupertinoPageRoute().

To Navigate to another page make sure you added a new page to a route.dart file. Then, you can import ‘route/route.dart’ as route; and use route.myNewPage.

To pass an argument while routing between pages consider this example:
Ex: To pass an argument from loginPage to homePage. To do so, first add argument request in HomePage stateless widget. Like so:

home.dart
...
class HomePage extends StatelessWidget {
  final Object argument;
  HomePage({this.argument});

 ....

}
Then, add settings.arguments option to Route<dynamic> controller(RouteSettings settings) for HomePage

route.dart
......

// Control our page route flow
Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    .....
    case homePage:
      return MaterialPageRoute(builder: (context) => HomePage(arguments: settings.arguments));
    .....

  }
}

.....
Finally, pass any objects e.g text, data when you use Navigator.pushNamed();

home.dart
....

class LoginPage extends StatelessWidget {
....
        child: ElevatedeButton(
         ....
          onPressed: () => Navigator.pushNamed(context, route.homePage, arguments: 'My object As Text'),
         ....
        ),
      ),
    );
  }
}
*/
