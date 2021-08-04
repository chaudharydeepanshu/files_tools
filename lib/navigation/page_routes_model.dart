import 'package:files_tools/ui/pdfFunctionsActionsScaffold/CompressPDFScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/DecryptPDFScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/EncryptPDFScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/ExtractAllPDFPagesScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/FixedRangePDFPagesScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/PDFToImagesScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/customRangePDFPagesScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/imagesToPDFScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/mergePDFPagesScaffold.dart';
import 'package:files_tools/ui/topLevelPagesScaffold/mainPageScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsMainScaffold/pdfFunctionPagesScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/pdfPagesModificationScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/pdfPagesSelectionScaffold.dart';
import 'package:files_tools/ui/pdfViewerScaffold/pdfscaffold.dart';
import 'package:files_tools/widgets/pdfFunctionsActionWidgets/reusableUIActionWidgets/reorder_pages_scaffold.dart';
import 'package:files_tools/ui/pdfFunctionsResultsScaffold/resultPdfScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsResultsScaffold/resultZipScaffold.dart';

class PageRoutes {
  static String mainPagesScaffold = MainPagesScaffold.routeName;
  static String pdfFunctionsPageScaffold = PDFFunctionsPageScaffold.routeName;
  static String pdfScaffold = PDFScaffold.routeName;
  static String pdfPagesSelectionScaffold = PDFPagesSelectionScaffold.routeName;
  static String resultPDFScaffold = ResultPDFScaffold.routeName;
  static String pdfPagesModificationScaffold =
      PDFPagesModificationScaffold.routeName;
  static String reorderPDFPagesScaffold = ReorderPDFPagesScaffold.routeName;
  static String customRangePDFPagesScaffold =
      CustomRangePDFPagesScaffold.routeName;
  static String fixedRangePDFPagesScaffold =
      FixedRangePDFPagesScaffold.routeName;
  static String extractAllPDFPagesScaffold =
      ExtractAllPDFPagesScaffold.routeName;
  static String resultZipScaffold = ResultZipScaffold.routeName;
  static String mergePDFPagesScaffold = MergePDFPagesScaffold.routeName;
  static String compressPDFScaffold = CompressPDFScaffold.routeName;
  static String encryptPDFScaffold = EncryptPDFScaffold.routeName;
  static String decryptPDFScaffold = DecryptPDFScaffold.routeName;
  static String imagesToPDFScaffold = ImagesToPDFScaffold.routeName;
  static String pdfToImagesScaffold = PDFToImagesScaffold.routeName;
  // static String recent = Recent.routeName;
  // static String favourite = Favourite.routeName;
  // static String tools = Tools.routeName;
}
