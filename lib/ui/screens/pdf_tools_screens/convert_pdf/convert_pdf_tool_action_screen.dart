import 'dart:developer';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/convert_pdf/actions/convert_to_image.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';

/// Convert PDF tool actions screen scaffold.
class ConvertPDFToolsPage extends StatefulWidget {
  /// Defining [ConvertPDFToolsPage] constructor.
  const ConvertPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  /// Arguments passed when screen pushed.
  final ConvertPDFToolsPageArguments arguments;

  @override
  State<ConvertPDFToolsPage> createState() => _ConvertPDFToolsPageState();
}

class _ConvertPDFToolsPageState extends State<ConvertPDFToolsPage> {
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
              case ConnectionState.none:
                return const Loading(
                  loadingText: 'Getting pdf info please wait ...',
                );
              case ConnectionState.active:
                return const Loading(
                  loadingText: 'Getting pdf info please wait ...',
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
                    errorStackTrace: snapshot.stackTrace,
                    allowBack: true,
                  );
                } else {
                  return ConvertPDFToolsBody(
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

/// Takes [ConvertPDFToolsPage] arguments passed when screen pushed.
class ConvertPDFToolsPageArguments {
  /// Defining [ConvertPDFToolsPageArguments] constructor.
  ConvertPDFToolsPageArguments({required this.actionType, required this.file});

  /// Takes action type.
  final ToolAction actionType;

  /// Takes input file.
  final InputFileModel file;
}

/// [ConvertPDFToolsPage] screen scaffold body.
class ConvertPDFToolsBody extends StatelessWidget {
  /// Defining [ConvertPDFToolsBody] constructor.
  const ConvertPDFToolsBody({
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
    if (actionType == ToolAction.convertPdfToImage) {
      return ConvertToImage(pdfPages: pdfPages, file: file);
    } else {
      return Container();
    }
  }
}

/// For getting [ConvertPDFToolsPage] screen scaffold app bar text.
String getAppBarTitleForActionType({required ToolAction actionType}) {
  String title = 'Action Successful';
  if (actionType == ToolAction.convertPdfToImage) {
    title = 'Select Pages To Convert';
  }
  return title;
}
