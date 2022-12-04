import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/decrypt_pdf/tools/decrypt_pdf.dart';
import 'package:flutter/material.dart';

class DecryptPDFToolsPage extends StatefulWidget {
  const DecryptPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  final DecryptPDFToolsPageArguments arguments;

  @override
  State<DecryptPDFToolsPage> createState() => _DecryptPDFToolsPageState();
}

class _DecryptPDFToolsPageState extends State<DecryptPDFToolsPage> {
  @override
  void initState() {
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
        body: DecryptPDFToolsBody(
          actionType: widget.arguments.actionType,
          file: widget.arguments.file,
        ),
      ),
    );
  }
}

class DecryptPDFToolsPageArguments {
  DecryptPDFToolsPageArguments({required this.actionType, required this.file});
  final ToolAction actionType;
  final InputFileModel file;
}

class DecryptPDFToolsBody extends StatelessWidget {
  const DecryptPDFToolsBody({
    Key? key,
    required this.actionType,
    required this.file,
  }) : super(key: key);

  final ToolAction actionType;
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    if (actionType == ToolAction.decryptPdf) {
      return DecryptPDF(file: file);
    } else {
      return Container();
    }
  }
}

String getAppBarTitleForActionType({required ToolAction actionType}) {
  String title = 'Action Successful';
  if (actionType == ToolAction.decryptPdf) {
    title = 'Decryption Config';
  }
  return title;
}
