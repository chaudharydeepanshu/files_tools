import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/decrypt_pdf/actions/decrypt_pdf.dart';
import 'package:flutter/material.dart';

/// Decrypt PDF tool actions screen scaffold.
class DecryptPDFToolsPage extends StatefulWidget {
  /// Defining [DecryptPDFToolsPage] constructor.
  const DecryptPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  /// Arguments passed when screen pushed.
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

/// Takes [DecryptPDFToolsPage] arguments passed when screen pushed.
class DecryptPDFToolsPageArguments {
  /// Defining [DecryptPDFToolsPageArguments] constructor.
  DecryptPDFToolsPageArguments({required this.actionType, required this.file});

  /// Takes action type.
  final ToolAction actionType;

  /// Takes input file.
  final InputFileModel file;
}

/// [DecryptPDFToolsPage] screen scaffold body.
class DecryptPDFToolsBody extends StatelessWidget {
  /// Defining [DecryptPDFToolsBody] constructor.
  const DecryptPDFToolsBody({
    Key? key,
    required this.actionType,
    required this.file,
  }) : super(key: key);

  /// Takes action type.
  final ToolAction actionType;

  /// Takes input file.
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

/// For getting [DecryptPDFToolsPage] screen scaffold app bar text.
String getAppBarTitleForActionType({required ToolAction actionType}) {
  String title = 'Action Successful';
  if (actionType == ToolAction.decryptPdf) {
    title = 'Decryption Config';
  }
  return title;
}
