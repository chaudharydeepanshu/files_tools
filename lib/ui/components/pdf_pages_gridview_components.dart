import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:flutter/material.dart';

/// Widget for displaying a PDF page used inside gridview of pages.
class GridImageWidget extends StatelessWidget {
  /// Defining [GridImageWidget] constructor.
  const GridImageWidget({Key? key, required this.child}) : super(key: key);

  /// Takes widget for different states of pages like loading, error, image.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: child,
    );
  }
}

/// Widget for displaying a position index under the dragging image.
class GridImagePlaceholderWidget extends StatelessWidget {
  /// Defining [GridImagePlaceholderWidget] constructor.
  const GridImagePlaceholderWidget({Key? key, required this.index})
      : super(key: key);

  /// Takes index to be shown in place of placeholder.
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      elevation: 0,
      // color: Theme.of(context).colorScheme.surfaceVariant,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          (index + 1).toString(),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

/// Widget for displaying a loaded PDF page inside [GridImageWidget].
class PageImageView extends StatelessWidget {
  /// Defining [PageImageView] constructor.
  const PageImageView({
    Key? key,
    required this.pageIndex,
    required this.pdfPage,
    this.onUpdatePdfPage,
  }) : super(key: key);

  /// Model of PDF page.
  final PdfPageModel pdfPage;

  /// PDF page index.
  final int pageIndex;

  /// Click action for PDF page.
  final ValueChanged<PdfPageModel>? onUpdatePdfPage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform.scale(
          scale: pdfPage.pageSelected ? 0.7 : 1,
          child: Stack(
            children: <Widget>[
              RotationTransition(
                turns: AlwaysStoppedAnimation<double>(
                  pdfPage.pageRotationAngle / 360,
                ),
                child: Center(
                  child: Image.memory(
                    pdfPage.pageBytes!,
                    frameBuilder: ((
                      BuildContext context,
                      Widget child,
                      int? frame,
                      bool wasSynchronouslyLoaded,
                    ) {
                      if (wasSynchronouslyLoaded) {
                        return FittedBox(
                          child: ImageChild(pageIndex: pageIndex, child: child),
                        );
                      } else {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: frame != null
                              ? FittedBox(
                                  child: ImageChild(
                                    pageIndex: pageIndex,
                                    child: child,
                                  ),
                                )
                              : const LoadingIndicator(),
                        );
                      }
                    }),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 2.0,
                      ),
                      child: Text(
                        (pageIndex + 1).toString(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: pdfPage.pageSelected
              ? Icon(
                  Icons.check_circle,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                )
              : Icon(
                  Icons.check_circle_outline,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              PdfPageModel temp = pdfPage;
              temp = PdfPageModel(
                pageIndex: temp.pageIndex,
                pageBytes: temp.pageBytes,
                pageErrorStatus: temp.pageErrorStatus,
                pageSelected: !temp.pageSelected,
                pageRotationAngle: temp.pageRotationAngle,
                pageHidden: temp.pageHidden,
              );
              onUpdatePdfPage?.call(temp);
            },
          ),
        ),
      ],
    );
  }
}

/// Widget for displaying a loaded PDF page image inside [PageImageView].
class ImageChild extends StatelessWidget {
  /// Defining [ImageChild] constructor.
  const ImageChild({Key? key, required this.child, required this.pageIndex})
      : super(key: key);

  /// PDF page image widget.
  final Widget child;

  /// PDF page index.
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(color: Colors.white, child: child),
      ],
    );
  }
}
