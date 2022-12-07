import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/image_tools_screens/crop_rotate_flip_images/actions/crop_rotate_flip_images.dart';
import 'package:flutter/material.dart';

/// Modify images tool actions screen scaffold.
class ModifyImagesToolsPage extends StatefulWidget {
  /// Defining [ModifyImagesToolsPage] constructor.
  const ModifyImagesToolsPage({Key? key, required this.arguments})
      : super(key: key);

  /// Arguments passed when screen pushed.
  final ModifyImagesToolsPageArguments arguments;

  @override
  State<ModifyImagesToolsPage> createState() => _ModifyImagesToolsPageState();
}

class _ModifyImagesToolsPageState extends State<ModifyImagesToolsPage> {
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
        body: ModifyImageToolsBody(
          actionType: widget.arguments.actionType,
          files: widget.arguments.files,
        ),
      ),
    );
  }
}

/// Takes [ModifyImagesToolsPage] arguments passed when screen pushed.
class ModifyImagesToolsPageArguments {
  /// Defining [ModifyImagesToolsPageArguments] constructor.
  ModifyImagesToolsPageArguments({
    required this.actionType,
    required this.files,
  });

  /// Takes action type.
  final ToolAction actionType;

  /// Takes input files.
  final List<InputFileModel> files;
}

/// [ModifyImagesToolsPage] screen scaffold body.
class ModifyImageToolsBody extends StatelessWidget {
  /// Defining [ModifyImageToolsBody] constructor.
  const ModifyImageToolsBody({
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
    if (actionType == ToolAction.cropRotateFlipImages) {
      return CropRotateFlipImages(files: files);
    } else {
      return Container();
    }
  }
}

/// For getting [ModifyImagesToolsPage] screen scaffold app bar text.
String getAppBarTitleForActionType({required ToolAction actionType}) {
  String title = 'Action Successful';
  if (actionType == ToolAction.cropRotateFlipImages) {
    title = 'Edit Images';
  }
  return title;
}
