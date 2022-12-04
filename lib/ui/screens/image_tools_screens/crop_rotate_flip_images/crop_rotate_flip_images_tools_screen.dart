import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/image_tools_screens/crop_rotate_flip_images/tools/crop_rotate_flip_images.dart';
import 'package:flutter/material.dart';

class CropRotateFlipImagesToolsPage extends StatefulWidget {
  const CropRotateFlipImagesToolsPage({Key? key, required this.arguments})
      : super(key: key);

  final CropRotateFlipImagesToolsPageArguments arguments;

  @override
  State<CropRotateFlipImagesToolsPage> createState() =>
      _CropRotateFlipImagesToolsPageState();
}

class _CropRotateFlipImagesToolsPageState
    extends State<CropRotateFlipImagesToolsPage> {
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

class CropRotateFlipImagesToolsPageArguments {
  CropRotateFlipImagesToolsPageArguments({
    required this.actionType,
    required this.files,
  });
  final ToolAction actionType;
  final List<InputFileModel> files;
}

class ModifyImageToolsBody extends StatelessWidget {
  const ModifyImageToolsBody({
    Key? key,
    required this.actionType,
    required this.files,
  }) : super(key: key);

  final ToolAction actionType;
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

String getAppBarTitleForActionType({required ToolAction actionType}) {
  String title = 'Action Successful';
  if (actionType == ToolAction.cropRotateFlipImages) {
    title = 'Edit Images';
  }
  return title;
}
