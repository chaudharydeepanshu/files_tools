import 'dart:async';
import 'dart:developer';

import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/ui/screens/image_viewer.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_bitmaps/pdf_bitmaps.dart';

/// It is the input / output files PDF viewing screen widget.
class PdfViewer extends StatefulWidget {
  /// Defining [PdfViewer] constructor.
  const PdfViewer({Key? key, required this.arguments}) : super(key: key);

  /// Arguments passed when screen pushed.
  final PdfViewerArguments arguments;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  // Controller to control the PdfViewer PDF pages.
  final PageController pageController = PageController(viewportFraction: 1.02);

  // Is true if PDF an page is currently being processed.
  bool isPageProcessing = false;

  // List of models of PDF pages used to get various information about
  // a specific page of PDF.
  late List<PdfPageModel> pdfPages;

  // Updates models in [pdfPages] as user scrolls.
  void updatePdfPages({required int index}) async {
    if (pdfPages[index].pageBytes == null &&
        pdfPages[index].pageErrorStatus == false &&
        isPageProcessing == false) {
      isPageProcessing = true;
      PdfPageModel updatedPdfPage = await Utility.getUpdatedPdfPageModel(
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

  // Initialization status of [initPdfPagesState].
  late Future<bool> initPdfPages;

  // Initializes [pdfPages] with a dummy models list with the total page count
  // of a PDF.
  Future<bool> initPdfPagesState() async {
    Stopwatch stopwatch = Stopwatch()..start();
    PdfValidityAndProtection? pdfValidityAndProtectionInfo =
        await PdfBitmaps().pdfValidityAndProtection(
      params: PDFValidityAndProtectionParams(
        pdfPath: widget.arguments.filePathOrUri,
      ),
    );
    if (pdfValidityAndProtectionInfo == null) {
      throw Exception('Failed to verify pdf validity.');
    } else if (pdfValidityAndProtectionInfo.isPDFValid == false) {
      throw Exception('Pdf is found to be invalid.');
    } else if (pdfValidityAndProtectionInfo.isOpenPasswordProtected == true) {
      throw Exception('Pdf is found to be password protected.');
    }
    pdfPages = await Utility.generatePdfPagesList(
      pdfPath: widget.arguments.filePathOrUri,
    );
    if (pdfPages.isEmpty) {
      throw Exception('No pages found for the pdf.');
    }
    log('initPdfPagesState Executed in ${stopwatch.elapsed}');
    return true;
  }

  @override
  void initState() {
    // Initializing [pdfPages].
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
          future: initPdfPages,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const LoadingPdf();
              case ConnectionState.none:
                return const LoadingPdf();
              case ConnectionState.active:
                return const LoadingPdf();
              case ConnectionState.done:
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return ShowError(
                    taskMessage: 'Failed to load pdf',
                    errorMessage: snapshot.error.toString(),
                    errorStackTrace: snapshot.stackTrace,
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
                              const Loading(loadingText: 'Loading page...'),
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

/// Takes [PdfViewer] arguments passed when screen pushed.
class PdfViewerArguments {
  /// Defining [PdfViewerArguments] constructor.
  PdfViewerArguments({required this.fileName, required this.filePathOrUri});

  /// Name of PDF file viewing.
  final String fileName;

  /// Path or Uri of PDF file.
  final String filePathOrUri;
}

/// Widget that shows a PDF page image through provided image bytes.
class PageImageView extends StatefulWidget {
  /// Defining [PageImageView] constructor.
  const PageImageView({Key? key, required this.bytes}) : super(key: key);

  /// Byte data of a PDF page image.
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
      children: <Widget>[
        Align(
          child: ImageView(
            bytes: widget.bytes,
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
                      : const Loading(loadingText: 'Loading page...'),
                );
              }
            }),
            transformationController: _transformationController,
          ),
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

/// Widget that creates the [PDFViewer] individual page.
class PDFPageView extends StatelessWidget {
  /// Defining [PDFPageView] constructor.
  const PDFPageView({
    Key? key,
    required this.viewportFraction,
    required this.imageView,
    required this.pageIndex,
  }) : super(key: key);

  /// Viewport fraction of the [PageView] to determine space between each page
  /// when scrolled.
  final double viewportFraction;

  /// Takes the widget that shows a PDF page image.
  final Widget imageView;

  /// Takes the PDF page index for which the page be created.
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 1 / viewportFraction,
      child: Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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

/// Widget for showing loading indicator for PDF in [PDFViewer].
class LoadingPdf extends StatelessWidget {
  /// Defining [LoadingPdf] constructor.
  const LoadingPdf({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Loading(loadingText: 'Loading page...'),
          const SizedBox(height: 16),
          Text('Loading pdf...', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// Widget for showing page number indicator for PDF pages in [PDFViewer].
class PageNumber extends StatelessWidget {
  /// Defining [PageNumber] constructor.
  const PageNumber({Key? key, required this.pageIndex}) : super(key: key);

  /// Takes the PDF page index for which the page number indicator be created.
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(
          'Page - ${pageIndex + 1}',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
        ),
      ),
    );
  }
}

/// Widget for showing error indicator for PDF pages in [PDFViewer].
class PageError extends StatelessWidget {
  /// Defining [PageError] constructor.
  const PageError({Key? key, required this.pageIndex}) : super(key: key);

  /// Takes the PDF page index for which the page error indicator be created.
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.error, color: Theme.of(context).colorScheme.error),
        const SizedBox(height: 16),
        Text(
          'Failed to load page',
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
