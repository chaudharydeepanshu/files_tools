import 'dart:developer';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/tools/extract_by_page_range.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/tools/extract_pages.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/tools/split_by_page_count.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/tools/split_by_page_numbers.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/tools/split_by_page_ranges.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/tools/split_by_size.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';

class SplitPDFToolsPage extends StatefulWidget {
  const SplitPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

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
        pdfPath: widget.arguments.file.fileUri);
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
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<bool>(
          future: initPdfPages, // async work
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Loading(
                  loadingText: 'Getting pdf info please wait ...',
                );
              default:
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

class SplitPDFToolsPageArguments {
  SplitPDFToolsPageArguments({required this.actionType, required this.file});
  final ToolAction actionType;
  final InputFileModel file;
}

class SplitPDFToolsBody extends StatelessWidget {
  const SplitPDFToolsBody({
    Key? key,
    required this.actionType,
    required this.file,
    required this.pdfPages,
  }) : super(key: key);

  final ToolAction actionType;
  final InputFileModel file;
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
    } else if (actionType == ToolAction.splitPdfByPageRanges) {
      return SplitByPageRanges(pdfPageCount: pdfPages.length, file: file);
    } else {
      return Container();
    }
  }
}

String getAppBarTitleForActionType({required ToolAction actionType}) {
  String title = 'Action Successful';
  if (actionType == ToolAction.extractPdfByPageSelection) {
    title = 'Select Pages To Extract';
  } else if (actionType == ToolAction.splitPdfByPageCount) {
    title = 'Provide Page Count';
  } else if (actionType == ToolAction.splitPdfByByteSize) {
    title = 'Provide Size';
  } else if (actionType == ToolAction.splitPdfByPageNumbers) {
    title = 'Provide Page Numbers';
  } else if (actionType == ToolAction.splitPdfByPageRanges) {
    title = 'Provide Page Ranges';
  } else if (actionType == ToolAction.extractPdfByPageRange) {
    title = 'Provide Page Range';
  }
  return title;
}
