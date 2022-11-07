import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/custom_snack_bar.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/ui/screens/image_viewer.dart';
import 'package:files_tools/ui/screens/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

import 'package:files_tools/route/route.dart' as route;
import 'package:files_tools/utils/clear_cache.dart';
import 'package:url_launcher/url_launcher.dart';

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
            clearCache(clearCacheCommandFrom: "WillPopScope");
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
                      toolsActionsStateProvider
                          .select((value) => value.isActionProcessing));
                  final bool actionErrorStatus = ref.watch(
                      toolsActionsStateProvider
                          .select((value) => value.actionErrorStatus));
                  final ToolsActions currentActionType = ref.watch(
                      toolsActionsStateProvider
                          .select((value) => value.currentActionType));
                  if (isActionProcessing) {
                    return const ProcessingResult();
                  } else if (actionErrorStatus) {
                    return const ProcessingError(
                      taskMessage: "Sorry, failed to complete the processing.",
                    );
                  } else {
                    return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ResultBody(actionType: currentActionType));
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
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Canceling files save before screen popping,
                ref.read(toolsActionsStateProvider).cancelFileSaving();
                // Canceling running actions.
                ref.read(toolsActionsStateProvider).cancelAction();
                Navigator.pushNamedAndRemoveUntil(
                    context, route.homePage, (Route<dynamic> route) => false);
              },
            ),
          ],
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
        return SavingSingleFile(file: outputFiles[0], actionType: actionType);
      } else if (outputFiles.length > 1) {
        return SavingMultipleFiles(files: outputFiles, actionType: actionType);
      } else {
        return const Text("No save for action.");
      }
    });
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
  const SavingSingleFile(
      {Key? key, required this.file, required this.actionType})
      : super(key: key);

  final OutputFileModel file;
  final ToolsActions actionType;

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
            OutputFileTile(file: file, actionType: actionType),
            const SizedBox(height: 10),
            Text(
              'To view files click over them.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                ref.listen(
                    toolsActionsStateProvider.select(
                        (value) => value.isSaveProcessing), (previous, next) {
                  if (previous != next && next == true) {
                    String? contentText = 'Saving file! Please wait...';
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

                bool isSaveProcessing = ref.watch(toolsActionsStateProvider
                    .select((value) => value.isSaveProcessing));

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                  onPressed: isSaveProcessing
                      ? null
                      : () {
                          ref.read(toolsActionsStateProvider).saveFile(
                            files: [file],
                          );
                        },
                  child: isSaveProcessing
                      ? const Text("Saving File. Please wait")
                      : const Text("Save File"),
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
  const SavingMultipleFiles(
      {Key? key, required this.files, required this.actionType})
      : super(key: key);

  final List<OutputFileModel> files;
  final ToolsActions actionType;

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
              Flexible(
                  child: NonReorderableFilesListView(
                      files: files, actionType: actionType)),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              Text(
                'To view files click over them.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  ref.listen(
                      toolsActionsStateProvider.select(
                          (value) => value.isSaveProcessing), (previous, next) {
                    if (previous != next && next == true) {
                      String? contentText = 'Saving files! Please wait...';
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

                  bool isSaveProcessing = ref.watch(toolsActionsStateProvider
                      .select((value) => value.isSaveProcessing));

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    onPressed: isSaveProcessing
                        ? null
                        : () {
                            ref.read(toolsActionsStateProvider).saveFile(
                                  files: files,
                                );
                          },
                    child: isSaveProcessing
                        ? const Text("Saving Files. Please wait")
                        : const Text("Save Files"),
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
  const OutputFileTile({Key? key, required this.file, required this.actionType})
      : super(key: key);

  final OutputFileModel file;
  final ToolsActions actionType;

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
                fileName: file.fileName, filePathOrUri: file.filePath),
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
  const NonReorderableFilesListView(
      {Key? key, required this.files, required this.actionType})
      : super(key: key);

  final List<OutputFileModel> files;
  final ToolsActions actionType;

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
            child: OutputFileTile(file: files[index], actionType: actionType));
      },
      itemCount: files.length,
    );
  }
}

class ProcessingError extends StatelessWidget {
  const ProcessingError({Key? key, required this.taskMessage})
      : super(key: key);

  final String taskMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          String errorMessage =
              ref.watch(toolsActionsStateProvider).errorMessage;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShowError(taskMessage: taskMessage, errorMessage: errorMessage),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {
                      ref.read(toolsActionsStateProvider).cancelAction();
                      Navigator.pop(context);
                    },
                    child: const Text('Go back'),
                  ),
                  TextButton(
                    onPressed: () async {
                      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

                      AndroidDeviceInfo androidDeviceInfo =
                          await deviceInfo.androidInfo;

                      String userDeviceInfo =
                          '''version.securityPatch: ${androidDeviceInfo.version.securityPatch}
                          version.sdkInt: ${androidDeviceInfo.version.sdkInt}
                          version.release: ${androidDeviceInfo.version.release}
                          version.previewSdkInt: ${androidDeviceInfo.version.previewSdkInt}
                          version.incrementa: ${androidDeviceInfo.version.incremental}
                          version.codename: ${androidDeviceInfo.version.codename}
                          version.baseOS: ${androidDeviceInfo.version.baseOS}
                          board: ${androidDeviceInfo.board}
                          bootloader: ${androidDeviceInfo.bootloader}
                          brand: ${androidDeviceInfo.brand}
                          device: ${androidDeviceInfo.device}
                          display: ${androidDeviceInfo.display}
                          fingerprint: ${androidDeviceInfo.fingerprint}
                          hardware: ${androidDeviceInfo.hardware}
                          host: ${androidDeviceInfo.host}
                          id: ${androidDeviceInfo.id}
                          manufacturer: ${androidDeviceInfo.manufacturer}
                          model: ${androidDeviceInfo.model}
                          product: ${androidDeviceInfo.product}
                          supported32BitAbis: ${androidDeviceInfo.supported32BitAbis}
                          supported64BitAbis: ${androidDeviceInfo.supported64BitAbis}
                          supportedAbis: ${androidDeviceInfo.supportedAbis}
                          tags: ${androidDeviceInfo.tags}
                          type: ${androidDeviceInfo.type}
                          isPhysicalDevice: ${androidDeviceInfo.isPhysicalDevice}
                          systemFeatures: ${androidDeviceInfo.systemFeatures}
                          ''';

                      var url =
                          'mailto:pureinfoapps@gmail.com?subject=Files Tools Bug Report&body=Error Message:\n$errorMessage\n\nUser Device Info:\n$userDeviceInfo';

                      await launchUrl(Uri.parse(url));
                    },
                    child: const Text('Report Error'),
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
