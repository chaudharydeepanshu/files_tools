import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/tool_actions_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/select_file_state.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/select_file_section.dart';
import 'package:files_tools/ui/components/tool_actions_section.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/watermark_pdf/watermark_pdf_tool_screen.dart';
import 'package:files_tools/utils/clear_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pick_or_save/pick_or_save.dart';
import 'package:files_tools/route/route.dart' as route;

class WatermarkPDFPage extends StatefulWidget {
  const WatermarkPDFPage({Key? key}) : super(key: key);

  @override
  State<WatermarkPDFPage> createState() => _WatermarkPDFPageState();
}

class _WatermarkPDFPageState extends State<WatermarkPDFPage> {
  @override
  void initState() {
    clearCache(clearCacheCommandFrom: "WatermarkPDFPage");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watermark PDF"),
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
                    actionText: "Watermark pdf",
                    actionOnTap: selectedFiles.length == 1
                        ? () {
                            Navigator.pushNamed(
                              context,
                              route.watermarkPDFToolsPage,
                              arguments: WatermarkPDFToolsPageArguments(
                                  actionType: ToolsActions.watermark,
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