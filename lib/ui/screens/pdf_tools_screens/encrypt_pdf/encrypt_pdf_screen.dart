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
import 'package:files_tools/ui/screens/pdf_tools_screens/encrypt_pdf/encrypt_pdf_tools_screen.dart';

class EncryptPDFPage extends StatefulWidget {
  const EncryptPDFPage({Key? key}) : super(key: key);

  @override
  State<EncryptPDFPage> createState() => _EncryptPDFPageState();
}

class _EncryptPDFPageState extends State<EncryptPDFPage> {
  @override
  void initState() {
    clearCache(clearCacheCommandFrom: "EncryptPDFPage");
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
            title: const Text("Encrypt PDF"),
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
                    filePickerParams: FilePickerParams(
                      copyFileToCacheDir: false,
                      pickerType: PickerType.file,
                      enableMultipleSelection: false,
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
                        actionText: "Encrypt PDF",
                        actionOnTap: selectedFiles.length == 1
                            ? () {
                                // Removing any snack bar or keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                Navigator.pushNamed(
                                  context,
                                  route.encryptPDFToolsPage,
                                  arguments: EncryptPDFToolsPageArguments(
                                      actionType: ToolsActions.encryptPdf,
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