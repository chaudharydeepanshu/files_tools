import 'package:files_tools/ui/functionsActionsScaffold/CompressPDFScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/DecryptPDFScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/EncryptPDFScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/ExtractAllPDFPagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/FixedRangePDFPagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/ModifyImageScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/PDFToImagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/customRangePDFPagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/imagesToPDFScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/mergePDFPagesScaffold.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultImageScaffold.dart';
import 'package:files_tools/ui/topLevelPagesScaffold/mainPageScaffold.dart';
import 'package:files_tools/ui/functionsMainScaffold/pdfFunctionPagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/pdfPagesModificationScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/pdfPagesSelectionScaffold.dart';
import 'package:files_tools/ui/pdfViewerScaffold/pdfscaffold.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/reorder_pages_scaffold.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultPdfScaffold.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultZipScaffold.dart';

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
  static String modifyImageScaffold = ModifyImageScaffold.routeName;
  static String resultImageScaffold = ResultImageScaffold.routeName;
  // static String recent = Recent.routeName;
  // static String favourite = Favourite.routeName;
  // static String tools = Tools.routeName;
}
