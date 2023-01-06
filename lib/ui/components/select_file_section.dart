import 'dart:ui';

import 'package:files_tools/constants.dart';
import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/file_pick_save_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_screens_state.dart';
import 'package:files_tools/ui/components/input_output_list_tile.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

/// Widget for picking files and displaying input files.
class SelectFilesCard extends StatelessWidget {
  /// Defining [SelectFilesCard] constructor.
  const SelectFilesCard({
    Key? key,
    this.fileTypeSingular,
    this.fileTypePlural,
    required this.files,
    required this.filePickModel,
  }) : super(key: key);

  /// Takes singular of file type such as PDF, Image, etc.
  final String? fileTypeSingular;

  /// Takes plural of file type such as PDFs, Images, etc.
  final String? fileTypePlural;

  /// Takes input files.
  final List<InputFileModel> files;

  /// Takes properties for files picking action.
  final FilePickModel filePickModel;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String fileTypeSingular = this.fileTypeSingular ?? appLocale.file(1);
    String fileTypePlural = this.fileTypePlural ?? appLocale.file(2);

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
            children: <Widget>[
              const Icon(Icons.looks_one),
              const Divider(),
              files.isNotEmpty
                  ? Flexible(
                      child: FilesSelected(
                        fileTypeSingular: fileTypeSingular,
                        fileTypePlural: fileTypePlural,
                        files: files,
                        filePickModel: filePickModel,
                      ),
                    )
                  : NoFilesSelected(
                      fileTypeSingular: fileTypeSingular,
                      fileTypePlural: fileTypePlural,
                      filePickModel: filePickModel,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget for displaying files.
class FilesSelected extends StatelessWidget {
  /// Defining [FilesSelected] constructor.
  const FilesSelected({
    Key? key,
    required this.fileTypeSingular,
    required this.fileTypePlural,
    required this.files,
    required this.filePickModel,
  }) : super(key: key);

  /// Takes singular of file type such as PDF, Image, etc.
  final String fileTypeSingular;

  /// Takes plural of file type such as PDFs, Images, etc.
  final String fileTypePlural;

  /// Takes input files.
  final List<InputFileModel> files;

  /// Takes properties for files picking action.
  final FilePickModel filePickModel;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);
    String fetchingPickedFiles = appLocale.pickedFiles_Fetching;
    String pickOneMoreFile = appLocale.pickOneMoreFile;
    String rearrangePickedFiles =
        appLocale.pickedFiles_Rearrange(fileTypePlural);
    String pickMore = appLocale.button_PickMore;
    String clearAll = appLocale.button_ClearAll;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: files.length > 1
              ? ReorderableFilesListView(files: files)
              : Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    final ToolsScreensState readToolScreenStateProviderValue =
                        ref.watch(toolsScreensStateProvider);

                    return FileTile(
                      fileName: files[0].fileName,
                      fileTime: files[0].fileTime,
                      fileDate: files[0].fileDate,
                      fileUri: files[0].fileUri,
                      fileSize: files[0].fileSizeFormatBytes,
                      onRemove: () {
                        final List<InputFileModel> selectedFiles =
                            ref.watch(toolsScreensStateProvider).inputFiles;
                        selectedFiles.remove(files[0]);
                        readToolScreenStateProviderValue.updateSelectedFiles(
                          files: selectedFiles,
                        );
                      },
                    );
                  },
                ),
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final bool isPickingFile =
                ref.watch(toolsScreensStateProvider).isFilePickProcessing;
            return isPickingFile
                ? Column(
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Text(
                        fetchingPickedFiles,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const Divider()
                    ],
                  )
                : filePickModel.multipleFilePickRequired && files.length == 1
                    ? Column(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          Text(
                            pickOneMoreFile,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const Divider()
                        ],
                      )
                    : filePickModel.multipleFilePickRequired ||
                            filePickModel.enableMultipleSelection &&
                                files.length > 1
                        ? Column(
                            children: <Widget>[
                              const SizedBox(height: 10),
                              Text(
                                rearrangePickedFiles,
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                              const Divider()
                            ],
                          )
                        : const Divider();
          },
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final ToolsScreensState readToolScreenStateProviderValue =
                ref.watch(toolsScreensStateProvider);
            final bool isPickingFile =
                ref.watch(toolsScreensStateProvider).isFilePickProcessing;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (filePickModel.multipleFilePickRequired ||
                    filePickModel.enableMultipleSelection)
                  Flexible(
                    child: FilledButton.tonalIcon(
                      onPressed: !isPickingFile
                          ? () {
                              // Removing any snack bar or keyboard
                              FocusManager.instance.primaryFocus?.unfocus();
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();

                              readToolScreenStateProviderValue
                                  .mangePickFileAction(
                                filePickModel: filePickModel.copyWith(
                                  continuePicking: true,
                                ),
                              );
                            }
                          : null,
                      label: Text(
                        pickMore,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                      ),
                      icon: const Icon(Icons.upload_file),
                    ),
                  ),
                Flexible(
                  child: FilledButton.tonalIcon(
                    onPressed: !isPickingFile
                        ? () {
                            // Removing any snack bar or keyboard
                            FocusManager.instance.primaryFocus?.unfocus();
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            readToolScreenStateProviderValue
                                .updateSelectedFiles(
                              files: <InputFileModel>[],
                            );
                            Utility.clearTempDirectory(
                              clearCacheCommandFrom: 'Clear File Selection',
                            );
                          }
                        : null,
                    label: Text(
                      clearAll,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                    ),
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Widget for displaying no files.
class NoFilesSelected extends StatelessWidget {
  /// Defining [NoFilesSelected] constructor.
  const NoFilesSelected({
    Key? key,
    required this.fileTypeSingular,
    required this.fileTypePlural,
    required this.filePickModel,
  }) : super(key: key);

  /// Takes singular of file type such as PDF, Image, etc.
  final String fileTypeSingular;

  /// Takes plural of file type such as PDFs, Images, etc.
  final String fileTypePlural;

  /// Takes properties for files picking action.
  final FilePickModel filePickModel;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);
    String pickSomeFiles = appLocale.pickSomeFiles(fileTypePlural);
    String pickOneFile = appLocale.pickOneFile(fileTypeSingular);
    String pickFile = appLocale.button_PickFileOrFiles(fileTypeSingular);
    String pickFiles = appLocale.button_PickFileOrFiles(fileTypePlural);

    return Column(
      children: <Widget>[
        Transform.scale(
          scale: 4.0,
          child: SizedBox(
            width: 100,
            height: 100,
            child: RiveAnimation.asset(
              noFilesPickedAnimationAssetName,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Text(
          filePickModel.multipleFilePickRequired ||
                  filePickModel.enableMultipleSelection
              ? pickSomeFiles
              : pickOneFile,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final ToolsScreensState readToolScreenStateProviderValue =
                ref.watch(toolsScreensStateProvider);
            final bool isPickingFile =
                ref.watch(toolsScreensStateProvider).isFilePickProcessing;
            return FilledButton.icon(
              onPressed: !isPickingFile
                  ? () {
                      // Removing any snack bar or keyboard
                      FocusManager.instance.primaryFocus?.unfocus();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      readToolScreenStateProviderValue.mangePickFileAction(
                        filePickModel: filePickModel,
                      );
                    }
                  : null,
              label: Text(
                filePickModel.multipleFilePickRequired ||
                        filePickModel.enableMultipleSelection
                    ? pickFiles
                    : pickFile,
                textAlign: TextAlign.center,
              ),
              icon: const Icon(Icons.upload_file),
            );
          },
        ),
      ],
    );
  }
}

/// Widget for displaying reorder able files.
class ReorderableFilesListView extends StatefulWidget {
  /// Defining [ReorderableFilesListView] constructor.
  const ReorderableFilesListView({super.key, required this.files});

  /// Takes input files.
  final List<InputFileModel> files;

  @override
  State<ReorderableFilesListView> createState() =>
      _ReorderableFilesListViewState();
}

class _ReorderableFilesListViewState extends State<ReorderableFilesListView> {
  late List<InputFileModel> _files = widget.files;

  @override
  void didUpdateWidget(covariant ReorderableFilesListView oldWidget) {
    if (widget.files != oldWidget.files) {
      setState(() {
        _files = widget.files;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Widget proxyDecorator(
      Widget child,
      int index,
      Animation<double> animation,
    ) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(0, 6, animValue)!;
          return Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    elevation: elevation,
                    shadowColor: colorScheme.shadow,
                  ),
                ),
                child!,
              ],
            ),
          );
        },
        child: child,
      );
    }

    return ReorderableListView.builder(
      shrinkWrap: _files.length < 10,
      proxyDecorator: proxyDecorator,
      itemCount: _files.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          key: Key('$index'),
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final ToolsScreensState readToolScreenStateProviderValue =
                      ref.watch(toolsScreensStateProvider);

                  return FileTile(
                    fileName: _files[index].fileName,
                    fileTime: _files[index].fileTime,
                    fileDate: _files[index].fileDate,
                    fileUri: _files[index].fileUri,
                    fileSize: _files[index].fileSizeFormatBytes,
                    onRemove: () {
                      final List<InputFileModel> selectedFiles =
                          ref.watch(toolsScreensStateProvider).inputFiles;
                      selectedFiles.remove(_files[index]);
                      readToolScreenStateProviderValue.updateSelectedFiles(
                        files: selectedFiles,
                      );
                    },
                  );
                },
              ),
            ),
            index != _files.length - 1
                ? const SizedBox(height: 10)
                : const SizedBox(),
          ],
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final InputFileModel item = _files.removeAt(oldIndex);
          _files.insert(newIndex, item);
        });
      },
    );
  }
}
