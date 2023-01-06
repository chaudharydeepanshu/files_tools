import 'dart:developer';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:extended_image/extended_image.dart';
import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/image_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/custom_keep_alive.dart';
import 'package:files_tools/ui/components/levitating_options_bar.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/utils/edit_image.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Action screen for converting images to PDF.
class ImageToPDF extends StatefulWidget {
  /// Defining [ImageToPDF] constructor.
  const ImageToPDF({Key? key, required this.files}) : super(key: key);

  /// Takes input files.
  final List<InputFileModel> files;

  @override
  State<ImageToPDF> createState() => _ImageToPDFState();
}

class _ImageToPDFState extends State<ImageToPDF> {
  bool createMultiplePdfs = true;

  late List<GlobalKey<ExtendedImageEditorState>> editorKeys;

  AspectRatioItem? _aspectRatio;

  EditorCropLayerPainter? _cropLayerPainter;

  List<ImageModel> imagesInfo = <ImageModel>[];

  late Future<bool> initImagesData;
  Future<bool> initImagesDataState() async {
    Stopwatch stopwatch = Stopwatch()..start();
    for (InputFileModel file in widget.files) {
      String imageName = file.fileName;
      Uint8List? imageBytes;
      bool imageErrorStatus = false;
      String imageErrorMessage = 'Unknown Error';
      StackTrace imageErrorStackTrace = StackTrace.current;
      try {
        imageBytes = await Utility.getByteDataFromFilePathOrUri(
          fileUri: file.fileUri,
        );
      } catch (e, s) {
        imageErrorStatus = true;
        imageErrorMessage = e.toString();
        imageErrorStackTrace = s;
      }
      ImageModel imageInfo = ImageModel(
        imageName: imageName,
        imageBytes: imageBytes,
        imageErrorStatus: imageErrorStatus,
        imageErrorMessage: imageErrorMessage,
        imageErrorStackTrace: imageErrorStackTrace,
      );
      imagesInfo.add(imageInfo);
    }
    log('initImagesDataState Executed in ${stopwatch.elapsed}');
    return true;
  }

  @override
  void initState() {
    initImagesData = initImagesDataState();
    editorKeys = List<GlobalKey<ExtendedImageEditorState>>.generate(
      widget.files.length,
      (int index) => GlobalKey<ExtendedImageEditorState>(),
    );

    _aspectRatio = aspectRatios.first;
    _cropLayerPainter = const EditorCropLayerPainter();
    super.initState();
  }

