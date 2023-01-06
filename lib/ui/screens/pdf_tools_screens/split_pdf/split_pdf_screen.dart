import 'package:files_tools/l10n/generated/app_locale.dart';
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
    AppLocale appLocale = AppLocale.of(context);

    String pdfSingular = appLocale.pdf(1);
    String pdfPlural = appLocale.pdf(2);
    String splitPdf = appLocale.tool_SplitFileOrFiles(pdfSingular);
    String extractPdfWithSelection =
        appLocale.button_ExtractFileWithSelection(pdfSingular);
    String extractPdfWithPageRange =
        appLocale.button_ExtractFileWithPageRange(pdfSingular);
    String splitPdfWithPageNumbers =
        appLocale.button_SplitFileWithPageNumbers(pdfSingular);
    String splitPdfWithPageInterval =
        appLocale.button_SplitFileWithPageInterval(pdfSingular);
    String splitPdfWithSize = appLocale.button_SplitFileWithSize(pdfSingular);

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
            title: Text(splitPdf),
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: <Widget>[
                  SelectFilesCard(
                    fileTypeSingular: pdfSingular,
                    fileTypePlural: pdfPlural,
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
                        actionText: extractPdfWithSelection,
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
                        actionText: extractPdfWithPageRange,
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
                      ToolActionModel(
                        actionText: splitPdfWithPageNumbers,
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
                        actionText: splitPdfWithPageInterval,
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
                        actionText: splitPdfWithSize,
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
