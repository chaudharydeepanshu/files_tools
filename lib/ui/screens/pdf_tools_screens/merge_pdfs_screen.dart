import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/file_pick_save_model.dart';
import 'package:files_tools/models/tool_actions_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/state/tools_screens_state.dart';
import 'package:files_tools/ui/components/select_file_section.dart';
import 'package:files_tools/ui/components/tool_actions_section.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MergePDFsPage extends StatefulWidget {
  const MergePDFsPage({Key? key}) : super(key: key);

  @override
  State<MergePDFsPage> createState() => _MergePDFsPageState();
}

class _MergePDFsPageState extends State<MergePDFsPage> {
  @override
  void initState() {
    Utility.clearCache(clearCacheCommandFrom: 'MergePDFsPage');
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
            title: const Text('Merge PDFs'),
            centerTitle: true,
          ),
          body: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final ToolsScreensState watchToolScreenStateProviderValue =
                  ref.watch(toolsScreensStateProvider);
              final List<InputFileModel> selectedFiles = ref.watch(
                toolsScreensStateProvider
                    .select((ToolsScreensState value) => value.inputFiles),
              );
              final ToolsActionsState watchToolsActionsStateProviderValue =
                  ref.watch(toolsActionsStateProvider);
              return ListView(
                children: [
                  const SizedBox(height: 16),
                  SelectFilesCard(
                    files: watchToolScreenStateProviderValue.inputFiles,
                    filePickModel: const FilePickModel(
                      allowedExtensions: <String>[
                        '.pdf',
                      ],
                      mimeTypesFilter: <String>[
                        'application/pdf',
                      ],
                      enableMultipleSelection: true,
                      discardInvalidPdfFiles: true,
                      discardProtectedPdfFiles: true,
                      multipleFilePickRequired: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ToolActionsCard(
                    toolActions: [
                      ToolActionModel(
                        actionText: 'Merge into one PDF',
                        actionOnTap: selectedFiles.length >= 2
                            ? () {
                                // Removing any snack bar or keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                watchToolsActionsStateProviderValue
                                    .mangeMergePdfFileAction(
                                        sourceFiles: selectedFiles);

                                Navigator.pushNamed(
                                  context,
                                  route.AppRoutes.resultPage,
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
