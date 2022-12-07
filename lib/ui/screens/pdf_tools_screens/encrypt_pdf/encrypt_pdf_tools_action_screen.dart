import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/encrypt_pdf/actions/encrypt_pdf.dart';
import 'package:flutter/material.dart';

/// Encrypt PDF tool actions screen scaffold.
class EncryptPDFToolsPage extends StatefulWidget {
  /// Defining [EncryptPDFToolsPage] constructor.
  const EncryptPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  /// Arguments passed when screen pushed.
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
          title: Text(
            getAppBarTitleForActionType(
              actionType: widget.arguments.actionType,
            ),
          ),
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

/// Takes [EncryptPDFToolsPage] arguments passed when screen pushed.
class EncryptPDFToolsPageArguments {
  /// Defining [EncryptPDFToolsPageArguments] constructor.
  EncryptPDFToolsPageArguments({required this.actionType, required this.file});

  /// Takes action type.
  final ToolAction actionType;

  /// Takes input file.
  final InputFileModel file;
}

/// [EncryptPDFToolsPage] screen scaffold body.
class EncryptPDFToolsBody extends StatelessWidget {
  /// Defining [EncryptPDFToolsBody] constructor.
  const EncryptPDFToolsBody({
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
    if (actionType == ToolAction.encryptPdf) {
      return EncryptPDF(file: file);
    } else {
      return Container();
    }
  }
}

/// For getting [EncryptPDFToolsPage] screen scaffold app bar text.
String getAppBarTitleForActionType({required final ToolAction actionType}) {
  String title = 'Action Successful';
  if (actionType == ToolAction.encryptPdf) {
    title = 'Select Encryption Config';
  }
  return title;
}
