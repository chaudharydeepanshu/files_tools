import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/file_pick_save_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/custom_snack_bar.dart';
import 'package:files_tools/ui/components/input_output_list_tile.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

/// It is the tools actions result screen widget.
///
/// Shows the processing, error and success screen of an action.
class ActionResultPage extends StatelessWidget {
  /// Defining ActionResultPage constructor.
  const ActionResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return WillPopScope(
          onWillPop: () async {
            // Canceling files saving before popping result screen.
            ref.read(toolsActionsStateProvider).cancelFileSaving();
            // Canceling running actions before popping result screen.
            ref.read(toolsActionsStateProvider).cancelAction();
            // Clearing temporary directory before popping result screen.
            Utility.clearTempDirectory(clearCacheCommandFrom: 'WillPopScope');
            // Now returning true to allow the pop, returning false prevents it.
            return true;
          },
          child: GestureDetector(
            onTap: () {
              // Un focusing keyboard on tapping anywhere empty in screen.
              FocusManager.instance.primaryFocus?.unfocus();
              // Hides SnackBar on tapping anywhere empty in screen.
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: Scaffold(
              appBar: const ActionResultPageAppBar(),
              body: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  // Watches action processing status.
                  final bool isActionProcessing = ref.watch(
                    toolsActionsStateProvider.select(
                      (ToolsActionsState value) => value.isActionProcessing,
                    ),
                  );
                  // Watches action error status.
                  final bool actionErrorStatus = ref.watch(
                    toolsActionsStateProvider.select(
                      (ToolsActionsState value) => value.actionErrorStatus,
                    ),
                  );
                  // Watches action error message.
                  final String errorMessage = ref.watch(
                    toolsActionsStateProvider.select(
                      (ToolsActionsState value) => value.errorMessage,
                    ),
                  );
                  // Watches action error StackTrace.
                  final StackTrace errorStackTrace = ref.watch(
                    toolsActionsStateProvider.select(
                      (ToolsActionsState value) => value.errorStackTrace,
                    ),
                  );
                  if (isActionProcessing) {
                    return const ActionResultProcessingBody();
                  } else if (actionErrorStatus) {
                    return ShowError(
                      taskMessage: 'Sorry, failed to complete the processing.',
                      errorMessage: errorMessage,
                      errorStackTrace: errorStackTrace,
                      allowBack: true,
                    );
                  } else {
                    return const SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: ActionResultSuccessBody(),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

/// It is the tools actions result screen app bar widget.
///
/// Shows the processing, error and success app bar of an action.
class ActionResultPageAppBar extends StatelessWidget with PreferredSizeWidget {
  /// Defining ActionResultPageAppBar constructor.
  const ActionResultPageAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        // Watches action processing status.
        final bool isActionProcessing = ref.watch(
          toolsActionsStateProvider
              .select((ToolsActionsState value) => value.isActionProcessing),
        );
        // Watches action error status.
        final bool actionErrorStatus = ref.watch(
          toolsActionsStateProvider
              .select((ToolsActionsState value) => value.actionErrorStatus),
        );
        // Watches current action type.
        final ToolAction currentActionType = ref.watch(
          toolsActionsStateProvider
              .select((ToolsActionsState value) => value.currentActionType),
        );
        // Getting current action app bar title.
        String actionAppbarTitle =
            getAppBarTitleForActionResultPage(actionType: currentActionType);
        return AppBar(
          title: Text(
            isActionProcessing
                ? 'Processing Task'
                : actionErrorStatus
                    ? 'Error Occurred'
                    : actionAppbarTitle,
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Canceling files saving before pushing home screen.
                ref.read(toolsActionsStateProvider).cancelFileSaving();
                // Canceling running actions before pushing home screen.
                ref.read(toolsActionsStateProvider).cancelAction();
                // Now pushing home screen.
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  route.AppRoutes.homePage,
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

/// Gives appropriate app bar title based on type of action performed.
String getAppBarTitleForActionResultPage({required ToolAction actionType}) {
  String title = 'Task Successful';
  // if (actionType == ToolsActions.mergePdfs) {
  //   title = "Successfully Merged Files";
  // } else if (actionType == ToolsActions.splitPdfByPageCount ||
  //     actionType == ToolsActions.splitPdfByByteSize) {
  //   title = "Successfully Split File";
  // }
  return title;
}

/// It is the tools actions result success screen widget.
class ActionResultSuccessBody extends StatelessWidget {
  /// Defining ActionResultSuccessBody constructor.
  const ActionResultSuccessBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        // Watches output / save files.
        final List<OutputFileModel> outputFiles = ref.watch(
          toolsActionsStateProvider
              .select((ToolsActionsState value) => value.outputFiles),
        );
        return SavingFiles(
          saveFiles: outputFiles,
        );
      },
    );
  }
}

/// It is the tools actions result processing screen widget.
class ActionResultProcessingBody extends StatelessWidget {
  /// Defining ActionResultProcessingBody constructor.
  const ActionResultProcessingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Loading(loadingText: 'Processing please wait ...'),
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

/// Widget for saving files in tools actions result success screen.
class SavingFiles extends StatelessWidget {
  /// Defining SavingFiles constructor.
  const SavingFiles({
    Key? key,
    required this.saveFiles,
  }) : super(key: key);

  /// List of files to save.
  final List<OutputFileModel> saveFiles;

  @override
  Widget build(BuildContext context) {
    double scaffoldBodySpace = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            kToolbarHeight +
            kBottomNavigationBarHeight);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: scaffoldBodySpace < 500 ? scaffoldBodySpace : 500,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Flexible(child: SuccessAnimation()),
              const Divider(),
              Flexible(
                child: NonReorderableFilesListView(
                  saveFiles: saveFiles,
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              Text(
                saveFiles.length == 1
                    ? 'To view file click over them.'
                    : 'To view files click over them.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  ref.listen(
                      toolsActionsStateProvider.select(
                        (ToolsActionsState value) => value.isSaveProcessing,
                      ), (bool? previous, bool next) {
                    if (previous != next && next == true) {
                      String? contentText = saveFiles.length == 1
                          ? 'Saving file! Please wait...'
                          : 'Saving files! Please wait...';
                      Color? backgroundColor;
                      Duration? duration = const Duration(days: 365);
                      IconData? iconData = Icons.save;
                      Color? iconAndTextColor;

                      showCustomSnackBar(
                        context: context,
                        contentText: contentText,
                        backgroundColor: backgroundColor,
                        duration: duration,
                        iconData: iconData,
                        iconAndTextColor: iconAndTextColor,
                      );
                    } else if (next == false) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    }
                  });
                  // Watches save processing status.
                  bool isSaveProcessing = ref.watch(
                    toolsActionsStateProvider.select(
                      (ToolsActionsState value) => value.isSaveProcessing,
                    ),
                  );

                  return FilledButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    onPressed: isSaveProcessing
                        ? null
                        : () {
                            // Calling save action through provide saveFiles.
                            ref
                                .read(toolsActionsStateProvider)
                                .mangeSaveFileAction(
                                  fileSaveModel: FileSaveModel(
                                    saveFiles: saveFiles,
                                  ),
                                );
                          },
                    label: isSaveProcessing
                        ? Text(
                            saveFiles.length == 1
                                ? 'Saving file. Please wait'
                                : 'Saving Files. Please wait',
                          )
                        : Text(
                            saveFiles.length == 1 ? 'Save file' : 'Save Files',
                          ),
                    icon: const Icon(Icons.save),
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

/// Widget for showing an success animation using [RiveAnimation].
class SuccessAnimation extends StatelessWidget {
  /// Defining SuccessAnimation constructor.
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

/// A non-reorder able list view used for showing output / save files.
class NonReorderableFilesListView extends StatelessWidget {
  /// Defining NonReorderableFilesListView constructor.
  const NonReorderableFilesListView({
    Key? key,
    required this.saveFiles,
  }) : super(key: key);

  /// List of output / save files.
  final List<OutputFileModel> saveFiles;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // This shrink wrap condition is required to prevent using shrinkWrap in
      // list view for large number of files.
      // And we shrinkwrap list view for less than 10 files to avoid it from
      // taking [SavingFiles] available space which will create empty space in
      // the card. But in case of large number of files the [SavingFiles]
      // available space will and should definitely fully occupy it so
      // shrinkwrap is not required.
      shrinkWrap: saveFiles.length < 10,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (BuildContext context, int index) {
        return Material(
          color: Colors.transparent,
          child: FileTile(
            fileName: saveFiles[index].fileName,
            fileTime: saveFiles[index].fileTime,
            fileDate: saveFiles[index].fileDate,
            filePath: saveFiles[index].filePath,
            fileSize: saveFiles[index].fileSizeFormatBytes,
          ),
        );
      },
      itemCount: saveFiles.length,
    );
  }
}
