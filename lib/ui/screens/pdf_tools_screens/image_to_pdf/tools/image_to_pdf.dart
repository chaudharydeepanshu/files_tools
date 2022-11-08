import 'dart:developer';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:extended_image/extended_image.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/image_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/utils/edit_image.dart';
import 'package:files_tools/utils/get_uint8list_from_absolute_file_path_or_uri.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:files_tools/route/route.dart' as route;

import 'package:files_tools/ui/components/view_error.dart';

class ImageToPDF extends StatefulWidget {
  const ImageToPDF({Key? key, required this.files}) : super(key: key);

  final List<InputFileModel> files;

  @override
  State<ImageToPDF> createState() => _ImageToPDFState();
}

class _ImageToPDFState extends State<ImageToPDF> {
  bool createMultiplePdfs = true;

  late List<GlobalKey<ExtendedImageEditorState>> editorKeys;

  AspectRatioItem? _aspectRatio;

  EditorCropLayerPainter? _cropLayerPainter;

  List<ImageModel> imagesInfo = [];

  late Future<bool> initImagesData;
  Future<bool> initImagesDataState() async {
    Stopwatch stopwatch = Stopwatch()..start();
    for (var file in widget.files) {
      String imageName = file.fileName;
      Uint8List? imageBytes;
      bool imageErrorStatus = false;
      String imageError = "Unknown Error";
      try {
        imageBytes = await getBytesFromFilePathOrUri(
            filePath: null, fileUri: file.fileUri);
      } catch (e) {
        imageErrorStatus = true;
        imageError = e.toString();
      }
      ImageModel imageInfo = ImageModel(
          imageName: imageName,
          imageBytes: imageBytes,
          imageErrorStatus: imageErrorStatus,
          imageError: imageError);
      imagesInfo.add(imageInfo);
    }
    log('initImagesDataState Executed in ${stopwatch.elapsed}');
    return true;
  }

  @override
  void initState() {
    initImagesData = initImagesDataState();
    editorKeys = List.generate(
        widget.files.length, (index) => GlobalKey<ExtendedImageEditorState>());

    _aspectRatio = aspectRatios.first;
    _cropLayerPainter = const EditorCropLayerPainter();
    super.initState();
  }

