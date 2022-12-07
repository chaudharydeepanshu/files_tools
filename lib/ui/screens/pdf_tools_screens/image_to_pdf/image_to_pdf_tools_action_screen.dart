import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/image_to_pdf/actions/image_to_pdf.dart';
import 'package:flutter/material.dart';

/// Converting image to PDF tool actions screen scaffold.
class ImageToPDFToolsPage extends StatefulWidget {
  /// Defining [ImageToPDFToolsPage] constructor.
  const ImageToPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  /// Arguments passed when screen pushed.
  final ImageToPDFToolsPageArguments arguments;

  @override
  State<ImageToPDFToolsPage> createState() => _ImageToPDFToolsPageState();
}

class _ImageToPDFToolsPageState extends State<ImageToPDFToolsPage> {
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
        body: ImageToPDFToolsBody(
          actionType: widget.arguments.actionType,
          files: widget.arguments.files,
        ),
      ),
    );
  }
}

/// Takes [ImageToPDFToolsPage] arguments passed when screen pushed.
class ImageToPDFToolsPageArguments {
  /// Defining [ImageToPDFToolsPageArguments] constructor.
  ImageToPDFToolsPageArguments({required this.actionType, required this.files});

  /// Takes action type.
  final ToolAction actionType;

  /// Takes list of model of PDF pages.
  final List<InputFileModel> files;
}

/// [ImageToPDFToolsPage] screen scaffold body.
class ImageToPDFToolsBody extends StatelessWidget {
  /// Defining [ImageToPDFToolsBody] constructor.
  const ImageToPDFToolsBody({
    Key? key,
    required this.actionType,
    required this.files,
  }) : super(key: key);

  /// Takes action type.
  final ToolAction actionType;

  /// Takes list of model of PDF pages.
  final List<InputFileModel> files;

  @override
  Widget build(BuildContext context) {
    if (actionType == ToolAction.imageToPdf) {
      return ImageToPDF(files: files);
    } else {
      return Container();
    }
  }
}

/// For getting [ImageToPDFToolsPage] screen scaffold app bar text.
String getAppBarTitleForActionType({required final ToolAction actionType}) {
  String title = 'Action Successful';
  if (actionType == ToolAction.imageToPdf) {
    title = 'Prepare Images For PDF';
  }
  return title;
}
