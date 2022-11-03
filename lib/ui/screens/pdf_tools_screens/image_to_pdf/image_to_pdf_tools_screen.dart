import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/image_to_pdf/tools/image_to_pdf.dart';
import 'package:flutter/material.dart';

class ImageToPDFToolsPage extends StatefulWidget {
  const ImageToPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

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
          title: Text(getAppBarTitleForActionType(
              actionType: widget.arguments.actionType)),
          centerTitle: true,
        ),
        body: ImageToPDFToolsBody(
            actionType: widget.arguments.actionType,
            files: widget.arguments.files),
      ),
    );
  }
}

class ImageToPDFToolsPageArguments {
  final ToolsActions actionType;
  final List<InputFileModel> files;

  ImageToPDFToolsPageArguments({required this.actionType, required this.files});
}

class ImageToPDFToolsBody extends StatelessWidget {
  const ImageToPDFToolsBody(
      {Key? key, required this.actionType, required this.files})
      : super(key: key);

  final ToolsActions actionType;
  final List<InputFileModel> files;

  @override
  Widget build(BuildContext context) {
    if (actionType == ToolsActions.imageToPDF) {
      return ImageToPDF(files: files);
    } else {
      return Container();
    }
  }
}

String getAppBarTitleForActionType({required ToolsActions actionType}) {
  String title = "Action Successful";
  if (actionType == ToolsActions.imageToPDF) {
    title = "Edit Images";
  }
  return title;
}
