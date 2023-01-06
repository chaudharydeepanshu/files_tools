import 'dart:developer';

import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/actions/extract_by_page_range.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/actions/extract_pages.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/actions/split_by_page_count.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/actions/split_by_page_numbers.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/actions/split_by_size.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';

/// Split PDF tool actions screen scaffold.
class SplitPDFToolsPage extends StatefulWidget {
  /// Defining [SplitPDFToolsPage] constructor.
  const SplitPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  /// Arguments passed when screen pushed.
  final SplitPDFToolsPageArguments arguments;

  @override
  State<SplitPDFToolsPage> createState() => _SplitPDFToolsPageState();
}

class _SplitPDFToolsPageState extends State<SplitPDFToolsPage> {
  late List<PdfPageModel> pdfPages;

  late Future<bool> initPdfPages;
  Future<bool> initPdfPagesState() async {
    Stopwatch stopwatch = Stopwatch()..start();
    pdfPages = await Utility.generatePdfPagesList(
      pdfPath: widget.arguments.file.fileUri,
    );
    log('initPdfPagesState Executed in ${stopwatch.elapsed}');
    return true;
  }

  @override
  void initState() {
    initPdfPages = initPdfPagesState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String pdfSingular = appLocale.pdf(1);
    String loadingText = appLocale.tool_Action_LoadingFileOrFiles(pdfSingular);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            getAppBarTitleForActionType(
              actionType: widget.arguments.actionType,
              context: context,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<bool>(
          future: initPdfPages, // async work
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Loading(
                  loadingText: loadingText,
                );
              case ConnectionState.none:
                return Loading(
                  loadingText: loadingText,
                );
              case ConnectionState.active:
                return Loading(
                  loadingText: loadingText,
                );
              case ConnectionState.done:
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return ShowError(
                    taskMessage: 'Sorry, failed to process the pdf.',
                    errorMessage: snapshot.error.toString(),
                    errorStackTrace: snapshot.stackTrace,
                    allowBack: true,
                  );
                } else if (pdfPages.isEmpty) {
                  return ShowError(
                    taskMessage: 'Sorry, failed to process the pdf.',
                    errorMessage: 'PDF page count is null',
                    errorStackTrace: StackTrace.current,
                    allowBack: true,
                  );
                } else {
                  return SplitPDFToolsBody(
                    actionType: widget.arguments.actionType,
                    file: widget.arguments.file,
                    pdfPages: pdfPages,
                  );
                }
            }
          },
        ),
      ),
    );
  }
}

/// Takes [SplitPDFToolsPage] arguments passed when screen pushed.
class SplitPDFToolsPageArguments {
  /// Defining [SplitPDFToolsPageArguments] constructor.
  SplitPDFToolsPageArguments({required this.actionType, required this.file});

  /// Takes action type.
  final ToolAction actionType;

  /// Takes input file.
  final InputFileModel file;
}

/// [SplitPDFToolsPage] screen scaffold body.
class SplitPDFToolsBody extends StatelessWidget {
  /// Defining [SplitPDFToolsBody] constructor.
  const SplitPDFToolsBody({
    Key? key,
    required this.actionType,
    required this.file,
    required this.pdfPages,
  }) : super(key: key);

  /// Takes action type.
  final ToolAction actionType;

  /// Takes input file.
  final InputFileModel file;

  /// Takes list of model of PDF pages.
  final List<PdfPageModel> pdfPages;

  @override
  Widget build(BuildContext context) {
    if (actionType == ToolAction.extractPdfByPageSelection) {
      return ExtractByPageSelection(pdfPages: pdfPages, file: file);
    } else if (actionType == ToolAction.splitPdfByPageCount) {
      return SplitByPageCount(pdfPageCount: pdfPages.length, file: file);
    } else if (actionType == ToolAction.splitPdfByByteSize) {
      return SplitBySize(pdfPageCount: pdfPages.length, file: file);
    } else if (actionType == ToolAction.splitPdfByPageNumbers) {
      return SplitByPageNumbers(pdfPageCount: pdfPages.length, file: file);
    } else if (actionType == ToolAction.extractPdfByPageRange) {
      return ExtractByPageRange(pdfPageCount: pdfPages.length, file: file);
    } else {
      return Container();
    }
  }
}

/// For getting [SplitPDFToolsPage] screen scaffold app bar text.
String getAppBarTitleForActionType({
  required final ToolAction actionType,
  required final BuildContext context,
}) {
  AppLocale appLocale = AppLocale.of(context);
  String actionSuccessful = appLocale.tool_Action_ProcessingScreen_Successful;
  String selectPagesToExtract =
      appLocale.tool_Split_WithSelectPages_ScreenTitle;
  String providePageInterval =
      appLocale.tool_Split_WithPageInterval_ScreenTitle;
  String provideSize = appLocale.tool_Split_WithSize_ScreenTitle;
  String providePageNumbers = appLocale.tool_Split_WithPageNumbers_ScreenTitle;
  String providePageRanges = appLocale.tool_Split_WithPageRanges_ScreenTitle;
  String providePageRange = appLocale.tool_Split_WithPageRange_ScreenTitle;
  String title = actionSuccessful;
  if (actionType == ToolAction.extractPdfByPageSelection) {
    title = selectPagesToExtract;
  } else if (actionType == ToolAction.splitPdfByPageCount) {
    title = providePageInterval;
  } else if (actionType == ToolAction.splitPdfByByteSize) {
    title = provideSize;
  } else if (actionType == ToolAction.splitPdfByPageNumbers) {
    title = providePageNumbers;
  } else if (actionType == ToolAction.splitPdfByPageRanges) {
    title = providePageRanges;
  } else if (actionType == ToolAction.extractPdfByPageRange) {
    title = providePageRange;
  }
  return title;
}
