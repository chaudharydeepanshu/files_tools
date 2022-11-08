import 'dart:developer';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/components/tools_error_body.dart';
import 'package:files_tools/ui/screens/components/tools_processing_body.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/watermark_pdf/tools/watermark_pdf.dart';
import 'package:files_tools/utils/get_pdf_bitmaps.dart';
import 'package:flutter/material.dart';

class WatermarkPDFToolsPage extends StatefulWidget {
  const WatermarkPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  final WatermarkPDFToolsPageArguments arguments;

  @override
  State<WatermarkPDFToolsPage> createState() => _WatermarkPDFToolsPageState();
}

class _WatermarkPDFToolsPageState extends State<WatermarkPDFToolsPage> {
  late Future<bool> initPageCount;
  int? pdfPageCount;

  Future<bool> initPdfPageCount() async {
    pdfPageCount =
        await getPdfPageCount(pdfPath: widget.arguments.file.fileUri);
    return true;
  }

  @override
  void initState() {
    initPageCount = initPdfPageCount();
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
          future: initPageCount, // async work
          builder: (context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const ProcessingBody();
              default:
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return const ErrorBody();
                } else if (pdfPageCount == null) {
                  log(snapshot.error.toString());
                  return const ErrorBody();
                } else {
                  return WatermarkPDFToolsBody(
                      actionType: widget.arguments.actionType,
                      file: widget.arguments.file,
                      pdfPageCount: pdfPageCount!);
                }
            }
          },
        ),
      ),
    );
  }
}

class WatermarkPDFToolsPageArguments {
  final ToolsActions actionType;
  final InputFileModel file;

  WatermarkPDFToolsPageArguments(
      {required this.actionType, required this.file});
}

class WatermarkPDFToolsBody extends StatelessWidget {
  const WatermarkPDFToolsBody(
      {Key? key,
      required this.actionType,
      required this.file,
      required this.pdfPageCount})
      : super(key: key);

  final ToolsActions actionType;
  final InputFileModel file;
  final int pdfPageCount;

  @override
  Widget build(BuildContext context) {
    if (actionType == ToolsActions.watermarkPdf) {
      return WatermarkPDF(pdfPageCount: pdfPageCount, file: file);
    } else {
      return Container();
    }
  }
}

String getAppBarTitleForActionType({required ToolsActions actionType}) {
  String title = "Action Successful";
  if (actionType == ToolsActions.watermarkPdf) {
    title = "Select Watermark Config";
  }
  return title;
}
