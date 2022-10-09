import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/pdf_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import 'package:files_tools/route/route.dart' as route;

class ModifyPDFToolsPage extends StatefulWidget {
  const ModifyPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  final ModifyPDFToolsPageArguments arguments;

  @override
  State<ModifyPDFToolsPage> createState() => _ModifyPDFToolsPageState();
}

class _ModifyPDFToolsPageState extends State<ModifyPDFToolsPage> {
  List<PdfPageModel> pdfPages = [];

  late Future<bool> initPdfPages;
  Future<bool> initPdfPagesState() async {
    Stopwatch stopwatch = Stopwatch()..start();
    pdfPages = await generatePdfPagesList(
        pdfUri: widget.arguments.file.fileUri, pdfPath: null);
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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Rotate, Delete & Reorder"),
          centerTitle: true,
        ),
        body: FutureBuilder<bool>(
          future: initPdfPages, // async work
          builder: (context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const ProcessingBody();
              default:
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return const ErrorBody();
                } else if (pdfPages.isEmpty) {
                  log(snapshot.error.toString());
                  return const ErrorBody();
                } else {
                  return ModifyPDFToolsBody(
                      actionType: widget.arguments.actionType,
                      file: widget.arguments.file,
                      pdfPages: pdfPages);
                }
            }
          },
        ),
      ),
    );
  }
}

class ModifyPDFToolsPageArguments {
  final ToolsActions actionType;
  final InputFileModel file;

  ModifyPDFToolsPageArguments({required this.actionType, required this.file});
}

class ModifyPDFToolsBody extends StatefulWidget {
  const ModifyPDFToolsBody(
      {Key? key,
      required this.actionType,
      required this.file,
      required this.pdfPages})
      : super(key: key);

  final ToolsActions actionType;
  final InputFileModel file;
  final List<PdfPageModel> pdfPages;

  @override
  State<ModifyPDFToolsBody> createState() => _ModifyPDFToolsBodyState();
}

class _ModifyPDFToolsBodyState extends State<ModifyPDFToolsBody> {
  bool isPageProcessing = false;

  late List<PdfPageModel> pdfPages = widget.pdfPages;

  void updatePdfPages({required int index}) async {
    if (pdfPages[index].pageBytes == null &&
        pdfPages[index].pageErrorStatus == false &&
        isPageProcessing == false) {
      isPageProcessing = true;
      PdfPageModel updatedPdfPage = await getUpdatedPdfPage(
        index: index,
        pdfUri: widget.file.fileUri,
        pdfPath: null,
        quality: 7,
      );
      setState(() {
        pdfPages[index] = updatedPdfPage;
        isPageProcessing = false;
      });
    }
  }

  double scrollSpeedVariable = 5;

  late List<int> removedPdfPagesIndexes = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ReorderableGridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 1,
            maxCrossAxisExtent: 150,
            mainAxisExtent: 150,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: pdfPages.length,
          placeholderBuilder: (int oldIndex, int newIndex, Widget widget) {
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
              return GridElement(key: Key('$index'), child: const PageError());
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
                  },
                ),
              );
            } else {
              return GridElement(
                  key: Key('$index'), child: const LoadingPage());
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
            padding: const EdgeInsets.only(bottom: 30.0, left: 30, right: 30),
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
                                  pagesToRemoveWithPageIndex
                                      .add(temp.pageIndex);
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

                            List<PageRotationInfo> pagesRotationInfo = pdfPages
                                .where(
                                    (element) => element.pageRotationAngle != 0)
                                .map((e) => PageRotationInfo(
                                    pageNumber: e.pageIndex + 1,
                                    rotationAngle: e.pageRotationAngle))
                                .toList();
                            List<int> pageNumbersForReorder;
                            if (const ListEquality().equals(
                                pdfPages.map((e) => e.pageIndex + 1).toList(),
                                widget.pdfPages
                                    .map((e) => e.pageIndex + 1)
                                    .toList())) {
                              pageNumbersForReorder = [];
                            } else {
                              pageNumbersForReorder =
                                  pdfPages.map((e) => e.pageIndex + 1).toList();
                            }
                            List<int> pageNumbersForDeleter =
                                removedPdfPagesIndexes
                                    .map((e) => e + 1)
                                    .toList();
                            return FilledButton(
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                              onPressed: pagesRotationInfo.isEmpty &&
                                      pageNumbersForReorder.isEmpty &&
                                      pageNumbersForDeleter.isEmpty
                                  ? null
                                  : () {
                                      watchToolsActionsStateProviderValue
                                          .modifySelectedFile(
                                        files: [widget.file],
                                        pagesRotationInfo: pagesRotationInfo,
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
              ),
            ),
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
                              : const LoadingPage(),
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

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircularProgressIndicator(),
      ],
    );
  }
}

class PageError extends StatelessWidget {
  const PageError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, color: Theme.of(context).colorScheme.error),
      ],
    );
  }
}

class ErrorBody extends StatelessWidget {
  const ErrorBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text(
            "Sorry, failed to process the pdf.",
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return TextButton(
                onPressed: () {
                  ref.read(toolsActionsStateProvider).cancelAction();
                  Navigator.pop(context);
                },
                child: const Text('Go back'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProcessingBody extends StatelessWidget {
  const ProcessingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 10),
          Text(
            'Getting pdf info please wait ...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class AboutActionCard extends StatelessWidget {
  const AboutActionCard(
      {Key? key, required this.aboutText, this.exampleText = ""})
      : super(key: key);

  final String aboutText;
  final String exampleText;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info),
            const Divider(),
            Text(
              aboutText,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (exampleText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Example:-",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          exampleText,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
