import 'dart:developer';

import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/compress_pdf/actions/compress_pdf.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';

/// Compress PDF tool actions screen scaffold.
class CompressPDFToolsPage extends StatefulWidget {
  /// Defining [CompressPDFToolsPage] constructor.
  const CompressPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  /// Arguments passed when screen pushed.
  final CompressPDFToolsPageArguments arguments;

  @override
  State<CompressPDFToolsPage> createState() => _CompressPDFToolsPageState();
}

class _CompressPDFToolsPageState extends State<CompressPDFToolsPage> {
  late Future<bool> initPageCount;
  late int pdfPageCount;

  Future<bool> initPdfPageCount() async {
    pdfPageCount =
        await Utility.getPdfPageCount(pdfPath: widget.arguments.file.fileUri);
    return true;
  }

  @override
  void initState() {
    initPageCount = initPdfPageCount();
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
          future: initPageCount, // async work
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
                } else {
                  return CompressPDFToolsBody(
                    actionType: widget.arguments.actionType,
                    file: widget.arguments.file,
                    pdfPageCount: pdfPageCount,
                  );
                }
            }
          },
        ),
      ),
    );
  }
}

/// Takes [CompressPDFToolsPage] arguments passed when screen pushed.
class CompressPDFToolsPageArguments {
  /// Defining [CompressPDFToolsPageArguments] constructor.
  CompressPDFToolsPageArguments({required this.actionType, required this.file});

  /// Takes action type.
  final ToolAction actionType;

  /// Takes input file.
  final InputFileModel file;
}

/// [CompressPDFToolsPage] screen scaffold body.
class CompressPDFToolsBody extends StatelessWidget {
  /// Defining [CompressPDFToolsBody] constructor.
  const CompressPDFToolsBody({
    Key? key,
    required this.actionType,
    required this.file,
    required this.pdfPageCount,
  }) : super(key: key);

  /// Takes action type.
  final ToolAction actionType;

  /// Takes input file.
  final InputFileModel file;

  /// Takes PDF file total page number.
  final int pdfPageCount;

  @override
  Widget build(BuildContext context) {
    if (actionType == ToolAction.compressPdf) {
      return CompressPDF(pdfPageCount: pdfPageCount, file: file);
    } else {
      return Container();
    }
  }
}

/// For getting [CompressPDFToolsPage] screen scaffold app bar text.
String getAppBarTitleForActionType({
  required final ToolAction actionType,
  required final BuildContext context,
}) {
  AppLocale appLocale = AppLocale.of(context);
  String actionSuccessful = appLocale.tool_Action_ProcessingScreen_Successful;
  String configureCompression = appLocale.tool_Compress_ConfigureCompression;
  String title = actionSuccessful;
  if (actionType == ToolAction.compressPdf) {
    title = configureCompression;
  }
  return title;
}
