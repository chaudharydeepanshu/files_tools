import 'dart:developer';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/image_viewer.dart';
import 'package:files_tools/ui/screens/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

import 'package:files_tools/route/route.dart' as route;

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final bool isActionProcessing = ref.watch(toolsActionsStateProvider
              .select((value) => value.isActionProcessing));
          final bool actionErrorStatus = ref.watch(toolsActionsStateProvider
              .select((value) => value.actionErrorStatus));
          final ToolsActions currentActionType = ref.watch(
              toolsActionsStateProvider
                  .select((value) => value.currentActionType));
          if (isActionProcessing) {
            return const ProcessingResult();
          } else if (actionErrorStatus) {
            return const ProcessingResultError();
          } else {
            return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ResultBody(actionType: currentActionType));
          }
        },
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final bool isActionProcessing = ref.watch(toolsActionsStateProvider
            .select((value) => value.isActionProcessing));
        final bool actionErrorStatus = ref.watch(toolsActionsStateProvider
            .select((value) => value.actionErrorStatus));
        final ToolsActions currentActionType = ref.watch(
            toolsActionsStateProvider
                .select((value) => value.currentActionType));
        String actionAppbarTitle =
            getAppBarTitleForActionType(actionType: currentActionType);
        return AppBar(
          title: Text(isActionProcessing
              ? "Processing Data"
              : actionErrorStatus
                  ? "Error Occurred"
                  : actionAppbarTitle),
          centerTitle: true,
        );
      },
    );
  }
}

String getAppBarTitleForActionType({required ToolsActions actionType}) {
  String title = "Action Successful";
  if (actionType == ToolsActions.merge) {
    title = "Successfully Merged Files";
  } else if (actionType == ToolsActions.splitByPageCount ||
      actionType == ToolsActions.splitByByteSize) {
    title = "Successfully Split File";
  }
  return title;
}

class ResultBody extends StatelessWidget {
  const ResultBody({Key? key, required this.actionType}) : super(key: key);

  final ToolsActions actionType;

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
      final List<OutputFileModel> outputFiles = ref.watch(
          toolsActionsStateProvider.select((value) => value.outputFiles));
      if (outputFiles.length == 1) {
        return SavingSingleFile(file: outputFiles[0]);
      } else if (outputFiles.length > 1) {
        return SavingMultipleFiles(files: outputFiles);
      } else {
        return const Text("No save for action.");
      }
    });
  }
}

class ProcessingResultError extends StatelessWidget {
  const ProcessingResultError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text(
            "Sorry, failed to complete the processing.",
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return TextButton(
                onPressed: () {
                  ref.read(toolsActionsStateProvider).cancelAction();
                  Navigator.pop(context);
                },
                child: const Text('Go back'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProcessingResult extends StatelessWidget {
  const ProcessingResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            'Processing please wait ...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return TextButton(
                onPressed: () {
                  ref.read(toolsActionsStateProvider).cancelAction();
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SavingSingleFile extends StatelessWidget {
  const SavingSingleFile({Key? key, required this.file}) : super(key: key);

  final OutputFileModel file;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Icon(Icons.looks_3),
            const Flexible(child: SuccessAnimation()),
            const Divider(),
            OutputFileTile(file: file),
            const SizedBox(height: 10),
            Text(
              'To view files click over them.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                  onPressed: () {
                    ref.read(toolsActionsStateProvider).saveFile(
                      files: [file],
                      mimeTypeFilter: ["application/pdf"],
                    );
                  },
                  child: const Text("Save File"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SavingMultipleFiles extends StatelessWidget {
  const SavingMultipleFiles({Key? key, required this.files}) : super(key: key);

  final List<OutputFileModel> files;

  @override
  Widget build(BuildContext context) {
    double heightWithoutAppBarNavBar = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            kToolbarHeight +
            kBottomNavigationBarHeight);
    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: 0,
          maxHeight: heightWithoutAppBarNavBar < 500
              ? heightWithoutAppBarNavBar
              : 500),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // const Icon(Icons.looks_3),
              const Flexible(child: SuccessAnimation()),
              const Divider(),
              Flexible(child: NonReorderableFilesListView(files: files)),
              const SizedBox(height: 10),
              Text(
                'To view files click over them.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    onPressed: () {
                      ref.read(toolsActionsStateProvider).saveFile(
                        files: files,
                        mimeTypeFilter: ["application/pdf"],
                      );
                    },
                    child: const Text("Save Files"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuccessAnimation extends StatelessWidget {
  const SuccessAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 150,
      height: 150,
      child: RiveAnimation.asset(
        'assets/rive/rive_emoji_pack.riv',
        fit: BoxFit.contain,
      ),
    );
  }
}

class OutputFileTile extends StatelessWidget {
  const OutputFileTile({Key? key, required this.file}) : super(key: key);

  final OutputFileModel file;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.list,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      minLeadingWidth: 0,
      minVerticalPadding: 0,
      visualDensity: VisualDensity.comfortable,
      dense: true,
      onTap: () {
        String fileExtension = getFileNameExtension(fileName: file.fileName);
        if (fileExtension.toLowerCase() == ".pdf") {
          Navigator.pushNamed(
            context,
            route.pdfViewer,
            arguments: PdfViewerArguments(
                fileName: file.fileName, filePath: file.filePath),
          );
        } else if (fileExtension.toLowerCase() == ".png" ||
            fileExtension.toLowerCase() == ".jpg" ||
            fileExtension.toLowerCase() == ".jpeg") {
          Navigator.pushNamed(
            context,
            route.imageViewer,
            arguments: ImageViewerArguments(
                fileName: file.fileName, filePath: file.filePath),
          );
        } else {
          log("No action found for opening file with extension $fileExtension");
        }
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      tileColor: Theme.of(context).colorScheme.secondaryContainer,
      leading: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          height: double.infinity,
          child: Icon(Icons.description),
        ),
      ),
      title: Text(
        file.fileName,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      subtitle: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Text(file.fileDate,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis),
            ),
            const VerticalDivider(),
            Expanded(
              flex: 3,
              child: Text(
                file.fileTime,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const VerticalDivider(),
            Expanded(
              flex: 5,
              child: Text(
                file.fileSize,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NonReorderableFilesListView extends StatelessWidget {
  const NonReorderableFilesListView({Key? key, required this.files})
      : super(key: key);

  final List<OutputFileModel> files;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: files.length < 10,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (BuildContext context, int index) {
        return Material(
            color: Colors.transparent,
            child: OutputFileTile(file: files[index]));
      },
      itemCount: files.length,
    );
  }
}
