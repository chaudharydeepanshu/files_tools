import 'dart:ui';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/select_file_state.dart';
import 'package:files_tools/ui/screens/pdf_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pick_or_save/pick_or_save.dart';
import 'package:rive/rive.dart';
import 'package:files_tools/route/route.dart' as route;

enum SelectFileType { single, multiple, both }

class SelectFilesCard extends StatelessWidget {
  const SelectFilesCard(
      {Key? key,
      required this.selectFileType,
      required this.files,
      required this.filePickerParams})
      : super(key: key);

  final SelectFileType selectFileType;
  final List<InputFileModel> files;
  final FilePickerParams filePickerParams;

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
              const Icon(Icons.looks_one),
              const Divider(),
              files.isNotEmpty
                  ? Flexible(
                      child: FilesSelected(
                          selectFileType: selectFileType,
                          files: files,
                          filePickerParams: filePickerParams),
                    )
                  : NoFilesSelected(
                      selectFileType: selectFileType,
                      filePickerParams: filePickerParams),
            ],
          ),
        ),
      ),
    );
  }
}

class FilesSelected extends StatelessWidget {
  const FilesSelected(
      {Key? key,
      required this.selectFileType,
      required this.files,
      required this.filePickerParams})
      : super(key: key);

  final SelectFileType selectFileType;
  final List<InputFileModel> files;
  final FilePickerParams filePickerParams;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: files.length > 1
                ? ReorderableFilesListView(files: files)
                : SelectedFileTile(file: files[0])),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final bool isPickingFile =
                ref.watch(toolScreenStateProvider).isPickingFile;
            return isPickingFile
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Text('Picking files please wait ...',
                          style: Theme.of(context).textTheme.bodySmall),
                      const Divider()
                    ],
                  )
                : selectFileType == SelectFileType.multiple && files.length == 1
                    ? Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'Please select at least one more file',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Theme.of(context).colorScheme.error),
                          ),
                          const Divider()
                        ],
                      )
                    : selectFileType == SelectFileType.multiple &&
                            files.length > 1
                        ? Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                'Long press on files to reorder them',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const Divider()
                            ],
                          )
                        : const Divider();
          },
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final ToolScreenState readToolScreenStateProviderValue =
                ref.watch(toolScreenStateProvider);
            final bool isPickingFile =
                ref.watch(toolScreenStateProvider).isPickingFile;
            return Wrap(
              spacing: 10,
              children: [
                if (selectFileType == SelectFileType.multiple ||
                    selectFileType == SelectFileType.both)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    onPressed: !isPickingFile
                        ? () {
                            readToolScreenStateProviderValue.selectFiles(
                              params: filePickerParams,
                            );
                          }
                        : null,
                    label: const Text('Select More'),
                    icon: const Icon(Icons.upload_file),
                  ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                  onPressed: !isPickingFile
                      ? () {
                          readToolScreenStateProviderValue.updateSelectedFiles(
                            files: [],
                          );
                        }
                      : null,
                  label: const Text('Clear Selection'),
                  icon: const Icon(Icons.clear),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class NoFilesSelected extends StatelessWidget {
  const NoFilesSelected(
      {Key? key, required this.selectFileType, required this.filePickerParams})
      : super(key: key);

  final SelectFileType selectFileType;
  final FilePickerParams filePickerParams;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.scale(
          scale: 4.0,
          child: const SizedBox(
            width: 100,
            height: 100,
            child: RiveAnimation.asset(
              'assets/rive/impatient_placeholder.riv',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Text(
          'Please select ${selectFileType == SelectFileType.multiple || selectFileType == SelectFileType.both ? "some files" : "a file"}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final ToolScreenState readToolScreenStateProviderValue =
                ref.watch(toolScreenStateProvider);
            final bool isPickingFile =
                ref.watch(toolScreenStateProvider).isPickingFile;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
              onPressed: !isPickingFile
                  ? () {
                      readToolScreenStateProviderValue.selectFiles(
                        params: filePickerParams,
                      );
                    }
                  : null,
              child: Text(
                  'Select ${selectFileType == SelectFileType.multiple || selectFileType == SelectFileType.both ? "files" : "file"}'),
            );
          },
        ),
      ],
    );
  }
}

class SelectedFileTile extends StatelessWidget {
  const SelectedFileTile({Key? key, required this.file}) : super(key: key);

  final InputFileModel file;

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
        Navigator.pushNamed(
          context,
          route.pdfScreen,
          arguments: PDFScreenArguments(
              fileName: file.fileName, fileUri: file.fileUri),
        );
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
                file.fileSizeFormatBytes,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      trailing: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final ToolScreenState readToolScreenStateProviderValue =
              ref.watch(toolScreenStateProvider);

          return IconButton(
            style: IconButton.styleFrom(
                // minimumSize: Size.zero,
                // padding: EdgeInsets.zero,
                // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
            onPressed: () {
              final List<InputFileModel> selectedFiles =
                  ref.watch(toolScreenStateProvider).selectedFiles;
              selectedFiles.remove(file);
              readToolScreenStateProviderValue.updateSelectedFiles(
                files: selectedFiles,
              );
            },
            icon: const SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.clear,
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ReorderableFilesListView extends StatefulWidget {
  const ReorderableFilesListView({super.key, required this.files});

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
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(0, 6, animValue)!;
          return Material(
            elevation: 0,
            color: Colors.transparent,
            child: Stack(
              children: [
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
          children: [
            Material(
                color: Colors.transparent,
                child: SelectedFileTile(file: _files[index])),
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
