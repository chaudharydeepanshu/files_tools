import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/tool_actions_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/select_file_state.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/select_file_section.dart';
import 'package:files_tools/ui/components/tool_actions_section.dart';
import 'package:files_tools/ui/screens/image_tools_screens/compress_image/compress_image_tool_screen.dart';
import 'package:files_tools/utils/clear_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pick_or_save/pick_or_save.dart';
import 'package:files_tools/route/route.dart' as route;

class CompressImagePage extends StatefulWidget {
  const CompressImagePage({Key? key}) : super(key: key);

  @override
  State<CompressImagePage> createState() => _CompressPDFPageState();
}

class _CompressPDFPageState extends State<CompressImagePage> {
  @override
  void initState() {
    clearCache(clearCacheCommandFrom: "CompressImagePage");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Removing any snack bar or keyboard
        FocusManager.instance.primaryFocus?.unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // Returning true allows the pop to happen, returning false prevents it.
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Compress Image"),
            centerTitle: true,
          ),
          body: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final ToolScreenState watchToolScreenStateProviderValue =
                  ref.watch(toolScreenStateProvider);
              final List<InputFileModel> selectedFiles = ref.watch(
                  toolScreenStateProvider
                      .select((value) => value.selectedFiles));
              return ListView(
                children: [
                  const SizedBox(height: 16),
                  SelectFilesCard(
                    selectFileType: SelectFileType.both,
                    files: watchToolScreenStateProviderValue.selectedFiles,
                    filePickerParams: FilePickerParams(
                      getCachedFilePath: false,
                      pickerType: PickerType.file,
                      enableMultipleSelection: true,
                      mimeTypesFilter: [
                        "image/png",
                        "image/jpeg",
                        "image/webp"
                      ],
                      allowedExtensions: [".png", ".jpeg", ".jpg", ".webp"],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ToolActionsCard(
                    toolActions: [
                      ToolActionsModel(
                        actionText: "Compress images",
                        actionOnTap: selectedFiles.isNotEmpty
                            ? () {
                                // Removing any snack bar or keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                Navigator.pushNamed(
                                  context,
                                  route.compressImageToolsPage,
                                  arguments: CompressImageToolsPageArguments(
                                      actionType: ToolsActions.compressImages,
                                      files: selectedFiles),
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
