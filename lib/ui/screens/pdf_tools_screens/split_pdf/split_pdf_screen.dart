import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/file_pick_save_model.dart';
import 'package:files_tools/models/tool_actions_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/state/tools_screens_state.dart';
import 'package:files_tools/ui/components/select_file_section.dart';
import 'package:files_tools/ui/components/tool_actions_section.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/split_pdf_tools_action_screen.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tool screen for splitting PDF.
class SplitPDFPage extends StatefulWidget {
  /// Defining [SplitPDFPage] constructor.
  const SplitPDFPage({Key? key}) : super(key: key);

  @override
  State<SplitPDFPage> createState() => _SplitPDFPageState();
}

class _SplitPDFPageState extends State<SplitPDFPage> {
  @override
  void initState() {
    Utility.clearTempDirectory(clearCacheCommandFrom: 'SplitPDFPage');
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
            title: const Text('Split PDF'),
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
              return ListView(
                children: <Widget>[
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
                      discardInvalidPdfFiles: true,
                      discardProtectedPdfFiles: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ToolActionsCard(
                    toolActions: <ToolActionModel>[
                      ToolActionModel(
                        actionText: 'Extract PDF pages by page selection',
                        actionOnTap: selectedFiles.length == 1
                            ? () {
                                // Removing any snack bar or keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                Navigator.pushNamed(
                                  context,
                                  route.AppRoutes.splitPDFToolsPage,
                                  arguments: SplitPDFToolsPageArguments(
                                    actionType:
                                        ToolAction.extractPdfByPageSelection,
                                    file: selectedFiles[0],
                                  ),
                                );
                              }
                            : null,
                      ),
                      ToolActionModel(
                        actionText: 'Split PDF by page count',
                        actionOnTap: selectedFiles.length == 1
                            ? () {
                                // Removing any snack bar or keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                Navigator.pushNamed(
                                  context,
                                  route.AppRoutes.splitPDFToolsPage,
                                  arguments: SplitPDFToolsPageArguments(
                                    actionType: ToolAction.splitPdfByPageCount,
                                    file: selectedFiles[0],
                                  ),
                                );
                              }
                            : null,
                      ),
                      ToolActionModel(
                        actionText: 'Split PDF by size',
                        actionOnTap: selectedFiles.length == 1
                            ? () {
                                // Removing any snack bar or keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                Navigator.pushNamed(
                                  context,
                                  route.AppRoutes.splitPDFToolsPage,
                                  arguments: SplitPDFToolsPageArguments(
                                    actionType: ToolAction.splitPdfByByteSize,
                                    file: selectedFiles[0],
                                  ),
                                );
                              }
                            : null,
                      ),
                      ToolActionModel(
                        actionText: 'Split PDF by page numbers',
                        actionOnTap: selectedFiles.length == 1
                            ? () {
                                // Removing any snack bar or keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                Navigator.pushNamed(
                                  context,
                                  route.AppRoutes.splitPDFToolsPage,
                                  arguments: SplitPDFToolsPageArguments(
                                    actionType:
                                        ToolAction.splitPdfByPageNumbers,
                                    file: selectedFiles[0],
                                  ),
                                );
                              }
                            : null,
                      ),
                      ToolActionModel(
                        actionText: 'Extract PDF pages by page range',
                        actionOnTap: selectedFiles.length == 1
                            ? () {
                                // Removing any snack bar or keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                Navigator.pushNamed(
                                  context,
                                  route.AppRoutes.splitPDFToolsPage,
                                  arguments: SplitPDFToolsPageArguments(
                                    actionType:
                                        ToolAction.extractPdfByPageRange,
                                    file: selectedFiles[0],
                                  ),
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
