import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/tool_actions_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/select_file_state.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/select_file_section.dart';
import 'package:files_tools/ui/components/tool_actions_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pick_or_save/pick_or_save.dart';
import 'package:rive/rive.dart';
import 'package:files_tools/route/route.dart' as route;

class MergePDFsPage extends StatelessWidget {
  const MergePDFsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Merge PDFs"),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final ToolScreenState watchToolScreenStateProviderValue =
              ref.watch(toolScreenStateProvider);
          final List<InputFileModel> selectedFiles = ref.watch(
              toolScreenStateProvider.select((value) => value.selectedFiles));
          final ToolsActionsState watchToolsActionsStateProviderValue =
              ref.watch(toolsActionsStateProvider);
          return ListView(
            children: [
              SelectFilesCard(
                selectFileType: SelectFileType.multiple,
                files: watchToolScreenStateProviderValue.selectedFiles,
                filePickerParams: const FilePickerParams(
                  copyFileToCacheDir: false,
                  filePickingType: FilePickingType.multiple,
                  mimeTypeFilter: ["application/pdf"],
                  allowedExtensions: [".pdf"],
                ),
              ),
              const SizedBox(height: 16),
              ToolActionsCard(
                toolActions: [
                  ToolActionsModel(
                    actionText: "Merge into one PDF",
                    actionOnTap: selectedFiles.length >= 2
                        ? () {
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
    );
  }
}

// class SaveCard extends StatelessWidget {
//   const SaveCard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       clipBehavior: Clip.antiAlias,
//       margin: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               children: const [
//                 Icon(Icons.looks_3),
//               ],
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Theme.of(context).colorScheme.onPrimary,
//                 backgroundColor: Theme.of(context).colorScheme.primary,
//               ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
//               onPressed: () {
//
//               },
//               child: const Text('Save file'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

loadingDialog({required BuildContext context}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => const LoadingDialog(),
  );
}

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Processing', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 150,
            height: 100,
            child: RiveAnimation.asset(
              'assets/rive/finger_tapping.riv',
              fit: BoxFit.contain,
            ),
          ),
          Text(
            'Please wait ...',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
