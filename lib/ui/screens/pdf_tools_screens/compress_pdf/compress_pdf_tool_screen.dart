import 'dart:developer';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/compress_pdf/tools/compress_pdf.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';

class CompressPDFToolsPage extends StatefulWidget {
  const CompressPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

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
          future: initPageCount, // async work
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

class CompressPDFToolsPageArguments {
  CompressPDFToolsPageArguments({required this.actionType, required this.file});
  final ToolAction actionType;
  final InputFileModel file;
}

class CompressPDFToolsBody extends StatelessWidget {
  const CompressPDFToolsBody({
    Key? key,
    required this.actionType,
    required this.file,
    required this.pdfPageCount,
  }) : super(key: key);

  final ToolAction actionType;
  final InputFileModel file;
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

String getAppBarTitleForActionType({required ToolAction actionType}) {
  String title = 'Action Successful';
  if (actionType == ToolAction.compressPdf) {
    title = 'Select Compress Config';
  }
  return title;
}
