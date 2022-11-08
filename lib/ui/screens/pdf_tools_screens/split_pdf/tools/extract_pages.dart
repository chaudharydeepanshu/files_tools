import 'package:collection/collection.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/components/pdf_page_small_bitmap_error.dart';
import 'package:files_tools/ui/screens/components/pdf_page_small_bitmap_loading.dart';
import 'package:files_tools/utils/get_pdf_bitmaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:files_tools/route/route.dart' as route;

class ExtractByPageSelection extends StatefulWidget {
  const ExtractByPageSelection(
      {Key? key, required this.pdfPages, required this.file})
      : super(key: key);

  final List<PdfPageModel> pdfPages;
  final InputFileModel file;

  @override
  State<ExtractByPageSelection> createState() => _ExtractByPageSelectionState();
}

class _ExtractByPageSelectionState extends State<ExtractByPageSelection> {
  bool isPageProcessing = false;

  late List<PdfPageModel> pdfPages = List.from(widget.pdfPages);

  void updatePdfPages({required int index}) async {
    if (pdfPages[index].pageBytes == null &&
        pdfPages[index].pageErrorStatus == false &&
        isPageProcessing == false) {
      isPageProcessing = true;
      PdfPageModel updatedPdfPage = await getUpdatedPdfPage(
        index: index,
        pdfPath: widget.file.fileUri,
        scale: 0.3,
        pdfPageModel: pdfPages[index],
      );
      setState(() {
        pdfPages[index] = updatedPdfPage;
        isPageProcessing = false;
      });
    }
  }

  double scrollSpeedVariable = 5;

  bool? isSelectAllEnabled = false;

  late List<int> removedPdfPagesIndexes = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ReorderableGridView.builder(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 1,
                  maxCrossAxisExtent: 150,
                  mainAxisExtent: 150,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: pdfPages.length,
                placeholderBuilder:
                    (int oldIndex, int newIndex, Widget widget) {
                  return GridElementPlaceholder(index: newIndex);
                },
                dragWidgetBuilder: (int index, Widget widget) {
                  return Transform.scale(
                    scale: 1.1,
                    child: GridElement(
                        child: PageImageView(
                      pdfPage: pdfPages[index],
                      pageIndex: index,
                    )),
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  updatePdfPages(index: index);
                  if (pdfPages[index].pageErrorStatus) {
                    return GridElement(
                        key: Key('$index'),
                        child: const ErrorPageSmallBitmap());
                  } else if (pdfPages[index].pageBytes != null) {
                    return GridElement(
                      key: Key('$index'),
                      child: PageImageView(
                        pdfPage: pdfPages[index],
                        pageIndex: index,
                        onUpdatePdfPage: (PdfPageModel value) {
                          setState(() {
                            pdfPages[index] = value;
                          });
                          if (isSelectAllEnabled == null) {
                            if (pdfPages.every(
                                (PdfPageModel w) => w.pageSelected == true)) {
                              setState(() {
                                isSelectAllEnabled = true;
                              });
                            } else if (pdfPages.every(
                                (PdfPageModel w) => w.pageSelected == false)) {
                              setState(() {
                                isSelectAllEnabled = false;
                              });
                            }
                          } else if (isSelectAllEnabled == true ||
                              isSelectAllEnabled == false) {
                            setState(() {
                              isSelectAllEnabled = null;
                            });
                          }
                        },
                      ),
                    );
                  } else {
                    return GridElement(
                        key: Key('$index'),
                        child: const LoadingPageSmallBitmap());
                  }
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    final element = pdfPages.removeAt(oldIndex);
                    pdfPages.insert(newIndex, element);
                  });
                },
                scrollSpeedController:
                    (int timeInMilliSecond, double overSize, double itemSize) {
                  if (timeInMilliSecond > 1500) {
                    scrollSpeedVariable = 20;
                  } else {
                    scrollSpeedVariable = 5;
                  }
                  return scrollSpeedVariable;
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 30.0, left: 30, right: 30),
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
                                      borderRadius: BorderRadius.circular(0)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    for (int i = 0; i < pdfPages.length; i++) {
                                      PdfPageModel temp = pdfPages[i];
                                      if (temp.pageSelected) {
                                        pdfPages[i] = PdfPageModel(
                                            pageIndex: temp.pageIndex,
                                            pageBytes: temp.pageBytes,
                                            pageErrorStatus:
                                                temp.pageErrorStatus,
                                            pageSelected: temp.pageSelected,
                                            pageRotationAngle:
                                                temp.pageRotationAngle - 90,
                                            pageHidden: temp.pageHidden);
                                      }
                                    }
                                  });
                                },
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
                                      borderRadius: BorderRadius.circular(0)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    for (int i = 0; i < pdfPages.length; i++) {
                                      PdfPageModel temp = pdfPages[i];
                                      if (temp.pageSelected) {
                                        pdfPages[i] = PdfPageModel(
                                            pageIndex: temp.pageIndex,
                                            pageBytes: temp.pageBytes,
                                            pageErrorStatus:
                                                temp.pageErrorStatus,
                                            pageSelected: temp.pageSelected,
                                            pageRotationAngle:
                                                temp.pageRotationAngle + 90,
                                            pageHidden: temp.pageHidden);
                                      }
                                    }
                                  });
                                },
                                child: const SizedBox.expand(
                                    child: Icon(Icons.rotate_right)),
                              ),
                            ),
                            const VerticalDivider(width: 1),
                            Expanded(
                              flex: 2,
                              child: Consumer(
                                builder: (BuildContext context, WidgetRef ref,
                                    Widget? child) {
                                  final ToolsActionsState
                                      watchToolsActionsStateProviderValue =
                                      ref.watch(toolsActionsStateProvider);

                                  List<PageRotationInfo> pagesRotationInfo =
                                      pdfPages
                                          .where((element) =>
                                              element.pageRotationAngle != 0)
                                          .map((e) => PageRotationInfo(
                                              pageNumber: e.pageIndex + 1,
                                              rotationAngle:
                                                  e.pageRotationAngle))
                                          .toList();
                                  List<int> pageNumbersForReorder;
                                  if (const ListEquality().equals(
                                      pdfPages
                                          .map((e) => e.pageIndex + 1)
                                          .toList(),
                                      widget.pdfPages
                                          .map((e) => e.pageIndex + 1)
                                          .toList())) {
                                    pageNumbersForReorder = [];
                                  } else {
                                    pageNumbersForReorder = pdfPages
                                        .map((e) => e.pageIndex + 1)
                                        .toList();
                                  }
                                  List<int> pageNumbersForDeleter = pdfPages
                                      .where((w) => w.pageSelected == false)
                                      .map((e) => e.pageIndex + 1)
                                      .toList();

                                  return FilledButton(
                                    style: FilledButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                    ),
                                    onPressed: pageNumbersForDeleter.length >=
                                            pdfPages.length
                                        ? null
                                        : () {
                                            watchToolsActionsStateProviderValue
                                                .modifySelectedFile(
                                              files: [widget.file],
                                              pagesRotationInfo:
                                                  pagesRotationInfo,
                                              pageNumbersForDeleter:
                                                  pageNumbersForDeleter,
                                              pageNumbersForReorder:
                                                  pageNumbersForReorder,
                                            );

                                            Navigator.pushNamed(
                                              context,
                                              route.resultPage,
                                            );
                                          },
                                    child: SizedBox.expand(
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
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
        ),
      ],
    );
  }
}

