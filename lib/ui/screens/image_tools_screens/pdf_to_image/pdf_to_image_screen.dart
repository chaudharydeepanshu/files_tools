import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/file_pick_save_model.dart';
import 'package:files_tools/models/tool_actions_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/state/tools_screens_state.dart';
import 'package:files_tools/ui/components/select_file_section.dart';
import 'package:files_tools/ui/components/tool_actions_section.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/convert_pdf/convert_pdf_tool_action_screen.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tool screen for converting PDF to image.
class PdfToImagePage extends StatefulWidget {
  /// Defining [PdfToImagePage] constructor.
  const PdfToImagePage({Key? key}) : super(key: key);

  @override
  State<PdfToImagePage> createState() => _PdfToImagePageState();
}

class _PdfToImagePageState extends State<PdfToImagePage> {
  @override
  void initState() {
    Utility.clearTempDirectory(clearCacheCommandFrom: 'PDFToImagePage');
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
            title: const Text('PDF To Images'),
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
                        actionText: 'Convert pdf pages to images',
                        actionOnTap: selectedFiles.length == 1
                            ? () {
                                // Removing any snack bar or keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                Navigator.pushNamed(
                                  context,
                                  route.AppRoutes.convertPDFToolsPage,
                                  arguments: ConvertPDFToolsPageArguments(
                                    actionType: ToolAction.convertPdfToImage,
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
