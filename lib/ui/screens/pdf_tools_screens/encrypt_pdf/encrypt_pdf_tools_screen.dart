import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/encrypt_pdf/tools/encrypt_pdf.dart';
import 'package:flutter/material.dart';

class EncryptPDFToolsPage extends StatefulWidget {
  const EncryptPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  final EncryptPDFToolsPageArguments arguments;

  @override
  State<EncryptPDFToolsPage> createState() => _EncryptPDFToolsPageState();
}

class _EncryptPDFToolsPageState extends State<EncryptPDFToolsPage> {
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
          title: Text(getAppBarTitleForActionType(
              actionType: widget.arguments.actionType)),
          centerTitle: true,
        ),
        body: EncryptPDFToolsBody(
          actionType: widget.arguments.actionType,
          file: widget.arguments.file,
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
      {Key? key, required this.actionType, required this.file})
      : super(key: key);

  final ToolsActions actionType;
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    if (actionType == ToolsActions.encryptPdf) {
      return EncryptPDF(file: file);
    } else {
      return Container();
    }
  }
}

String getAppBarTitleForActionType({required ToolsActions actionType}) {
  String title = "Action Successful";
  if (actionType == ToolsActions.encryptPdf) {
    title = "Select Encryption Config";
  }
  return title;
}
