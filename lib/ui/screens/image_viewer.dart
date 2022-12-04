import 'dart:developer';
import 'dart:typed_data';

import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({Key? key, required this.arguments}) : super(key: key);

  final ImageViewerArguments arguments;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  Uint8List? imageData;

  late Future<bool> initImageData;
  Future<bool> initImageDataState() async {
    Stopwatch stopwatch = Stopwatch()..start();
    // Todo: Look is using ImageModel here will suit or not.
    imageData = await Utility.getBytesFromFilePathOrUri(
      filePath: widget.arguments.filePath,
      fileUri: widget.arguments.fileUri,
    );
    log('initImageDataState Executed in ${stopwatch.elapsed}');
    return true;
  }

  @override
  void initState() {
    initImageData = initImageDataState();
    super.initState();
  }

  final TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
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
                return const Loading(loadingText: 'Loading image...');
              default:
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return ShowError(
                    taskMessage: 'Failed to load image',
                    errorMessage: snapshot.error.toString(),
                    errorStackTrace: snapshot.stackTrace,
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.passthrough,
                          alignment: Alignment.center,
                          children: [
                            ImageView(
                              imageData: imageData!,
                              frameBuilder: ((
                                BuildContext context,
                                Widget child,
                                int? frame,
                                bool wasSynchronouslyLoaded,
                              ) {
                                if (wasSynchronouslyLoaded) {
                                  return child;
                                } else {
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: frame != null
                                        ? child
                                        : const Loading(
                                            loadingText: 'Loading image...',
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

class ImageViewerArguments {
  ImageViewerArguments({required this.fileName, this.filePath, this.fileUri});
  final String fileName;
  final String? filePath;
  final String? fileUri;
}

class ImageView extends StatelessWidget {
  const ImageView({
    Key? key,
    required this.imageData,
    this.frameBuilder,
    this.transformationController,
  }) : super(key: key);

  final Uint8List imageData;
  final Widget Function(BuildContext, Widget, int?, bool)? frameBuilder;
  final TransformationController? transformationController;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 1,
      maxScale: 5,
      transformationController: transformationController,
      child: Image.memory(
        imageData,
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
//   ExtendedImage.memory(
//       imageData,
//       fit: BoxFit.contain,
//       mode: ExtendedImageMode.gesture,
//       enableLoadState: true,
//       cacheRawData: true,
//       loadStateChanged: (ExtendedImageState state) {
//         switch (state.extendedImageLoadState) {
//           case LoadState.loading:
//             return const Loading(
//               loadingText: 'Loading image...',
//             );
//           case LoadState.failed:
//             return const ShowError(
//               taskMessage: 'Sorry! Failed to show image',
//               errorMessage: 'Image viewer failed to load image',
//             );
//           case LoadState.completed:
//             return null;
//         }
//       },
//       clearMemoryCacheWhenDispose: true,
//       clearMemoryCacheIfFailed: true,
//     );
  }
}
