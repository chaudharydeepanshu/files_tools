import 'dart:developer';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/components/tools_error_body.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/components/tools_processing_body.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/encrypt_decrypt_pdf/tools/encrypt_pdf.dart';
import 'package:files_tools/utils/get_pdf_bitmaps.dart';
import 'package:flutter/material.dart';

class EncryptPDFToolsPage extends StatefulWidget {
  const EncryptPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  final EncryptPDFToolsPageArguments arguments;

  @override
  State<EncryptPDFToolsPage> createState() => _EncryptPDFToolsPageState();
}

class _EncryptPDFToolsPageState extends State<EncryptPDFToolsPage> {
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
                  return EncryptPDFToolsBody(
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

class EncryptPDFToolsPageArguments {
  final ToolsActions actionType;
  final InputFileModel file;

  EncryptPDFToolsPageArguments({required this.actionType, required this.file});
}

class EncryptPDFToolsBody extends StatelessWidget {
  const EncryptPDFToolsBody(
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
    if (actionType == ToolsActions.encrypt) {
      return EncryptPDF(pdfPageCount: pdfPageCount, file: file);
    } else {
      return Container();
    }
  }
}

String getAppBarTitleForActionType({required ToolsActions actionType}) {
  String title = "Action Successful";
  if (actionType == ToolsActions.encrypt) {
    title = "Select Encryption Config";
  }
  return title;
}