class GridElement extends StatelessWidget {
  const GridElement({Key? key, required this.child}) : super(key: key);

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

class GridElementPlaceholder extends StatelessWidget {
  const GridElementPlaceholder({Key? key, required this.index})
      : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      elevation: 0,
      // color: Theme.of(context).colorScheme.surfaceVariant,
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Text((index + 1).toString(),
              style: Theme.of(context).textTheme.headlineSmall)),
    );
  }
}

class PageImageView extends StatelessWidget {
  const PageImageView(
      {Key? key,
      required this.pageIndex,
      required this.pdfPage,
      this.onUpdatePdfPage})
      : super(key: key);

  final PdfPageModel pdfPage;

  final int pageIndex;

  final ValueChanged<PdfPageModel>? onUpdatePdfPage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.scale(
          scale: pdfPage.pageSelected ? 0.7 : 1,
          child: Stack(
            children: [
              RotationTransition(
                turns: AlwaysStoppedAnimation(pdfPage.pageRotationAngle / 360),
                child: Center(
                  child: Image.memory(
                    pdfPage.pageBytes!,
                    frameBuilder:
                        ((context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) {
                        return FittedBox(
                            child:
                                ImageChild(pageIndex: pageIndex, child: child));
                      } else {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: frame != null
                              ? FittedBox(
                                  child: ImageChild(
                                      pageIndex: pageIndex, child: child))
                              : const LoadingPageSmallBitmap(),
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
                          horizontal: 5.0, vertical: 2.0),
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
                  pageHidden: temp.pageHidden);
              onUpdatePdfPage?.call(temp);
            },
          ),
        ),
      ],
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(color: Colors.white, child: child),
      ],
    );
  }
}
