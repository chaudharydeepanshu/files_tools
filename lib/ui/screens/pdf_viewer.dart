import 'dart:async';
import 'dart:developer';

import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/ui/screens/image_viewer.dart';
import 'package:files_tools/utils/get_pdf_bitmaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_bitmaps/pdf_bitmaps.dart';

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
        pdfPath: widget.arguments.filePathOrUri,
        pdfPageModel: pdfPages[index],
        scale: 2,
      );
      if (mounted) {
        setState(() {
          pdfPages[index] = updatedPdfPage;
          isPageProcessing = false;
        });
      }
    }
  }

  late Future<bool> initPdfPages;
  Future<bool> initPdfPagesState() async {
    Stopwatch stopwatch = Stopwatch()..start();
    PdfValidityAndProtection? pdfValidityAndProtectionInfo = await PdfBitmaps()
        .pdfValidityAndProtection(
            params: PDFValidityAndProtectionParams(
                pdfPath: widget.arguments.filePathOrUri));
    if (pdfValidityAndProtectionInfo == null) {
      throw Exception("Failed to verify pdf validity.");
    } else if (pdfValidityAndProtectionInfo.isPDFValid == false) {
      throw Exception("Pdf is found to be invalid.");
    } else if (pdfValidityAndProtectionInfo.isOpenPasswordProtected == true) {
      throw Exception("Pdf is found to be password protected.");
    }
    pdfPages =
        await generatePdfPagesList(pdfPath: widget.arguments.filePathOrUri);
    if (pdfPages.isEmpty) {
      throw Exception("No pages found for the pdf.");
    }
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
          // actions: <Widget>[
          //   IconButton(
          //     icon: const Icon(Icons.share),
          //     onPressed: () {},
          //   ),
          // ],
        ),
        body: FutureBuilder<bool>(
          future: initPdfPages, // async work
          builder: (context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const LoadingPdf();
              default:
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return ShowError(
                    taskMessage: "Failed to load pdf",
                    errorMessage: snapshot.error.toString(),
                  );
                } else {
                  return PageView.builder(
                    scrollDirection: Axis.vertical,
                    controller: pageController,
                    pageSnapping: false,
                    itemBuilder: (BuildContext context, int index) {
                      updatePdfPages(index: index);
                      if (pdfPages[index].pageErrorStatus) {
                        return PageError(pageIndex: index);
                      } else if (pdfPages[index].pageBytes != null) {
                        return PDFPageView(
                          viewportFraction: pageController.viewportFraction,
                          imageView: PageImageView(
                            bytes: pdfPages[index].pageBytes!,
                          ),
                          pageIndex: index,
                        );
                      } else {
                        return PDFPageView(
                          viewportFraction: pageController.viewportFraction,
                          imageView:
                              const Loading(loadingText: "Loading page..."),
                          pageIndex: index,
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
  final String filePathOrUri;

  PdfViewerArguments({required this.fileName, required this.filePathOrUri});
}

class PageImageView extends StatefulWidget {
  const PageImageView({Key? key, required this.bytes}) : super(key: key);

  final Uint8List bytes;

  @override
  State<PageImageView> createState() => _PageImageViewState();
}

class _PageImageViewState extends State<PageImageView> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        ImageView(
          imageData: widget.bytes,
          frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            } else {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: frame != null
                    ? child
                    : const Loading(loadingText: "Loading page..."),
              );
            }
          }),
          transformationController: _transformationController,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              setState(() {
                _transformationController.value = Matrix4.identity();
              });
            },
            tooltip: 'Zoom out',
            icon: const Icon(Icons.zoom_out),
          ),
        ),
      ],
    );
  }
}

class PDFPageView extends StatelessWidget {
  const PDFPageView(
      {Key? key,
      required this.viewportFraction,
      required this.imageView,
      required this.pageIndex})
      : super(key: key);

  final double viewportFraction;

  final Widget imageView;

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 1 / viewportFraction,
      child: Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Column(
          children: [
            Expanded(
              child: imageView,
            ),
            const SizedBox(height: 8),
            PageNumber(pageIndex: pageIndex),
            const SizedBox(height: 8),
          ],
        ),
      ),
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
          const Loading(loadingText: "Loading page..."),
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
