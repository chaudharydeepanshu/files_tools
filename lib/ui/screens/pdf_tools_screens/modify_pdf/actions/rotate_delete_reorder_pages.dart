import 'package:collection/collection.dart';
import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/levitating_options_bar.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/pdf_pages_gridview_components.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

/// Action screen for rotating, deleting, reordering PDF pages.
class RotateDeleteReorderPages extends StatefulWidget {
  /// Defining [RotateDeleteReorderPages] constructor.
  const RotateDeleteReorderPages({
    Key? key,
    required this.pdfPages,
    required this.file,
  }) : super(key: key);

  /// Takes list of model of PDF pages.
  final List<PdfPageModel> pdfPages;

  /// Takes input file.
  final InputFileModel file;

  @override
  State<RotateDeleteReorderPages> createState() =>
      _RotateDeleteReorderPagesState();
}

class _RotateDeleteReorderPagesState extends State<RotateDeleteReorderPages> {
  bool isPageProcessing = false;

  late List<PdfPageModel> pdfPages = List<PdfPageModel>.from(widget.pdfPages);

  void updatePdfPages({required int index}) async {
    if (pdfPages[index].pageBytes == null &&
        pdfPages[index].pageErrorStatus == false &&
        isPageProcessing == false) {
      isPageProcessing = true;
      PdfPageModel updatedPdfPage = await Utility.getUpdatedPdfPageModel(
        index: index,
        pdfPath: widget.file.fileUri,
        scale: 0.3,
        pdfPageModel: pdfPages[index],
      );
      if (mounted) {
        setState(() {
          pdfPages[index] = updatedPdfPage;
          isPageProcessing = false;
        });
      }
    }
  }

  double scrollSpeedVariable = 5;

  bool? isSelectAllEnabled = false;

