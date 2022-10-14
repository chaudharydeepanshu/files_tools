import 'package:files_tools/ui/screens/image_viewer.dart';
import 'package:files_tools/ui/screens/pdf_viewer.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/convert_pdf/convert_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/convert_pdf/convert_pdf_tool_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/modify_pdf/modify_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/modify_pdf/modify_pdf_tool_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/split_pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/split_pdf_tools_screen.dart';
import 'package:files_tools/ui/screens/result_screen.dart';
import 'package:flutter/material.dart';
import '../ui/screens/homescreen/homescreen.dart';
import '../ui/screens/homescreen/pages/components/pdf_tools_section.dart';
import '../ui/screens/pdf_tools_screens/merge_pdfs_screen.dart';

// Note: When using path "/" in routes then the initial route will always have to be "/".

// Route Names
const String homePage = '/';
const String pdfViewer = '/pdfViewer';
const String imageViewer = '/imageViewer';
const String pdfToolsPagePage = '/explore';
const String mergePDFsPage = '/mergePDFs';
const String splitPDFPage = '/splitPDF';
const String modifyPDFPage = '/modifyPDF';
const String convertPDFPage = '/convertPDF';
const String resultPage = '/Result';
const String splitPDFToolsPage = '/SplitPDFTools';
const String modifyPDFToolsPage = '/ModifyPDFTools';
const String convertPDFToolsPage = '/ConvertPDFTools';

// Control our page route flow
Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case homePage:
      return MaterialPageRoute(
          builder: (context) => const HomePage(),
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
    case pdfToolsPagePage:
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
