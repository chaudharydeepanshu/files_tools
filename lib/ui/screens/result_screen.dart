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

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return WillPopScope(
          onWillPop: () async {
            // Canceling files save before screen popping,
            ref.read(toolsActionsStateProvider).cancelFileSaving();
            // Canceling running actions.
            ref.read(toolsActionsStateProvider).cancelAction();
            // Remove result cached Files
            Utility.clearCache(clearCacheCommandFrom: 'WillPopScope');
            // Returning true allows the pop to happen, returning false prevents it.
            return true;
          },
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: Scaffold(
              appBar: const CustomAppBar(),
              body: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final bool isActionProcessing = ref.watch(
                    toolsActionsStateProvider.select(
                        (ToolsActionsState value) => value.isActionProcessing),
                  );
                  final bool actionErrorStatus = ref.watch(
                    toolsActionsStateProvider.select(
                        (ToolsActionsState value) => value.actionErrorStatus),
                  );
                  final String errorMessage = ref.watch(
                    toolsActionsStateProvider.select(
                        (ToolsActionsState value) => value.errorMessage),
                  );
                  final StackTrace errorStackTrace = ref.watch(
                    toolsActionsStateProvider.select(
                        (ToolsActionsState value) => value.errorStackTrace),
                  );
                  final ToolAction currentActionType = ref.watch(
                    toolsActionsStateProvider.select(
                        (ToolsActionsState value) => value.currentActionType),
                  );
                  if (isActionProcessing) {
                    return const ProcessingResult();
                  } else if (actionErrorStatus) {
                    return ShowError(
                      taskMessage: 'Sorry, failed to complete the processing.',
                      errorMessage: errorMessage,
                      errorStackTrace: errorStackTrace,
                      allowBack: true,
                    );
                  } else {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ResultBody(actionType: currentActionType),
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

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final bool isActionProcessing = ref.watch(
          toolsActionsStateProvider
              .select((ToolsActionsState value) => value.isActionProcessing),
        );
        final bool actionErrorStatus = ref.watch(
          toolsActionsStateProvider
              .select((ToolsActionsState value) => value.actionErrorStatus),
        );
        final ToolAction currentActionType = ref.watch(
          toolsActionsStateProvider
              .select((ToolsActionsState value) => value.currentActionType),
        );
        String actionAppbarTitle =
            getAppBarTitleForActionType(actionType: currentActionType);
        return AppBar(
          title: Text(
            isActionProcessing
                ? 'Processing Data'
                : actionErrorStatus
                    ? 'Error Occurred'
                    : actionAppbarTitle,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Canceling files save before screen popping,
                ref.read(toolsActionsStateProvider).cancelFileSaving();
                // Canceling running actions.
                ref.read(toolsActionsStateProvider).cancelAction();
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

String getAppBarTitleForActionType({required ToolAction actionType}) {
  String title = 'Action Successful';
  // if (actionType == ToolsActions.mergePdfs) {
  //   title = "Successfully Merged Files";
  // } else if (actionType == ToolsActions.splitPdfByPageCount ||
  //     actionType == ToolsActions.splitPdfByByteSize) {
  //   title = "Successfully Split File";
  // }
  return title;
}

class ResultBody extends StatelessWidget {
  const ResultBody({Key? key, required this.actionType}) : super(key: key);

  final ToolAction actionType;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final List<OutputFileModel> outputFiles = ref.watch(
          toolsActionsStateProvider
              .select((ToolsActionsState value) => value.outputFiles),
        );
        return SavingMultipleFiles(
          files: outputFiles,
          actionType: actionType,
        );
      },
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

class SavingMultipleFiles extends StatelessWidget {
  const SavingMultipleFiles({
    Key? key,
    required this.files,
    required this.actionType,
  }) : super(key: key);

  final List<OutputFileModel> files;
  final ToolAction actionType;

  @override
  Widget build(BuildContext context) {
    double heightWithoutAppBarNavBar = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            kToolbarHeight +
            kBottomNavigationBarHeight);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight:
            heightWithoutAppBarNavBar < 500 ? heightWithoutAppBarNavBar : 500,
      ),
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
              Flexible(
                child: NonReorderableFilesListView(
                  files: files,
                  actionType: actionType,
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              Text(
                files.length == 1
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
                      String? contentText = files.length == 1
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

                  bool isSaveProcessing = ref.watch(
                    toolsActionsStateProvider.select(
                        (ToolsActionsState value) => value.isSaveProcessing),
                  );

                  return FilledButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    onPressed: isSaveProcessing
                        ? null
                        : () {
                            ref
                                .read(toolsActionsStateProvider)
                                .mangeSaveFileAction(
                                  fileSaveModel: FileSaveModel(
                                    saveFiles: files,
                                  ),
                                );
                          },
                    label: isSaveProcessing
                        ? Text(
                            files.length == 1
                                ? 'Saving file. Please wait'
                                : 'Saving Files. Please wait',
                          )
                        : Text(
                            files.length == 1 ? 'Save file' : 'Save Files',
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

class NonReorderableFilesListView extends StatelessWidget {
  const NonReorderableFilesListView({
    Key? key,
    required this.files,
    required this.actionType,
  }) : super(key: key);

  final List<OutputFileModel> files;
  final ToolAction actionType;

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
          child: FileTile(
            fileName: files[index].fileName,
            fileTime: files[index].fileTime,
            fileDate: files[index].fileDate,
            filePath: files[index].filePath,
            fileSize: files[index].fileSizeFormatBytes,
          ),
        );
      },
      itemCount: files.length,
    );
  }
}
