import 'dart:developer';
import 'dart:typed_data';

import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/image_model.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';

/// It is the input / output files image viewing screen widget.
class ImageViewer extends StatefulWidget {
  /// Defining [ImageViewer] constructor.
  const ImageViewer({Key? key, required this.arguments}) : super(key: key);

  /// Arguments passed when screen pushed.
  final ImageViewerArguments arguments;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late ImageModel imageInfo;

  // Initialization status of [initImageDataState].
  late Future<bool> initImageData;

  // Initializes [imageInfo].
  Future<bool> initImageDataState() async {
    Stopwatch stopwatch = Stopwatch()..start();
    String imageName = widget.arguments.fileName;
    Uint8List? imageBytes;
    bool imageErrorStatus = false;
    String imageErrorMessage = 'Unknown Error';
    StackTrace imageErrorStackTrace = StackTrace.current;
    try {
      imageBytes = await Utility.getByteDataFromFilePathOrUri(
        filePath: widget.arguments.filePath,
        fileUri: widget.arguments.fileUri,
      );
    } catch (e, s) {
      imageErrorStatus = true;
      imageErrorMessage = e.toString();
      imageErrorStackTrace = s;
    }
    imageInfo = ImageModel(
      imageName: imageName,
      imageBytes: imageBytes,
      imageErrorStatus: imageErrorStatus,
      imageErrorMessage: imageErrorMessage,
      imageErrorStackTrace: imageErrorStackTrace,
    );
    log('initImageDataState Executed in ${stopwatch.elapsed}');
    return true;
  }

  @override
  void initState() {
    // Initializing [initImageDataState].
    initImageData = initImageDataState();
    super.initState();
  }

  final TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String imageSingular = appLocale.image(1);
    String loadingText =
        appLocale.tool_Action_LoadingFileOrFiles(imageSingular);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.arguments.fileName),
          // actions: <Widget>[
          //   IconButton(
          //     icon: const Icon(Icons.share),
          //     onPressed: () {},
          //   ),
          // ],
        ),
        body: FutureBuilder<bool>(
          future: initImageData, // async work
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Loading(
                  loadingText: loadingText,
                );
              case ConnectionState.none:
                return Loading(
                  loadingText: loadingText,
                );
              case ConnectionState.active:
                return Loading(
                  loadingText: loadingText,
                );
              case ConnectionState.done:
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return ShowError(
                    taskMessage: 'Failed to load image',
                    errorMessage: snapshot.error.toString(),
                    errorStackTrace: snapshot.stackTrace,
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          fit: StackFit.passthrough,
                          alignment: Alignment.center,
                          children: <Widget>[
                            ImageView(
                              bytes: imageInfo.imageBytes!,
                              frameBuilder: ((
                                final BuildContext context,
                                final Widget child,
                                final int? frame,
                                final bool wasSynchronouslyLoaded,
                              ) {
                                if (wasSynchronouslyLoaded) {
                                  return child;
                                } else {
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: frame != null
                                        ? child
                                        : Loading(
                                            loadingText: loadingText,
                                          ),
                                  );
                                }
                              }),
                              transformationController:
                                  _transformationController,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _transformationController.value =
                                        Matrix4.identity();
                                  });
                                },
                                tooltip: 'Zoom out',
                                icon: const Icon(Icons.zoom_out),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }
}

/// Takes [ImageViewer] arguments passed when screen pushed.
class ImageViewerArguments {
  /// Defining [ImageViewerArguments] constructor.
  ImageViewerArguments({required this.fileName, this.filePath, this.fileUri});

  /// Name of image file viewing.
  final String fileName;

  /// Path of image file.
  final String? filePath;

  /// Uri of image file.
  final String? fileUri;
}

/// Widget that shows a image through provided image bytes.
class ImageView extends StatelessWidget {
  /// Defining [ImageView] constructor.
  const ImageView({
    Key? key,
    required this.bytes,
    this.frameBuilder,
    this.transformationController,
  }) : super(key: key);

  /// Byte data of a image.
  final Uint8List bytes;

  /// Used for showing different widgets for different state of image.
  /// Like loading, error, done.
  final Widget Function(BuildContext, Widget, int?, bool)? frameBuilder;

  /// Used for zooming out of the [InteractiveViewer].
  final TransformationController? transformationController;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 1,
      maxScale: 5,
      transformationController: transformationController,
      child: Image.memory(
        bytes,
        frameBuilder: frameBuilder,
        fit: BoxFit.contain,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return ShowError(
            taskMessage: 'Sorry! Failed to show image',
            errorMessage: error.toString(),
            errorStackTrace: stackTrace,
          );
        },
      ),
    );
  }
}
