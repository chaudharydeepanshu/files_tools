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
          title: Text(getAppBarTitleForActionType(
              actionType: widget.arguments.actionType)),
          centerTitle: true,
        ),
        body: ModifyImageToolsBody(
            actionType: widget.arguments.actionType,
            files: widget.arguments.files),
      ),
    );
  }
}

class CropRotateFlipImagesToolsPageArguments {
  final ToolsActions actionType;
  final List<InputFileModel> files;

  CropRotateFlipImagesToolsPageArguments(
      {required this.actionType, required this.files});
}

class ModifyImageToolsBody extends StatelessWidget {
  const ModifyImageToolsBody(
      {Key? key, required this.actionType, required this.files})
      : super(key: key);

  final ToolsActions actionType;
  final List<InputFileModel> files;

  @override
  Widget build(BuildContext context) {
    if (actionType == ToolsActions.rotateCropFlipImages) {
      return CropRotateFlipImages(files: files);
    } else {
      return Container();
    }
  }
}

String getAppBarTitleForActionType({required ToolsActions actionType}) {
  String title = "Action Successful";
  if (actionType == ToolsActions.rotateCropFlipImages) {
    title = "Edit Images";
  }
  return title;
}
