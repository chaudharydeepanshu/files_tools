import 'dart:developer';

import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/watermark_pdf/actions/watermark_pdf.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';

/// Watermark PDF tool actions screen scaffold.
class WatermarkPDFToolsPage extends StatefulWidget {
  /// Defining [WatermarkPDFToolsPage] constructor.
  const WatermarkPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  /// Arguments passed when screen pushed.
  final WatermarkPDFToolsPageArguments arguments;

  @override
  State<WatermarkPDFToolsPage> createState() => _WatermarkPDFToolsPageState();
}

class _WatermarkPDFToolsPageState extends State<WatermarkPDFToolsPage> {
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
                  return WatermarkPDFToolsBody(
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

/// Takes [WatermarkPDFToolsPage] arguments passed when screen pushed.
class WatermarkPDFToolsPageArguments {
  /// Defining [WatermarkPDFToolsPageArguments] constructor.
  WatermarkPDFToolsPageArguments({
    required this.actionType,
    required this.file,
  });

  /// Takes action type.
  final ToolAction actionType;

  /// Takes input file.
  final InputFileModel file;
}

/// [WatermarkPDFToolsPage] screen scaffold body.
class WatermarkPDFToolsBody extends StatelessWidget {
  /// Defining [WatermarkPDFToolsPage] constructor.
  const WatermarkPDFToolsBody({
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
    if (actionType == ToolAction.watermarkPdf) {
      return WatermarkPDF(pdfPageCount: pdfPageCount, file: file);
    } else {
      return Container();
    }
  }
}

/// For getting [WatermarkPDFToolsPage] screen scaffold app bar text.
String getAppBarTitleForActionType({
  required final ToolAction actionType,
  required final BuildContext context,
}) {
  AppLocale appLocale = AppLocale.of(context);
  String actionSuccessful = appLocale.tool_Action_ProcessingScreen_Successful;
  String configureWatermark = appLocale.tool_Watermark_ConfigureWatermark;
  String title = actionSuccessful;
  if (actionType == ToolAction.watermarkPdf) {
    title = configureWatermark;
  }
  return title;
}
