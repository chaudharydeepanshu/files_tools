import 'dart:developer';

import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/modify_pdf/actions/rotate_delete_reorder_pages.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';

/// Modify PDF tool actions screen scaffold.
class ModifyPDFToolsPage extends StatefulWidget {
  /// Defining [ModifyPDFToolsPage] constructor.
  const ModifyPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  /// Arguments passed when screen pushed.
  final ModifyPDFToolsPageArguments arguments;

  @override
  State<ModifyPDFToolsPage> createState() => _ModifyPDFToolsPageState();
}

class _ModifyPDFToolsPageState extends State<ModifyPDFToolsPage> {
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
                  return ModifyPDFToolsBody(
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

/// Takes [ModifyPDFToolsPage] arguments passed when screen pushed.
class ModifyPDFToolsPageArguments {
  /// Defining [ModifyPDFToolsPageArguments] constructor.
  ModifyPDFToolsPageArguments({required this.actionType, required this.file});

  /// Takes action type.
  final ToolAction actionType;

  /// Takes input file.
  final InputFileModel file;
}

/// [ModifyPDFToolsPage] screen scaffold body.
class ModifyPDFToolsBody extends StatelessWidget {
  /// Defining [ModifyPDFToolsBody] constructor.
  const ModifyPDFToolsBody({
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
    if (actionType == ToolAction.modifyPdf) {
      return RotateDeleteReorderPages(pdfPages: pdfPages, file: file);
    } else {
      return Container();
    }
  }
}

/// For getting [ModifyPDFToolsPage] screen scaffold app bar text.
String getAppBarTitleForActionType({
  required final ToolAction actionType,
  required final BuildContext context,
}) {
  AppLocale appLocale = AppLocale.of(context);
  String pdfSingular = appLocale.pdf(1);
  String actionSuccessful = appLocale.tool_Action_ProcessingScreen_Successful;
  String rotateDeleteReorderPdf =
      appLocale.tool_Modify_RotateDeleteReorderFileOrFilesPages(pdfSingular);
  String title = actionSuccessful;
  if (actionType == ToolAction.modifyPdf) {
    title = rotateDeleteReorderPdf;
  }
  return title;
}
