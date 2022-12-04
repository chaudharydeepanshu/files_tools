import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/image_tools_screens/compress_image/tools/compress_image.dart';
import 'package:flutter/material.dart';

class CompressImageToolsPage extends StatefulWidget {
  const CompressImageToolsPage({Key? key, required this.arguments})
      : super(key: key);

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

class CompressImageToolsPageArguments {
  CompressImageToolsPageArguments({
    required this.actionType,
    required this.files,
  });
  final ToolAction actionType;
  final List<InputFileModel> files;
}

class CompressImageToolsBody extends StatelessWidget {
  const CompressImageToolsBody({
    Key? key,
    required this.actionType,
    required this.files,
  }) : super(key: key);

  final ToolAction actionType;
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

String getAppBarTitleForActionType({required ToolAction actionType}) {
  String title = 'Action Successful';
  if (actionType == ToolAction.compressImages) {
    title = 'Select Compress Config';
  }
  return title;
}
