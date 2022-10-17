import 'dart:developer';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/components/tools_error_body.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/components/tools_processing_body.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/modify_pdf/tools/rotate_delete_reorder_pages.dart';
import 'package:files_tools/utils/get_pdf_bitmaps.dart';
import 'package:flutter/material.dart';

class ModifyPDFToolsPage extends StatefulWidget {
  const ModifyPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  final ModifyPDFToolsPageArguments arguments;

  @override
  State<ModifyPDFToolsPage> createState() => _ModifyPDFToolsPageState();
}

class _ModifyPDFToolsPageState extends State<ModifyPDFToolsPage> {
  List<PdfPageModel> pdfPages = [];

  late Future<bool> initPdfPages;
  Future<bool> initPdfPagesState() async {
    Stopwatch stopwatch = Stopwatch()..start();
    pdfPages =
        await generatePdfPagesList(pdfPath: widget.arguments.file.fileUri);
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
          title: Text(getAppBarTitleForActionType(
              actionType: widget.arguments.actionType)),
          centerTitle: true,
        ),
        body: FutureBuilder<bool>(
          future: initPdfPages, // async work
          builder: (context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const ProcessingBody();
              default:
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return const ErrorBody();
                } else if (pdfPages.isEmpty) {
                  log(snapshot.error.toString());
                  return const ErrorBody();
                } else {
                  return ModifyPDFToolsBody(
                      actionType: widget.arguments.actionType,
                      file: widget.arguments.file,
                      pdfPages: pdfPages);
                }
            }
          },
        ),
      ),
    );
  }
}

class ModifyPDFToolsPageArguments {
  final ToolsActions actionType;
  final InputFileModel file;

  ModifyPDFToolsPageArguments({required this.actionType, required this.file});
}

class ModifyPDFToolsBody extends StatelessWidget {
  const ModifyPDFToolsBody(
      {Key? key,
      required this.actionType,
      required this.file,
      required this.pdfPages})
      : super(key: key);

  final ToolsActions actionType;
  final InputFileModel file;
  final List<PdfPageModel> pdfPages;

  @override
  Widget build(BuildContext context) {
    if (actionType == ToolsActions.modify) {
      return RotateDeleteReorderPages(pdfPages: pdfPages, file: file);
    } else {
      return Container();
    }
  }
}

String getAppBarTitleForActionType({required ToolsActions actionType}) {
  String title = "Action Successful";
  if (actionType == ToolsActions.modify) {
    title = "Rotate, Delete & Reorder";
  }
  return title;
}
