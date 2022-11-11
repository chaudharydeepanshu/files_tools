import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/tool_actions_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/select_file_state.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/select_file_section.dart';
import 'package:files_tools/ui/components/tool_actions_section.dart';
import 'package:files_tools/utils/clear_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pick_or_save/pick_or_save.dart';
import 'package:files_tools/route/route.dart' as route;

class MergePDFsPage extends StatefulWidget {
  const MergePDFsPage({Key? key}) : super(key: key);

  @override
  State<MergePDFsPage> createState() => _MergePDFsPageState();
}

class _MergePDFsPageState extends State<MergePDFsPage> {
  @override
  void initState() {
    clearCache(clearCacheCommandFrom: "MergePDFsPage");
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
            title: const Text("Merge PDFs"),
            centerTitle: true,
          ),
          body: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final ToolScreenState watchToolScreenStateProviderValue =
                  ref.watch(toolScreenStateProvider);
              final List<InputFileModel> selectedFiles = ref.watch(
                  toolScreenStateProvider
                      .select((value) => value.selectedFiles));
              final ToolsActionsState watchToolsActionsStateProviderValue =
                  ref.watch(toolsActionsStateProvider);
              return ListView(
                children: [
                  const SizedBox(height: 16),
                  SelectFilesCard(
                    selectFileType: SelectFileType.multiple,
                    files: watchToolScreenStateProviderValue.selectedFiles,
                    filePickerParams: FilePickerParams(
                      getCachedFilePath: false,
                      pickerType: PickerType.file,
                      enableMultipleSelection: true,
                      mimeTypesFilter: ["application/pdf"],
                      allowedExtensions: [".pdf"],
                    ),
                    discardInvalidPdfFiles: true,
                    discardProtectedPdfFiles: true,
                  ),
                  const SizedBox(height: 16),
                  ToolActionsCard(
                    toolActions: [
                      ToolActionsModel(
                        actionText: "Merge into one PDF",
                        actionOnTap: selectedFiles.length >= 2
                            ? () {
                                // Removing any snack bar or keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                watchToolsActionsStateProviderValue
                                    .mergeSelectedFiles(files: selectedFiles);

                                Navigator.pushNamed(
                                  context,
                                  route.resultPage,
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