  int currentIndexOfPageView = 0;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String pdfSingular = appLocale.pdf(1);
    String createMultiplePdf =
        appLocale.tool_Action_CreateMultipleFile(pdfSingular);
    String imageSingular = appLocale.image(1);
    String imagePlural = appLocale.image(2);
    String loadingText = appLocale.tool_Action_LoadingFileOrFiles(
      widget.files.length > 1 ? imagePlural : imageSingular,
    );
    String process = appLocale.button_Process;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
            left: 16.0,
            right: 16.0,
          ),
          child: CheckboxListTile(
            tristate: true,
            visualDensity: VisualDensity.compact,
            title: Text(
              createMultiplePdf,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: createMultiplePdfs,
            onChanged: (bool? value) {
              setState(() {
                createMultiplePdfs = value ?? !createMultiplePdfs;
              });
            },
          ),
        ),
        const Divider(indent: 16.0, endIndent: 16.0, height: 0),
        FutureBuilder<bool>(
          future: initImagesData, // async work
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Expanded(
                  child: Loading(
                    loadingText: loadingText,
                  ),
                );
              case ConnectionState.none:
                return Expanded(
                  child: Loading(
                    loadingText: loadingText,
                  ),
                );
              case ConnectionState.active:
                return Expanded(
                  child: Loading(
                    loadingText: loadingText,
                  ),
                );
              case ConnectionState.done:
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return Expanded(
                    child: ShowError(
                      taskMessage: 'Sorry! Failed to get images data',
                      errorMessage: snapshot.error.toString(),
                      errorStackTrace: snapshot.stackTrace,
                    ),
                  );
                } else {
                  return Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: PageView.custom(
                            onPageChanged: (int index) {
                              setState(() {
                                currentIndexOfPageView = index;
                              });
                            },
                            childrenDelegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return CustomKeepAlive(
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
                                                return Loading(
                                                  loadingText: loadingText,
                                                );
                                              case LoadState.failed:
                                                return ShowError(
                                                  taskMessage:
                                                      'Sorry! Failed to show'
                                                      ' image',
                                                  errorMessage:
                                                      'Image viewer failed to'
                                                      ' load image',
                                                  errorStackTrace:
                                                      state.lastStack,
                                                );
                                              case LoadState.completed:
                                                return null;
                                            }
                                          },
                                          initEditorConfigHandler:
                                              (ExtendedImageState? state) {
                                            return EditorConfig(
                                              maxScale: 8.0,
                                              cropLayerPainter:
                                                  _cropLayerPainter!,
                                              cropAspectRatio:
                                                  _aspectRatio!.value,
                                            );
                                          },
                                          cacheRawData: true,
                                        )
                                      : ShowError(
                                          taskMessage:
                                              'Sorry! Failed to get image data',
                                          errorMessage: imagesInfo[index]
                                              .imageErrorMessage,
                                          errorStackTrace: imagesInfo[index]
                                              .imageErrorStackTrace,
                                        ),
                                  key: ValueKey<InputFileModel>(
                                    widget.files[index],
                                  ),
                                );
                              },
                              childCount: widget.files.length,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: LevitatingOptionsBar(
                            optionsList: <Widget>[
                              Expanded(
                                child: FilledButton.tonal(
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  onPressed: !imagesInfo[currentIndexOfPageView]
                                          .imageErrorStatus
                                      ? () {
                                          editorKeys[currentIndexOfPageView]
                                              .currentState
                                              ?.rotate(right: false);
                                        }
                                      : null,
                                  child: const SizedBox.expand(
                                    child: Icon(Icons.rotate_left),
                                  ),
                                ),
                              ),
                              const VerticalDivider(width: 1),
                              Expanded(
                                child: FilledButton.tonal(
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  onPressed: !imagesInfo[currentIndexOfPageView]
                                          .imageErrorStatus
                                      ? () {
                                          editorKeys[currentIndexOfPageView]
                                              .currentState
                                              ?.rotate();
                                        }
                                      : null,
                                  child: const SizedBox.expand(
                                    child: Icon(Icons.rotate_right),
                                  ),
                                ),
                              ),
                              const VerticalDivider(width: 1),
                              Expanded(
                                child: FilledButton.tonal(
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  onPressed: !imagesInfo[currentIndexOfPageView]
                                          .imageErrorStatus
                                      ? () {
                                          setState(() {
                                            editorKeys[currentIndexOfPageView]
                                                .currentState
                                                ?.flip();
                                          });
                                        }
                                      : null,
                                  child: const SizedBox.expand(
                                    child: Icon(Icons.flip),
                                  ),
                                ),
                              ),
                              const VerticalDivider(width: 1),
                              Expanded(
                                child: FilledButton.tonal(
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  onPressed: !imagesInfo[currentIndexOfPageView]
                                          .imageErrorStatus
                                      ? () {
                                          editorKeys[currentIndexOfPageView]
                                              .currentState
                                              ?.reset();
                                        }
                                      : null,
                                  child: const SizedBox.expand(
                                    child: Icon(Icons.restart_alt),
                                  ),
                                ),
                              ),
                              const VerticalDivider(width: 1),
                              Expanded(
                                flex: 2,
                                child: Consumer(
                                  builder: (
                                    BuildContext context,
                                    WidgetRef ref,
                                    Widget? child,
                                  ) {
                                    final ToolsActionsState
                                        watchToolsActionsStateProviderValue =
                                        ref.watch(toolsActionsStateProvider);

                                    return FilledButton(
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                      ),
                                      onPressed: () {
                                        watchToolsActionsStateProviderValue
                                            .mangeConvertImageFileAction(
                                          toolAction: ToolAction.imageToPdf,
                                          sourceFiles: widget.files
                                              .whereIndexed(
                                                (
                                                  int index,
                                                  InputFileModel element,
                                                ) =>
                                                    imagesInfo[index]
                                                        .imageErrorStatus ==
                                                    false,
                                              )
                                              .toList(),
                                          createSinglePdf: !createMultiplePdfs,
                                          editorKeys: editorKeys
                                              .whereIndexed(
                                                (
                                                  int index,
                                                  GlobalKey element,
                                                ) =>
                                                    imagesInfo[index]
                                                        .imageErrorStatus ==
                                                    false,
                                              )
                                              .toList(),
                                        );

                                        Navigator.pushNamed(
                                          context,
                                          route.AppRoutes.resultPage,
                                        );
                                      },
                                      child: SizedBox.expand(
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              const Icon(Icons.check),
                                              const SizedBox(width: 10),
                                              Text(process),
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
