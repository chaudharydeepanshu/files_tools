import 'dart:developer';
import 'dart:typed_data';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/utils/get_uint8list_from_absolute_file_path_or_uri.dart';
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
    imageData = await getBytesFromFilePathOrUri(
        filePath: widget.arguments.filePath, fileUri: widget.arguments.fileUri);
    log('initImageDataState Executed in ${stopwatch.elapsed}');
    return true;
  }

  @override
  void initState() {
    initImageData = initImageDataState();
    super.initState();
  }

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
          builder: (context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Loading(loadingText: "Loading image...");
              default:
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return ShowError(
                    taskMessage: "Failed to load image",
                    errorMessage: snapshot.error.toString(),
                  );
                } else {
                  return Center(
                    child: ImageView(
                      imageData: imageData!,
                    ),
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
  final String fileName;
  final String? filePath;
  final String? fileUri;

  ImageViewerArguments({required this.fileName, this.filePath, this.fileUri});
}

class ImageView extends StatelessWidget {
  const ImageView({Key? key, required this.imageData}) : super(key: key);

  final Uint8List imageData;

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      imageData,
      frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        } else {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: frame != null
                ? child
                : const Loading(loadingText: "Loading image..."),
          );
        }
      }),
      fit: BoxFit.contain,
    );
    //   ExtendedImage.memory(
    //   imageData,
    //   fit: BoxFit.contain,
    //   mode: ExtendedImageMode.gesture,
    //   enableLoadState: true,
    //   cacheRawData: true,
    // );
  }
}
