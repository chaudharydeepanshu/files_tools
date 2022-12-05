import 'dart:developer';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/modify_pdf/tools/rotate_delete_reorder_pages.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';

class ModifyPDFToolsPage extends StatefulWidget {
  const ModifyPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

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

class ModifyPDFToolsPageArguments {
  ModifyPDFToolsPageArguments({required this.actionType, required this.file});
  final ToolAction actionType;
  final InputFileModel file;
}

class ModifyPDFToolsBody extends StatelessWidget {
  const ModifyPDFToolsBody({
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
    if (actionType == ToolAction.modifyPdf) {
      return RotateDeleteReorderPages(pdfPages: pdfPages, file: file);
    } else {
      return Container();
    }
  }
}

String getAppBarTitleForActionType({required ToolAction actionType}) {
  String title = 'Action Successful';
  if (actionType == ToolAction.modifyPdf) {
    title = 'Rotate, Delete & Reorder';
  }
  return title;
}
