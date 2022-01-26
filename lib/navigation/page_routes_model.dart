import 'package:files_tools/ui/functionsActionsScaffold/compress_pdf_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/decrypt_pdf_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/encrypt_pdf_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/extract_all_pdf_pages_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/fixed_range_pdf_pages_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/modify_image_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/pdf_to_images_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/compress_image.dart';
import 'package:files_tools/ui/functionsActionsScaffold/custom_range_pdf_pages_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/images_to_pdf_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/merge_pdf_pages_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/watermark_pdf.dart';
import 'package:files_tools/ui/functionsResultsScaffold/result_image_scaffold.dart';
import 'package:files_tools/ui/topLevelPagesScaffold/main_page_scaffold.dart';
import 'package:files_tools/ui/functionsMainScaffold/pdf_function_pages_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/pdf_pages_modification_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/pdf_pages_selection_scaffold.dart';
import 'package:files_tools/ui/pdfViewerScaffold/pdfScaffold.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/reorder_pages_scaffold.dart';
import 'package:files_tools/ui/functionsResultsScaffold/result_pdf_scaffold.dart';
import 'package:files_tools/ui/functionsResultsScaffold/result_zip_scaffold.dart';

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
  static String compressImagesScaffold = CompressImagesScaffold.routeName;
  static String watermarkPDFPagesScaffold = WatermarkPDFPagesScaffold.routeName;
  // static String recent = Recent.routeName;
  // static String favourite = Favourite.routeName;
  // static String tools = Tools.routeName;
}