  int currentIndexOfPageView = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
          child: CheckboxListTile(
              tristate: true,
              tileColor: Theme.of(context).colorScheme.surfaceVariant,
              // contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              title: Text("Create Multiple PDFs",
                  style: Theme.of(context).textTheme.bodyMedium),
              value: createMultiplePdfs,
              onChanged: (bool? value) {
                setState(() {
                  createMultiplePdfs = value ?? !createMultiplePdfs;
                });
              }),
        ),
        const Divider(indent: 16.0, endIndent: 16.0),
        FutureBuilder<bool>(
          future: initImagesData, // async work
          builder: (context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Expanded(
                    child: Loading(loadingText: "Loading images..."));
              default:
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return Expanded(
                    child: ShowError(
                      taskMessage: 'Sorry! Failed to get images data',
                      errorMessage: snapshot.error.toString(),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.custom(
                            onPageChanged: (int index) {
                              setState(() {
                                currentIndexOfPageView = index;
                              });
                            },
                            childrenDelegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return KeepAlive(
                                  widget: !imagesInfo[index].imageErrorStatus
                                      ? ExtendedImage.memory(
                                          imagesInfo[index].imageBytes!,
                                          fit: BoxFit.contain,
                                          mode: ExtendedImageMode.editor,
                                          enableLoadState: true,
                                          extendedImageEditorKey:
                                              editorKeys[index],
                                          loadStateChanged:
                                              (ExtendedImageState state) {
                                            switch (
                                                state.extendedImageLoadState) {
                                              case LoadState.loading:
                                                return const Loading(
                                                  loadingText:
                                                      'Loading image...',
                                                );
                                              case LoadState.failed:
                                                // Todo: Should remove images from processing that failed to load. But first verify if they are capable of loading without waiting for user to load them.
                                                return const ShowError(
                                                  taskMessage:
                                                      'Sorry! Failed to show image',
                                                  errorMessage:
                                                      'Image viewer failed to load image',
                                                );
                                              case LoadState.completed:
                                                return null;
                                            }
                                          },
                                          initEditorConfigHandler:
                                              (ExtendedImageState? state) {
                                            return EditorConfig(
                                              maxScale: 8.0,
                                              cropRectPadding:
                                                  const EdgeInsets.all(20.0),
                                              hitTestSize: 20.0,
                                              cropLayerPainter:
                                                  _cropLayerPainter!,
                                              initCropRectType:
                                                  InitCropRectType.imageRect,
                                              cropAspectRatio:
                                                  _aspectRatio!.value,
                                            );
                                          },
                                          cacheRawData: true,
                                        )
                                      : ShowError(
                                          taskMessage:
                                              'Sorry! Failed to get image data',
                                          errorMessage:
                                              imagesInfo[index].imageError,
                                        ),
                                  key: ValueKey<InputFileModel>(
                                      widget.files[index]),
                                );
                              },
                              childCount: widget.files.length,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 30.0, left: 30, right: 30),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: BottomAppBar(
                                child: SizedBox(
                                  height: 70,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: FilledButton.tonal(
                                          style: FilledButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          onPressed: !imagesInfo[
                                                      currentIndexOfPageView]
                                                  .imageErrorStatus
                                              ? () {
                                                  editorKeys[
                                                          currentIndexOfPageView]
                                                      .currentState
                                                      ?.rotate(right: false);
                                                }
                                              : null,
                                          child: const SizedBox.expand(
                                              child: Icon(Icons.rotate_left)),
                                        ),
                                      ),
                                      const VerticalDivider(width: 1),
                                      Expanded(
                                        flex: 1,
                                        child: FilledButton.tonal(
                                          style: FilledButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          onPressed: !imagesInfo[
                                                      currentIndexOfPageView]
                                                  .imageErrorStatus
                                              ? () {
                                                  editorKeys[
                                                          currentIndexOfPageView]
                                                      .currentState
                                                      ?.rotate(right: true);
                                                }
                                              : null,
                                          child: const SizedBox.expand(
                                              child: Icon(Icons.rotate_right)),
                                        ),
                                      ),
                                      const VerticalDivider(width: 1),
                                      Expanded(
                                        flex: 1,
                                        child: FilledButton.tonal(
                                          style: FilledButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          onPressed: !imagesInfo[
                                                      currentIndexOfPageView]
                                                  .imageErrorStatus
                                              ? () {
                                                  setState(() {
                                                    editorKeys[
                                                            currentIndexOfPageView]
                                                        .currentState
                                                        ?.flip();
                                                  });
                                                }
                                              : null,
                                          child: const SizedBox.expand(
                                              child: Icon(Icons.flip)),
                                        ),
                                      ),
                                      const VerticalDivider(width: 1),
                                      Expanded(
                                        flex: 1,
                                        child: FilledButton.tonal(
                                          style: FilledButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          onPressed: !imagesInfo[
                                                      currentIndexOfPageView]
                                                  .imageErrorStatus
                                              ? () {
                                                  editorKeys[
                                                          currentIndexOfPageView]
                                                      .currentState
                                                      ?.reset();
                                                }
                                              : null,
                                          child: const SizedBox.expand(
                                              child: Icon(Icons.restart_alt)),
                                        ),
                                      ),
                                      const VerticalDivider(width: 1),
                                      Expanded(
                                        flex: 2,
                                        child: Consumer(
                                          builder: (BuildContext context,
                                              WidgetRef ref, Widget? child) {
                                            final ToolsActionsState
                                                watchToolsActionsStateProviderValue =
                                                ref.watch(
                                                    toolsActionsStateProvider);

                                            return FilledButton(
                                              style: FilledButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0)),
                                              ),
                                              onPressed: () {
                                                watchToolsActionsStateProviderValue
                                                    .imageToPdf(
                                                  files: widget.files
                                                      .whereIndexed((index,
                                                              element) =>
                                                          imagesInfo[index]
                                                              .imageErrorStatus ==
                                                          false)
                                                      .toList(),
                                                  createSinglePdf:
                                                      !createMultiplePdfs,
                                                  editorKeys: editorKeys
                                                      .whereIndexed((index,
                                                              element) =>
                                                          imagesInfo[index]
                                                              .imageErrorStatus ==
                                                          false)
                                                      .toList(),
                                                );

                                                Navigator.pushNamed(
                                                  context,
                                                  route.resultPage,
                                                );
                                              },
                                              child: SizedBox.expand(
                                                child: Center(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: const [
                                                      Icon(Icons.check),
                                                      SizedBox(width: 10),
                                                      Text("Process"),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
            }
          },
        ),
      ],
    );
  }
}

class KeepAlive extends StatefulWidget {
  const KeepAlive({super.key, required this.widget});

  final Widget widget;

  @override
  State<KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.widget;
  }
}