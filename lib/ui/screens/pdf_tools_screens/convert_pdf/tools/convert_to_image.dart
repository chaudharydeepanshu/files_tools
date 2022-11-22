import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/levitating_options_bar.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/utils/decimal_text_input_formatter.dart';
import 'package:files_tools/utils/get_pdf_bitmaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:files_tools/route/route.dart' as route;

class ConvertToImage extends StatefulWidget {
  const ConvertToImage({Key? key, required this.pdfPages, required this.file})
      : super(key: key);

  final List<PdfPageModel> pdfPages;
  final InputFileModel file;

  @override
  State<ConvertToImage> createState() => _ConvertToImageState();
}

class _ConvertToImageState extends State<ConvertToImage> {
  bool isPageProcessing = false;

  late List<PdfPageModel> pdfPages;

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

  late List<int> removedPdfPagesIndexes = [];

  bool? isSelectAllEnabled = true;

  TextEditingController pdfPagesQualityController =
      TextEditingController(text: '2');

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    pdfPages = widget.pdfPages;

    for (int i = 0; i < pdfPages.length; i++) {
      PdfPageModel temp = pdfPages[i];
      pdfPages[i] = PdfPageModel(
          pageIndex: temp.pageIndex,
          pageBytes: temp.pageBytes,
          pageErrorStatus: temp.pageErrorStatus,
          pageSelected: isSelectAllEnabled ?? temp.pageSelected,
          pageRotationAngle: temp.pageRotationAngle,
          pageHidden: temp.pageHidden);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
          child: CheckboxListTile(
              tristate: true,
              tileColor: Theme.of(context).colorScheme.surfaceVariant,
              // contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              title: Text("Select All Pages",
                  style: Theme.of(context).textTheme.bodyMedium),
              value: isSelectAllEnabled,
              onChanged: (bool? value) {
                setState(() {
                  isSelectAllEnabled =
                      isSelectAllEnabled == null ? true : !isSelectAllEnabled!;
                });
                for (int i = 0; i < pdfPages.length; i++) {
                  PdfPageModel temp = pdfPages[i];
                  pdfPages[i] = PdfPageModel(
                      pageIndex: temp.pageIndex,
                      pageBytes: temp.pageBytes,
                      pageErrorStatus: temp.pageErrorStatus,
                      pageSelected: isSelectAllEnabled ?? temp.pageSelected,
                      pageRotationAngle: temp.pageRotationAngle,
                      pageHidden: temp.pageHidden);
                }
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: pdfPagesQualityController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Enter Image Scaling',
                // isDense: true,
                helperText: 'Higher scaling = Higher quality + More time',
                // enabledBorder: const UnderlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter number from 0 to 5';
                } else if (double.parse(value) <= 0 ||
                    double.parse(value) > 5) {
                  return 'Please enter number from 0 to 5';
                }
                return null;
              },
            ),
          ),
        ),
        const Divider(indent: 16.0, endIndent: 16.0),
        Expanded(
          child: Stack(
            children: [
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 1,
                  maxCrossAxisExtent: 150,
                  mainAxisExtent: 150,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: pdfPages.length,
                itemBuilder: (BuildContext context, int index) {
                  updatePdfPages(index: index);
                  if (pdfPages[index].pageErrorStatus) {
                    return GridElement(
                        key: Key('$index'), child: const ErrorIndicator());
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
                        key: Key('$index'), child: const LoadingIndicator());
                  }
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: LevitatingOptionsBar(
                  optionsList: [
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
                                    pageErrorStatus: temp.pageErrorStatus,
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
                                    pageErrorStatus: temp.pageErrorStatus,
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
                      flex: 1,
                      child: FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                        ),
                        onPressed: () {
                          setState(() {
                            List<int> pagesToRemoveWithPageIndex = [];
                            for (int i = 0; i < pdfPages.length; i++) {
                              PdfPageModel temp = pdfPages[i];
                              if (temp.pageSelected) {
                                pagesToRemoveWithPageIndex.add(temp.pageIndex);
                              }
                            }
                            pdfPages.removeWhere((element) =>
                                pagesToRemoveWithPageIndex
                                    .contains(element.pageIndex));
                            removedPdfPagesIndexes
                                .addAll(pagesToRemoveWithPageIndex);
                          });
                        },
                        child: SizedBox.expand(
                            child: Icon(Icons.delete,
                                color: Theme.of(context).colorScheme.error)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Consumer(
                        builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          final ToolsActionsState
                              watchToolsActionsStateProviderValue =
                              ref.watch(toolsActionsStateProvider);
                          List<PdfPageModel> selectedPages = pdfPages
                              .where((element) =>
                                  element.pageSelected == true &&
                                  !removedPdfPagesIndexes
                                      .contains(element.pageIndex))
                              .toList();
                          return FilledButton(
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                            ),
                            onPressed: pdfPages.every(
                                    (PdfPageModel w) => w.pageSelected == false)
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      watchToolsActionsStateProviderValue
                                          .convertSelectedFile(
                                              files: [widget.file],
                                              selectedPages: selectedPages,
                                              imageScaling: double.parse(
                                                  pdfPagesQualityController
                                                      .value.text));

                                      Navigator.pushNamed(
                                        context,
                                        route.resultPage,
                                      );
                                    }
                                  },
                            child: SizedBox.expand(
                              child: Center(
                                child: Row(
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
