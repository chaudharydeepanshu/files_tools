import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/tool_actions_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/select_file_state.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/select_file_section.dart';
import 'package:files_tools/ui/components/tool_actions_section.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/decrypt_pdf/decrypt_pdf_tools_screen.dart';
import 'package:files_tools/utils/clear_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pick_or_save/pick_or_save.dart';
import 'package:files_tools/route/route.dart' as route;

class DecryptPDFPage extends StatefulWidget {
  const DecryptPDFPage({Key? key}) : super(key: key);

  @override
  State<DecryptPDFPage> createState() => _DecryptPDFPageState();
}

class _DecryptPDFPageState extends State<DecryptPDFPage> {
  @override
  void initState() {
    clearCache(clearCacheCommandFrom: "DecryptPDFPage");
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
            title: const Text("Decrypt PDF"),
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
                    selectFileType: SelectFileType.single,
                    files: watchToolScreenStateProviderValue.selectedFiles,
                    filePickerParams: const FilePickerParams(
                      copyFileToCacheDir: false,
                      filePickingType: FilePickingType.single,
                      mimeTypesFilter: ["application/pdf"],
                      allowedExtensions: [".pdf"],
                    ),
                    discardInvalidPdfFiles: true,
                    discardProtectedPdfFiles: false,
                  ),
                  const SizedBox(height: 16),
                  ToolActionsCard(
                    toolActions: [
                      ToolActionsModel(
                        actionText: "Decrypt PDF",
                        actionOnTap: selectedFiles.length == 1
                            ? () {
                                // Removing any snack bar or keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                Navigator.pushNamed(
                                  context,
                                  route.decryptPDFToolsPage,
                                  arguments: DecryptPDFToolsPageArguments(
                                      actionType: ToolsActions.decrypt,
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
        ),
      ),
    );
  }
}
