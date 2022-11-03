import 'dart:developer';
import 'dart:ui';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/select_file_state.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/image_viewer.dart';
import 'package:files_tools/ui/screens/pdf_viewer.dart';
import 'package:files_tools/utils/clear_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:files_tools/route/route.dart' as route;

enum SelectImageType { single, multiple, both }

class SelectImagesCard extends StatelessWidget {
  const SelectImagesCard({
    Key? key,
    required this.selectImageType,
    required this.images,
    this.allowedExtensions,
  }) : super(key: key);

  final SelectImageType selectImageType;
  final List<InputFileModel> images;
  final List<String>? allowedExtensions;

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
              images.isNotEmpty
                  ? Flexible(
                      child: ImagesSelected(
                        selectImageType: selectImageType,
                        images: images,
                        allowedExtensions: allowedExtensions,
                      ),
                    )
                  : NoImagesSelected(
                      selectImageType: selectImageType,
                      allowedExtensions: allowedExtensions,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImagesSelected extends StatelessWidget {
  const ImagesSelected(
      {Key? key,
      required this.selectImageType,
      required this.images,
      this.allowedExtensions})
      : super(key: key);

  final SelectImageType selectImageType;
  final List<InputFileModel> images;
  final List<String>? allowedExtensions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: images.length > 1
                ? ReorderableImagesListView(images: images)
                : SelectedImageTile(image: images[0])),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final bool isPickingImage =
                ref.watch(toolScreenStateProvider).isPickingImage;
            return isPickingImage
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Text('Picking images please wait ...',
                          style: Theme.of(context).textTheme.bodySmall),
                      const Divider()
                    ],
                  )
                : selectImageType == SelectImageType.multiple &&
                        images.length == 1
                    ? Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'Please select at least one more image',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Theme.of(context).colorScheme.error),
                          ),
                          const Divider()
                        ],
                      )
                    : selectImageType == SelectImageType.multiple &&
                            images.length > 1
                        ? Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                'Long press on images to reorder them',
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
            final bool isPickingImage =
                ref.watch(toolScreenStateProvider).isPickingImage;
            return Wrap(
              spacing: 10,
              children: [
                if (selectImageType == SelectImageType.multiple ||
                    selectImageType == SelectImageType.both)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    onPressed: !isPickingImage
                        ? () {
                            // Removing any snack bar or keyboard
                            FocusManager.instance.primaryFocus?.unfocus();
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            readToolScreenStateProviderValue.selectImages(
                                selectImageType: selectImageType,
                                allowedExtensions: allowedExtensions);
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
                  onPressed: !isPickingImage
                      ? () {
                          // Removing any snack bar or keyboard
                          FocusManager.instance.primaryFocus?.unfocus();
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          readToolScreenStateProviderValue.updateSelectedImages(
                            images: [],
                          );
                          clearCache(
                              clearCacheCommandFrom: "Clear Image Selection");
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

class NoImagesSelected extends StatelessWidget {
  const NoImagesSelected(
      {Key? key, required this.selectImageType, this.allowedExtensions})
      : super(key: key);

  final SelectImageType selectImageType;
  final List<String>? allowedExtensions;

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
          'Please select ${selectImageType == SelectImageType.multiple || selectImageType == SelectImageType.both ? "some images" : "a image"}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final ToolScreenState readToolScreenStateProviderValue =
                ref.watch(toolScreenStateProvider);
            final bool isPickingImage =
                ref.watch(toolScreenStateProvider).isPickingImage;
            return ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
              onPressed: !isPickingImage
                  ? () {
                      // Removing any snack bar or keyboard
                      FocusManager.instance.primaryFocus?.unfocus();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      readToolScreenStateProviderValue.selectImages(
                        selectImageType: selectImageType,
                        allowedExtensions: allowedExtensions,
                      );
                    }
                  : null,
              label: Text(
                  'Select ${selectImageType == SelectImageType.multiple || selectImageType == SelectImageType.both ? "images" : "image"}'),
              icon: const Icon(Icons.upload_file),
            );
          },
        ),
      ],
    );
  }
}

class SelectedImageTile extends StatelessWidget {
  const SelectedImageTile({Key? key, required this.image}) : super(key: key);

  final InputFileModel image;

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
        String fileExtension = getFileNameExtension(fileName: image.fileName);
        if (fileExtension.toLowerCase() == ".pdf") {
          Navigator.pushNamed(
            context,
            route.pdfViewer,
            arguments: PdfViewerArguments(
                fileName: image.fileName, filePathOrUri: image.fileUri),
          );
        } else if (fileExtension.toLowerCase() == ".png" ||
            fileExtension.toLowerCase() == ".jpg" ||
            fileExtension.toLowerCase() == ".jpeg" ||
            fileExtension.toLowerCase() == ".webp") {
          Navigator.pushNamed(
            context,
            route.imageViewer,
            arguments: ImageViewerArguments(
                fileName: image.fileName, filePath: image.fileUri),
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
        image.fileName,
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
              child: Text(image.fileDate,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis),
            ),
            const VerticalDivider(),
            Expanded(
              flex: 3,
              child: Text(
                image.fileTime,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const VerticalDivider(),
            Expanded(
              flex: 5,
              child: Text(
                image.fileSizeFormatBytes,
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
              final List<InputFileModel> selectedImages =
                  ref.watch(toolScreenStateProvider).selectedImages;
              selectedImages.remove(image);
              readToolScreenStateProviderValue.updateSelectedImages(
                images: selectedImages,
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

class ReorderableImagesListView extends StatefulWidget {
  const ReorderableImagesListView({super.key, required this.images});

  final List<InputFileModel> images;

  @override
  State<ReorderableImagesListView> createState() =>
      _ReorderableImagesListViewState();
}

class _ReorderableImagesListViewState extends State<ReorderableImagesListView> {
  late List<InputFileModel> _images = widget.images;

  @override
  void didUpdateWidget(covariant ReorderableImagesListView oldWidget) {
    if (widget.images != oldWidget.images) {
      setState(() {
        _images = widget.images;
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
      shrinkWrap: _images.length < 10,
      proxyDecorator: proxyDecorator,
      itemCount: _images.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          key: Key('$index'),
          children: [
            Material(
                color: Colors.transparent,
                child: SelectedImageTile(image: _images[index])),
            index != _images.length - 1
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
          final InputFileModel item = _images.removeAt(oldIndex);
          _images.insert(newIndex, item);
        });
      },
    );
  }
}
