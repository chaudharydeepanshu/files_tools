import 'dart:async';
import 'dart:developer';

import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/utils/get_pdf_bitmaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({Key? key, required this.arguments}) : super(key: key);

  final PdfViewerArguments arguments;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final pageController = PageController(viewportFraction: 1.02);

  bool isPageProcessing = false;

  List<PdfPageModel> pdfPages = [];

  void updatePdfPages({required int index}) async {
    if (pdfPages[index].pageBytes == null &&
        pdfPages[index].pageErrorStatus == false &&
        isPageProcessing == false) {
      isPageProcessing = true;
      PdfPageModel updatedPdfPage = await getUpdatedPdfPage(
        index: index,
        pdfPath: widget.arguments.filePath,
        pdfPageModel: pdfPages[index],
      );
      setState(() {
        pdfPages[index] = updatedPdfPage;
        isPageProcessing = false;
      });
    }
  }

  late Future<bool> initPdfPages;
  Future<bool> initPdfPagesState() async {
    Stopwatch stopwatch = Stopwatch()..start();
    pdfPages = await generatePdfPagesList(pdfPath: widget.arguments.filePath);
    log('initPdfPagesState Executed in ${stopwatch.elapsed}');
    return true;
  }

  @override
  void initState() {
    initPdfPages = initPdfPagesState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.arguments.fileName),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        body:
            // Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Flexible(
            //       child: Image.memory(
            //         pdfPages[1].pageBytes!,
            //         // frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
            //         //   if (wasSynchronouslyLoaded) {
            //         //     return ImageChild(pageIndex: 1, child: child);
            //         //   } else {
            //         //     return AnimatedSwitcher(
            //         //       duration: const Duration(milliseconds: 200),
            //         //       child: frame != null
            //         //           ? ImageChild(pageIndex: 1, child: child)
            //         //           : LoadingPage(pageIndex: 1),
            //         //     );
            //         //   }
            //         // }),
            //         fit: BoxFit.contain,
            //       ),
            //     ),
            //     const SizedBox(height: 16),
            //     PageNumber(pageIndex: 1),
            //   ],
            // )
            FutureBuilder<bool>(
          future: initPdfPages, // async work
          builder: (context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const LoadingPdf();
              default:
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return const PdfLoadingError();
                } else if (pdfPages.isEmpty) {
                  log(snapshot.error.toString());
                  return const PdfLoadingError();
                } else {
                  return PageView.builder(
                    scrollDirection: Axis.vertical,
                    controller: pageController,
                    pageSnapping: false,
                    itemBuilder: (BuildContext context, int index) {
                      updatePdfPages(index: index);
                      if (pdfPages[index].pageErrorStatus) {
                        log(snapshot.error.toString());
                        return PageError(pageIndex: index);
                      } else if (pdfPages[index].pageBytes != null) {
                        return PDFPageView(
                          viewportFraction: pageController.viewportFraction,
                          page: PageImageView(
                            bytes: pdfPages[index].pageBytes!,
                            pageIndex: index,
                          ),
                        );
                      } else {
                        return PDFPageView(
                          viewportFraction: pageController.viewportFraction,
                          page: LoadingPage(pageIndex: index),
                        );
                      }
                    },
                    itemCount: pdfPages.length,
                  );
                }
            }
          },
        ),
      ),
    );
  }
}

class PdfViewerArguments {
  final String fileName;
  final String filePath;

  PdfViewerArguments({required this.fileName, required this.filePath});
}

class PageImageView extends StatelessWidget {
  const PageImageView({Key? key, required this.bytes, required this.pageIndex})
      : super(key: key);

  final Uint8List bytes;

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      bytes,
      frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return ImageChild(pageIndex: pageIndex, child: child);
        } else {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: frame != null
                ? ImageChild(pageIndex: pageIndex, child: child)
                : LoadingPage(pageIndex: pageIndex),
          );
        }
      }),
      fit: BoxFit.contain,
    );
  }
}

class ImageChild extends StatelessWidget {
  const ImageChild({Key? key, required this.child, required this.pageIndex})
      : super(key: key);

  final Widget child;

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: child),
          const SizedBox(height: 8),
          PageNumber(pageIndex: pageIndex),
        ],
      ),
    );
  }
}

class PDFPageView extends StatelessWidget {
  const PDFPageView(
      {Key? key, required this.viewportFraction, required this.page})
      : super(key: key);

  final double viewportFraction;

  final Widget page;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 1 / viewportFraction,
      child: Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: page,
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key, required this.pageIndex}) : super(key: key);

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text("Loading page...", style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 16),
        PageNumber(pageIndex: pageIndex),
      ],
    );
  }
}

class LoadingPdf extends StatelessWidget {
  const LoadingPdf({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text("Loading pdf...", style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class PageNumber extends StatelessWidget {
  const PageNumber({Key? key, required this.pageIndex}) : super(key: key);

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.onSurfaceVariant),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text("Page - ${pageIndex + 1}",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.surfaceVariant)),
      ),
    );
  }
}

class PageError extends StatelessWidget {
  const PageError({Key? key, required this.pageIndex}) : super(key: key);

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, color: Theme.of(context).colorScheme.error),
        const SizedBox(height: 16),
        Text(
          "Failed to load page",
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
        const SizedBox(height: 16),
        PageNumber(pageIndex: pageIndex),
      ],
    );
  }
}

class PdfLoadingError extends StatelessWidget {
  const PdfLoadingError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text(
            "Failed to load pdf",
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
    );
  }
}
