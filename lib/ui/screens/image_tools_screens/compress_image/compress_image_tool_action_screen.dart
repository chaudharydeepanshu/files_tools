import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/image_tools_screens/compress_image/actions/compress_image.dart';
import 'package:flutter/material.dart';

/// Compress image tool actions screen scaffold.
class CompressImageToolsPage extends StatefulWidget {
  /// Defining [CompressImageToolsPage] constructor.
  const CompressImageToolsPage({Key? key, required this.arguments})
      : super(key: key);

  /// Arguments passed when screen pushed.
  final CompressImageToolsPageArguments arguments;

  @override
  State<CompressImageToolsPage> createState() => _CompressPDFToolsPageState();
}

class _CompressPDFToolsPageState extends State<CompressImageToolsPage> {
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
        body: CompressImageToolsBody(
          actionType: widget.arguments.actionType,
          files: widget.arguments.files,
        ),
      ),
    );
  }
}

/// Takes [CompressImageToolsPage] arguments passed when screen pushed.
class CompressImageToolsPageArguments {
  /// Defining [CompressImageToolsPageArguments] constructor.
  CompressImageToolsPageArguments({
    required this.actionType,
    required this.files,
  });

  /// Takes action type.
  final ToolAction actionType;

  /// Takes input files.
  final List<InputFileModel> files;
}

/// [CompressImageToolsPage] screen scaffold body.
class CompressImageToolsBody extends StatelessWidget {
  /// Defining [CompressImageToolsBody] constructor.
  const CompressImageToolsBody({
    Key? key,
    required this.actionType,
    required this.files,
  }) : super(key: key);

  /// Takes action type.
  final ToolAction actionType;

  /// Takes input files.
  final List<InputFileModel> files;

  @override
  Widget build(BuildContext context) {
    if (actionType == ToolAction.compressImages) {
      return CompressImage(files: files);
    } else {
      return Container();
    }
  }
}

/// For getting [CompressImageToolsPage] screen scaffold app bar text.
String getAppBarTitleForActionType({required ToolAction actionType}) {
  String title = 'Action Successful';
  if (actionType == ToolAction.compressImages) {
    title = 'Select Compress Config';
  }
  return title;
}