  late List<int> removedPdfPagesIndexes = <int>[];

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String selectAllPages = appLocale.tool_Action_selectAllPages_ListTileTitle;
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
            title: Text(selectAllPages),
            value: isSelectAllEnabled,
            onChanged: (bool? value) {
              setState(() {
                isSelectAllEnabled = isSelectAllEnabled == null
                    ? true
                    : isSelectAllEnabled == true
                        ? isSelectAllEnabled == false
                        : true;
              });
              for (int i = 0; i < pdfPages.length; i++) {
                PdfPageModel temp = pdfPages[i];
                pdfPages[i] = PdfPageModel(
                  pageIndex: temp.pageIndex,
                  pageBytes: temp.pageBytes,
                  pageErrorStatus: temp.pageErrorStatus,
                  pageSelected: isSelectAllEnabled ?? temp.pageSelected,
                  pageRotationAngle: temp.pageRotationAngle,
                  pageHidden: temp.pageHidden,
                );
              }
            },
          ),
        ),
        const Divider(indent: 16.0, endIndent: 16.0, height: 0),
        Expanded(
          child: Stack(
            children: <Widget>[
              ReorderableGridView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisExtent: 150,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: pdfPages.length,
                placeholderBuilder:
                    (int oldIndex, int newIndex, Widget widget) {
                  return GridImagePlaceholderWidget(index: newIndex);
                },
                dragWidgetBuilder: (int index, Widget widget) {
                  return Transform.scale(
                    scale: 1.1,
                    child: GridImageWidget(
                      child: PageImageView(
                        pdfPage: pdfPages[index],
                        pageIndex: index,
                      ),
                    ),
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  updatePdfPages(index: index);
                  if (pdfPages[index].pageErrorStatus) {
                    return GridImageWidget(
                      key: Key('$index'),
                      child: const ErrorIndicator(),
                    );
                  } else if (pdfPages[index].pageBytes != null) {
                    return GridImageWidget(
                      key: Key('$index'),
                      child: PageImageView(
                        pdfPage: pdfPages[index],
                        pageIndex: index,
                        onUpdatePdfPage: (PdfPageModel value) {
                          setState(() {
                            pdfPages[index] = value;
                          });

                          if (pdfPages.every(
                            (PdfPageModel w) => w.pageSelected == true,
                          )) {
                            setState(() {
                              isSelectAllEnabled = true;
                            });
                          } else if (pdfPages.every(
                            (PdfPageModel w) => w.pageSelected == false,
                          )) {
                            setState(() {
                              isSelectAllEnabled = false;
                            });
                          } else {
                            setState(() {
                              isSelectAllEnabled = null;
                            });
                          }
                        },
                      ),
                    );
                  } else {
                    return GridImageWidget(
                      key: Key('$index'),
                      child: const LoadingIndicator(),
                    );
                  }
                },
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    final PdfPageModel element = pdfPages.removeAt(oldIndex);
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
                child: LevitatingOptionsBar(
                  optionsList: <Widget>[
                    Expanded(
                      child: FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onPressed: pdfPages
                                .where(
                                  (PdfPageModel w) => w.pageSelected == true,
                                )
                                .isEmpty
                            ? null
                            : () {
                                setState(() {
                                  for (int i = 0; i < pdfPages.length; i++) {
                                    PdfPageModel temp = pdfPages[i];
                                    if (temp.pageSelected) {
                                      pdfPages[i] = PdfPageModel(
                                        pageIndex: temp.pageIndex,
                                        pageBytes: temp.pageBytes,
                                        pageErrorStatus: temp.pageErrorStatus,
                                        pageSelected: temp.pageSelected,
                                        pageRotationAngle:
                                            temp.pageRotationAngle - 90,
                                        pageHidden: temp.pageHidden,
                                      );
                                    }
                                  }
                                });
                              },
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
                        onPressed: pdfPages
                                .where(
                                  (PdfPageModel w) => w.pageSelected == true,
                                )
                                .isEmpty
                            ? null
                            : () {
                                setState(() {
                                  for (int i = 0; i < pdfPages.length; i++) {
                                    PdfPageModel temp = pdfPages[i];
                                    if (temp.pageSelected) {
                                      pdfPages[i] = PdfPageModel(
                                        pageIndex: temp.pageIndex,
                                        pageBytes: temp.pageBytes,
                                        pageErrorStatus: temp.pageErrorStatus,
                                        pageSelected: temp.pageSelected,
                                        pageRotationAngle:
                                            temp.pageRotationAngle + 90,
                                        pageHidden: temp.pageHidden,
                                      );
                                    }
                                  }
                                });
                              },
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
                        onPressed: pdfPages.every(
                                  (PdfPageModel w) => w.pageSelected == true,
                                ) ||
                                pdfPages.every(
                                  (PdfPageModel w) => w.pageSelected == false,
                                )
                            ? null
                            : () {
                                setState(() {
                                  List<int> pagesToRemoveWithPageIndex =
                                      <int>[];
                                  for (int i = 0; i < pdfPages.length; i++) {
                                    PdfPageModel temp = pdfPages[i];
                                    if (temp.pageSelected) {
                                      pagesToRemoveWithPageIndex
                                          .add(temp.pageIndex);
                                    }
                                  }
                                  pdfPages.removeWhere(
                                    (PdfPageModel element) =>
                                        pagesToRemoveWithPageIndex
                                            .contains(element.pageIndex),
                                  );
                                  removedPdfPagesIndexes
                                      .addAll(pagesToRemoveWithPageIndex);
                                });
                              },
                        child: SizedBox.expand(
                          child: Icon(
                            Icons.delete,
                            color: pdfPages.every(
                                      (PdfPageModel w) =>
                                          w.pageSelected == true,
                                    ) ||
                                    pdfPages.every(
                                      (PdfPageModel w) =>
                                          w.pageSelected == false,
                                    )
                                ? null
                                : Theme.of(context).colorScheme.error,
                          ),
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

                          List<PageRotationInfo> pagesRotationInfo = pdfPages
                              .where(
                                (PdfPageModel element) =>
                                    element.pageRotationAngle != 0,
                              )
                              .map(
                                (PdfPageModel e) => PageRotationInfo(
                                  pageNumber: e.pageIndex + 1,
                                  rotationAngle: e.pageRotationAngle,
                                ),
                              )
                              .toList();
                          List<int> pageNumbersForReorder;
                          if (const ListEquality<int>().equals(
                            pdfPages
                                .map((PdfPageModel e) => e.pageIndex + 1)
                                .toList(),
                            widget.pdfPages
                                .map((PdfPageModel e) => e.pageIndex + 1)
                                .toList(),
                          )) {
                            pageNumbersForReorder = <int>[];
                          } else {
                            pageNumbersForReorder = pdfPages
                                .map((PdfPageModel e) => e.pageIndex + 1)
                                .toList();
                          }
                          List<int> pageNumbersForDeleter =
                              removedPdfPagesIndexes
                                  .map((int e) => e + 1)
                                  .toList();
                          return FilledButton(
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            onPressed: pagesRotationInfo.isEmpty &&
                                    pageNumbersForReorder.isEmpty &&
                                    pageNumbersForDeleter.isEmpty
                                ? null
                                : () {
                                    watchToolsActionsStateProviderValue
                                        .mangeModifyPdfFileAction(
                                      toolAction: ToolAction.modifyPdf,
                                      sourceFile: widget.file,
                                      pagesRotationInfo: pagesRotationInfo,
                                      pageNumbersForDeleter:
                                          pageNumbersForDeleter,
                                      pageNumbersForReorder:
                                          pageNumbersForReorder,
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
        ),
      ],
    );
  }
}
