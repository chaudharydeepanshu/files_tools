import 'dart:developer';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/components/tools_error_body.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/components/tools_processing_body.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/convert_pdf/tools/convert_to_image.dart';
import 'package:files_tools/utils/get_pdf_bitmaps.dart';
import 'package:flutter/material.dart';

class ConvertPDFToolsPage extends StatefulWidget {
  const ConvertPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  final ConvertPDFToolsPageArguments arguments;

  @override
  State<ConvertPDFToolsPage> createState() => _ConvertPDFToolsPageState();
}

class _ConvertPDFToolsPageState extends State<ConvertPDFToolsPage> {
  List<PdfPageModel> pdfPages = [];

  late Future<bool> initPdfPages;
  Future<bool> initPdfPagesState() async {
    Stopwatch stopwatch = Stopwatch()..start();
    pdfPages = await generatePdfPagesList(
        pdfUri: widget.arguments.file.fileUri, pdfPath: null);
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
                  return ConvertPDFToolsBody(
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

class ConvertPDFToolsPageArguments {
  final ToolsActions actionType;
  final InputFileModel file;

  ConvertPDFToolsPageArguments({required this.actionType, required this.file});
}

class ConvertPDFToolsBody extends StatelessWidget {
  const ConvertPDFToolsBody(
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
    if (actionType == ToolsActions.convertToImage) {
      return ConvertToImage(pdfPages: pdfPages, file: file);
    } else {
      return Container();
    }
  }
}

String getAppBarTitleForActionType({required ToolsActions actionType}) {
  String title = "Action Successful";
  if (actionType == ToolsActions.convertToImage) {
    title = "Select Pages";
  }
  return title;
}
