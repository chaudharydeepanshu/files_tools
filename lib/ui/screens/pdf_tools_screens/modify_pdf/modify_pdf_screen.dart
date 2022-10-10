import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/tool_actions_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/select_file_state.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/select_file_section.dart';
import 'package:files_tools/ui/components/tool_actions_section.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/modify_pdf/modify_pdf_tool_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pick_or_save/pick_or_save.dart';
import 'package:files_tools/route/route.dart' as route;

class ModifyPDFPage extends StatelessWidget {
  const ModifyPDFPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modify PDF"),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final ToolScreenState watchToolScreenStateProviderValue =
              ref.watch(toolScreenStateProvider);
          final List<InputFileModel> selectedFiles = ref.watch(
              toolScreenStateProvider.select((value) => value.selectedFiles));
          return ListView(
            children: [
              const SizedBox(height: 16),
              SelectFilesCard(
                selectFileType: SelectFileType.single,
                files: watchToolScreenStateProviderValue.selectedFiles,
                filePickerParams: const FilePickerParams(
                  copyFileToCacheDir: false,
                  filePickingType: FilePickingType.single,
                  mimeTypeFilter: ["application/pdf"],
                  allowedExtensions: [".pdf"],
                ),
              ),
              const SizedBox(height: 16),
              ToolActionsCard(
                toolActions: [
                  ToolActionsModel(
                    actionText: "Rotate, Delete & Reorder PDF Pages",
                    actionOnTap: selectedFiles.length == 1
                        ? () {
                            Navigator.pushNamed(
                              context,
                              route.modifyPDFToolsPage,
                              arguments: ModifyPDFToolsPageArguments(
                                  actionType: ToolsActions.modify,
                                  file: selectedFiles[0]),
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
    );
  }
}
