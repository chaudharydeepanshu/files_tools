import 'dart:ui';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/split_pdf_tools_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplitByPageRanges extends StatelessWidget {
  const SplitByPageRanges(
      {Key? key, required this.pdfPageCount, required this.file})
      : super(key: key);

  final int pdfPageCount;
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SplitByPageRangesActionCard(pdfPageCount: pdfPageCount, file: file),
        const SizedBox(height: 16),
        const AboutActionCard(
          aboutText:
              'This method extracts pages into a single pdf from the provided pdf by providing page range.',
          exampleText: "",
        ),
      ],
    );
  }
}

class SplitByPageRangesActionCard extends StatelessWidget {
  const SplitByPageRangesActionCard(
      {Key? key, required this.pdfPageCount, required this.file})
      : super(key: key);

  final int pdfPageCount;
  final InputFileModel file;

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
            const Icon(Icons.looks_one),
            const Divider(),
            Flexible(
              child: PageRangesActionBody(
                pdfPageCount: pdfPageCount,
                file: file,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageRangesActionBody extends StatefulWidget {
  const PageRangesActionBody({
    Key? key,
    required this.pdfPageCount,
    required this.file,
  }) : super(key: key);

  final int pdfPageCount;
  final InputFileModel file;

  @override
  State<PageRangesActionBody> createState() => _PageRangesActionBodyState();
}

class _PageRangesActionBodyState extends State<PageRangesActionBody> {
  List<TextEditingController> pageRangesControllers = [TextEditingController()];

  List<String> pageRangeStringList = [];

  List<String> sanitizedData = [];

  bool isRemoveDuplicates = false;
  bool isForceAscending = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: pageRangesControllers.length > 1
                ? ReorderablePageRangesListView(
                    pageRangesControllers: pageRangesControllers,
                    pdfPageCount: widget.pdfPageCount,
                    isRemoveDuplicates: isRemoveDuplicates,
                    isForceAscending: isForceAscending,
                    onUpdatePageRangeControllers:
                        (List<TextEditingController> value) {
                      setState(() {
                        pageRangesControllers = value;
                      });
                    },
                  )
                : PageRangeTile(
                    pageRangeController: pageRangesControllers[0],
                    pdfPageCount: widget.pdfPageCount,
                    isRemoveDuplicates: isRemoveDuplicates,
                    isForceAscending: isForceAscending,
                    onRemovePageRangeController: (TextEditingController value) {
                      setState(() {
                        pageRangesControllers.remove(value);
                      });
                    },
                  )),
        Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    pageRangesControllers.add(TextEditingController());
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text("Add more")),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    // minimumSize: Size(0, 0),
                  ),
                  onPressed: () {
                    // pageNumbersController.text =
                    //     pageRangeStringList.join(",");
                    // pageNumbersController.selection =
                    //     TextSelection.collapsed(
                    //         offset:
                    //             pageNumbersController.text.length);
                  },
                  child: const Text("Sanitize Inputs"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                CheckboxListTile(
                    tileColor: Theme.of(context).colorScheme.surfaceVariant,
                    // contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    title: Text("Remove repeats in range",
                        style: Theme.of(context).textTheme.bodyMedium),
                    value: isRemoveDuplicates,
                    onChanged: (bool? value) {
                      // isRemoveDuplicates =
                      //     value ?? !isRemoveDuplicates;
                      // pageRangeStringList = getPageRangeStringList(
                      //     value: pageNumbersController.value.text,
                      //     pdfPageCount: widget.pdfPageCount,
                      //     isRemoveDuplicates: isRemoveDuplicates,
                      //     isForceAscending: isForceAscending);
                      // setState(() {
                      //   sanitizedData = pageRangeStringList;
                      // });
                    }),
                const SizedBox(height: 10),
                CheckboxListTile(
                    tileColor: Theme.of(context).colorScheme.surfaceVariant,
                    // contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    title: Text("Force Ascending",
                        style: Theme.of(context).textTheme.bodyMedium),
                    value: isForceAscending,
                    onChanged: (bool? value) {
                      // isForceAscending = value ?? !isForceAscending;
                      // pageRangeStringList = getPageRangeStringList(
                      //     value: pageNumbersController.value.text,
                      //     pdfPageCount: widget.pdfPageCount,
                      //     isRemoveDuplicates: isRemoveDuplicates,
                      //     isForceAscending: isForceAscending);
                      // setState(() {
                      //   sanitizedData = pageRangeStringList;
                      // });
                    }),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Result PDF will Pages in order:-',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        sanitizedData.join(", "),
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Consumer(
            //   builder: (BuildContext context, WidgetRef ref, Widget? child) {
            //     final ToolScreenState readToolScreenStateProviderValue =
            //         ref.watch(toolScreenStateProvider);
            //     final bool isPickingFile =
            //         ref.watch(toolScreenStateProvider).isPickingFile;
            //     return Wrap(
            //       spacing: 10,
            //       children: [
            //         if (widget.selectFileType == SelectFileType.multiple)
            //           ElevatedButton.icon(
            //             style: ElevatedButton.styleFrom(
            //               foregroundColor: Theme.of(context).colorScheme.onPrimary,
            //               backgroundColor: Theme.of(context).colorScheme.primary,
            //             ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
            //             onPressed: !isPickingFile
            //                 ? () {
            //                     readToolScreenStateProviderValue.selectFiles(
            //                       params: widget.filePickerParams,
            //                     );
            //                   }
            //                 : null,
            //             label: const Text('Select More'),
            //             icon: const Icon(Icons.upload_file),
            //           ),
            //         ElevatedButton.icon(
            //           style: ElevatedButton.styleFrom(
            //             foregroundColor: Theme.of(context).colorScheme.onPrimary,
            //             backgroundColor: Theme.of(context).colorScheme.primary,
            //           ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
            //           onPressed: !isPickingFile
            //               ? () {
            //                   readToolScreenStateProviderValue.updateSelectedFiles(
            //                     files: [],
            //                   );
            //                 }
            //               : null,
            //           label: const Text('Clear Selection'),
            //           icon: const Icon(Icons.clear),
            //         ),
            //       ],
            //     );
            //   },
            // ),
          ],
        ),
      ],
    );
  }
}

// class SplitByPageRangesActionCard extends StatefulWidget {
//   const SplitByPageRangesActionCard(
//       {Key? key, required this.pdfPageCount, required this.file})
//       : super(key: key);
//
//   final int pdfPageCount;
//   final InputFileModel file;
//
//   @override
//   State<SplitByPageRangesActionCard> createState() =>
//       _SplitByPageRangesActionCardState();
// }
//
// class _SplitByPageRangesActionCardState
//     extends State<SplitByPageRangesActionCard> {
//   final _formKey = GlobalKey<FormState>();
//
//   List<TextEditingController> pageRangesControllers = [TextEditingController()];
//
//   List<String> pageRangeStringList = [];
//
//   List<String> sanitizedData = [];
//
//   bool isRemoveDuplicates = false;
//   bool isForceAscending = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       clipBehavior: Clip.antiAlias,
//       margin: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.looks_3),
//             const Divider(),
//             Text(
//               'Pages in selected pdf = ${widget.pdfPageCount}',
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             const SizedBox(height: 10),
//             widget.pdfPageCount > 1
//                 ? Column(
//                     // mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ReorderablePageRangesListView(
//                         pageRangesControllers: pageRangesControllers,
//                         // pdfPageCount: widget.pdfPageCount,
//                         // isRemoveDuplicates: isRemoveDuplicates,
//                         // isForceAscending: isForceAscending
//                       ),
//                       OutlinedButton.icon(
//                           onPressed: () {
//                             setState(() {
//                               pageRangesControllers
//                                   .add(TextEditingController());
//                             });
//                           },
//                           icon: Icon(Icons.add),
//                           label: Text("Add more")),
//                       // Form(
//                       //   key: _formKey,
//                       //   child: TextFormField(
//                       //     controller: pageNumbersController,
//                       //     decoration: const InputDecoration(
//                       //       filled: true,
//                       //       labelText: 'Enter Page Range',
//                       //       // isDense: true,
//                       //       helperText: 'Example- 3,5-7',
//                       //       // enabledBorder: const UnderlineInputBorder(),
//                       //     ),
//                       //     keyboardType: TextInputType.number,
//                       //     inputFormatters: [
//                       //       FilteringTextInputFormatter(RegExp("[0-9,-]"),
//                       //           allow: true),
//                       //     ],
//                       //     onChanged: (String value) {
//                       //       pageRangeStringList = getPageRangeStringList(
//                       //           value: value,
//                       //           pdfPageCount: widget.pdfPageCount,
//                       //           isRemoveDuplicates: isRemoveDuplicates,
//                       //           isForceAscending: isForceAscending);
//                       //       setState(() {
//                       //         sanitizedData = pageRangeStringList;
//                       //       });
//                       //     },
//                       //     autovalidateMode: AutovalidateMode.onUserInteraction,
//                       //     // The validator receives the text that the user has entered.
//                       //     validator: (value) {
//                       //       return pageRangeGeneralValidator(
//                       //           pageRangeStringList: pageRangeStringList,
//                       //           pdfPageCount: widget.pdfPageCount);
//                       //     },
//                       //   ),
//                       // ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           TextButton(
//                             style: TextButton.styleFrom(
//                               padding: EdgeInsets.zero,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(0),
//                               ),
//                               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                               visualDensity: VisualDensity.compact,
//                               // minimumSize: Size(0, 0),
//                             ),
//                             onPressed: () {
//                               // pageNumbersController.text =
//                               //     pageRangeStringList.join(",");
//                               // pageNumbersController.selection =
//                               //     TextSelection.collapsed(
//                               //         offset:
//                               //             pageNumbersController.text.length);
//                             },
//                             child: const Text("Sanitize Inputs"),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Column(
//                         children: [
//                           CheckboxListTile(
//                               tileColor:
//                                   Theme.of(context).colorScheme.surfaceVariant,
//                               // contentPadding: EdgeInsets.zero,
//                               visualDensity: VisualDensity.compact,
//                               title: Text("Remove repeats in range",
//                                   style:
//                                       Theme.of(context).textTheme.bodyMedium),
//                               value: isRemoveDuplicates,
//                               onChanged: (bool? value) {
//                                 // isRemoveDuplicates =
//                                 //     value ?? !isRemoveDuplicates;
//                                 // pageRangeStringList = getPageRangeStringList(
//                                 //     value: pageNumbersController.value.text,
//                                 //     pdfPageCount: widget.pdfPageCount,
//                                 //     isRemoveDuplicates: isRemoveDuplicates,
//                                 //     isForceAscending: isForceAscending);
//                                 // setState(() {
//                                 //   sanitizedData = pageRangeStringList;
//                                 // });
//                               }),
//                           const SizedBox(height: 10),
//                           CheckboxListTile(
//                               tileColor:
//                                   Theme.of(context).colorScheme.surfaceVariant,
//                               // contentPadding: EdgeInsets.zero,
//                               visualDensity: VisualDensity.compact,
//                               title: Text("Force Ascending",
//                                   style:
//                                       Theme.of(context).textTheme.bodyMedium),
//                               value: isForceAscending,
//                               onChanged: (bool? value) {
//                                 // isForceAscending = value ?? !isForceAscending;
//                                 // pageRangeStringList = getPageRangeStringList(
//                                 //     value: pageNumbersController.value.text,
//                                 //     pdfPageCount: widget.pdfPageCount,
//                                 //     isRemoveDuplicates: isRemoveDuplicates,
//                                 //     isForceAscending: isForceAscending);
//                                 // setState(() {
//                                 //   sanitizedData = pageRangeStringList;
//                                 // });
//                               }),
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Result PDF will Pages in order:-',
//                                 style: Theme.of(context).textTheme.bodyMedium,
//                                 textAlign: TextAlign.start,
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Flexible(
//                                 child: Text(
//                                   sanitizedData.join(", "),
//                                   style: Theme.of(context).textTheme.bodySmall,
//                                   textAlign: TextAlign.start,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const Divider(),
//                       Consumer(
//                         builder: (BuildContext context, WidgetRef ref,
//                             Widget? child) {
//                           final ToolsActionsState
//                               watchToolsActionsStateProviderValue =
//                               ref.watch(toolsActionsStateProvider);
//                           return ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               foregroundColor:
//                                   Theme.of(context).colorScheme.onPrimary,
//                               backgroundColor:
//                                   Theme.of(context).colorScheme.primary,
//                             ).copyWith(
//                                 elevation: ButtonStyleButton.allOrNull(0.0)),
//                             onPressed: () async {
//                               if (_formKey.currentState!.validate()) {
//                                 pageRangeStringList =
//                                     enableReverseRangeForSanitizedRange(
//                                         sanitizedPageRange:
//                                             pageRangeStringList);
//                                 watchToolsActionsStateProviderValue
//                                     .splitSelectedFile(files: [
//                                   widget.file
//                                 ], pageRange: pageRangeStringList.join(","));
//                                 Navigator.pushNamed(
//                                   context,
//                                   route.resultPage,
//                                 );
//                               }
//                             },
//                             child: const Text("Split PDF"),
//                           );
//                         },
//                       ),
//                     ],
//                   )
//                 : Text(
//                     'Sorry, can\'t split a pdf with less than 2 pages.',
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodySmall
//                         ?.copyWith(color: Theme.of(context).colorScheme.error),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class PageRangeTile extends StatefulWidget {
  const PageRangeTile(
      {Key? key,
      required this.pageRangeController,
      required this.pdfPageCount,
      required this.isRemoveDuplicates,
      required this.isForceAscending,
      required this.onRemovePageRangeController})
      : super(key: key);

  final TextEditingController pageRangeController;
  final int pdfPageCount;
  final bool isRemoveDuplicates;
  final bool isForceAscending;
  final ValueChanged<TextEditingController> onRemovePageRangeController;

  @override
  State<PageRangeTile> createState() => _PageRangeTileState();
}

class _PageRangeTileState extends State<PageRangeTile> {
  List<String> sanitizedData = [];
  List<String> pageRangeStringList = [];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.list,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      minLeadingWidth: 0,
      // minVerticalPadding: 0,
      visualDensity: VisualDensity.comfortable,
      dense: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      tileColor: Theme.of(context).colorScheme.secondaryContainer,
      leading: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          height: double.infinity,
          child: Icon(Icons.drag_handle),
        ),
      ),
      title: TextFormField(
        controller: widget.pageRangeController,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Enter Page Range',
          isDense: true,
          contentPadding: EdgeInsets.zero,
          helperText: 'Example- 3,5-7',
          // enabledBorder: const UnderlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp("[0-9,-]"), allow: true),
        ],
        onChanged: (String value) {
          pageRangeStringList = getPageRangeStringList(
              value: value,
              pdfPageCount: widget.pdfPageCount,
              isRemoveDuplicates: widget.isRemoveDuplicates,
              isForceAscending: widget.isForceAscending);
          setState(() {
            sanitizedData = pageRangeStringList;
          });
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // The validator receives the text that the user has entered.
        validator: (value) {
          return null;

          // return pageRangeGeneralValidator(
          //     pageRangeStringList: pageRangeStringList,
          //     pdfPageCount: widget.pdfPageCount);
        },
      ),
      trailing: IconButton(
        style: IconButton.styleFrom(
            // minimumSize: Size.zero,
            // padding: EdgeInsets.zero,
            // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
        onPressed: () {
          widget.onRemovePageRangeController.call(widget.pageRangeController);
        },
        icon: const SizedBox(
          height: double.infinity,
          child: Icon(
            Icons.clear,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class ReorderablePageRangesListView extends StatefulWidget {
  const ReorderablePageRangesListView(
      {super.key,
      required this.pageRangesControllers,
      required this.pdfPageCount,
      required this.isRemoveDuplicates,
      required this.isForceAscending,
      required this.onUpdatePageRangeControllers});

  final List<TextEditingController> pageRangesControllers;
  final int pdfPageCount;
  final bool isRemoveDuplicates;
  final bool isForceAscending;
  final ValueChanged<List<TextEditingController>> onUpdatePageRangeControllers;

  @override
  State<ReorderablePageRangesListView> createState() =>
      _ReorderablePageRangesListViewState();
}

class _ReorderablePageRangesListViewState
    extends State<ReorderablePageRangesListView> {
  late List<TextEditingController> _pageRangesControllers =
      widget.pageRangesControllers;

  @override
  void didUpdateWidget(covariant ReorderablePageRangesListView oldWidget) {
    if (widget.pageRangesControllers != oldWidget.pageRangesControllers) {
      setState(() {
        _pageRangesControllers = widget.pageRangesControllers;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(0, 6, animValue)!;
          return Material(
            elevation: 0,
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    elevation: elevation,
                    shadowColor: colorScheme.shadow,
                  ),
                ),
                child!,
              ],
            ),
          );
        },
        child: child,
      );
    }

    return ReorderableListView(
      shrinkWrap: _pageRangesControllers.length < 10,
      proxyDecorator: proxyDecorator,
      children: <Widget>[
        for (int index = 0; index < _pageRangesControllers.length; index += 1)
          Column(
            key: Key('$index'),
            children: [
              Material(
                color: Colors.transparent,
                child: PageRangeTile(
                  pageRangeController: _pageRangesControllers[index],
                  pdfPageCount: widget.pdfPageCount,
                  isRemoveDuplicates: widget.isRemoveDuplicates,
                  isForceAscending: widget.isForceAscending,
                  onRemovePageRangeController: (TextEditingController value) {
                    setState(() {
                      _pageRangesControllers.remove(value);
                      widget.onUpdatePageRangeControllers
                          .call(_pageRangesControllers);
                    });
                  },
                ),
              ),
              index != _pageRangesControllers.length - 1
                  ? const SizedBox(height: 10)
                  : const SizedBox(),
            ],
          ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final TextEditingController item =
              _pageRangesControllers.removeAt(oldIndex);
          _pageRangesControllers.insert(newIndex, item);
        });
      },
    );
  }
}

List<String> getPageRangeStringList(
    {required String? value,
    required int pdfPageCount,
    required bool isRemoveDuplicates,
    required bool isForceAscending}) {
  List<String> pageRangeStringList = [];
  pageRangeStringList =
      pageRangeSanitized(value: value, pdfPageCount: pdfPageCount);
  if (isForceAscending && isRemoveDuplicates) {
    pageRangeStringList =
        pageRangeGeneralSanitized(sanitizedPageRange: pageRangeStringList);
    pageRangeStringList =
        pageRangeDuplicatesSanitized(sanitizedPageRange: pageRangeStringList);
    pageRangeStringList =
        pageRangeAscendingSanitized(sanitizedPageRange: pageRangeStringList);
  } else if (isRemoveDuplicates) {
    pageRangeStringList =
        pageRangeGeneralSanitized(sanitizedPageRange: pageRangeStringList);
    pageRangeStringList =
        pageRangeDuplicatesSanitized(sanitizedPageRange: pageRangeStringList);
  } else if (isForceAscending) {
    pageRangeStringList =
        pageRangeGeneralSanitized(sanitizedPageRange: pageRangeStringList);
    pageRangeStringList =
        pageRangeAscendingSanitized(sanitizedPageRange: pageRangeStringList);
  } else {
    pageRangeStringList =
        pageRangeGeneralSanitized(sanitizedPageRange: pageRangeStringList);
  }
  return pageRangeStringList;
}

String strip(String str, String charactersToRemove) {
  String escapedChars = RegExp.escape(charactersToRemove);
  RegExp regex = RegExp(r"^[" + escapedChars + r"]+|[" + escapedChars + r']+$');
  String newStr = str.replaceAll(regex, '').trim();
  return newStr;
}

List<String> enableReverseRangeForSanitizedRange(
    {required List<String> sanitizedPageRange}) {
  List<String> tempPageRangeStringList = [];
  for (int i = 0; i < sanitizedPageRange.length; i++) {
    String pageRangeString = sanitizedPageRange[i];
    if (pageRangeString.contains("-")) {
      List<String> tempSplit = pageRangeString.split("-");
      int rangeStart = int.parse(tempSplit.first);
      int rangeEnd = int.parse(tempSplit.last);
      if (rangeStart > rangeEnd) {
        for (int i = rangeStart; i >= rangeEnd; i--) {
          tempPageRangeStringList.add(i.toString());
        }
      } else {
        tempPageRangeStringList.add(pageRangeString);
      }
    } else {
      tempPageRangeStringList.add(pageRangeString);
    }
  }

  return tempPageRangeStringList;
}

List<String> pageRangeSanitized(
    {required String? value, required int pdfPageCount}) {
  List<String> pageRangeStringList = [];
  if (value != null) {
    String newStrippedValue = strip(value, r"-,");
    pageRangeStringList = newStrippedValue
        .split(",")
        .map((e) => e.trim())
        .map((e) => strip(e, r"-").replaceAll(RegExp(r'^0+(?=.)'), ''))
        .toList();
    pageRangeStringList.removeWhere((element) => element.isEmpty);
    List<String> tempPageRangeStringList = [];
    for (int i = 0; i < pageRangeStringList.length; i++) {
      String pageRangeString = pageRangeStringList[i];
      if (pageRangeString.contains("-")) {
        List<String> tempSplit = pageRangeString
            .split("-")
            .map((e) => e.replaceAll("^0+", ""))
            .toList();
        String rangeStart = tempSplit.first.replaceAll(RegExp(r'^0+(?=.)'), '');
        String rangeEnd = tempSplit.last.replaceAll(RegExp(r'^0+(?=.)'), '');
        if (rangeStart.length > pdfPageCount.toString().length ||
            int.parse(rangeStart) > pdfPageCount) {
        } else if (rangeEnd == rangeStart) {
          tempPageRangeStringList.add(rangeStart);
        } else {
          if (rangeEnd.length > pdfPageCount.toString().length ||
              int.parse(rangeEnd) > pdfPageCount) {
            tempPageRangeStringList.add("$rangeStart-$pdfPageCount");
          } else {
            tempPageRangeStringList.add("$rangeStart-$rangeEnd");
          }
        }
      } else {
        if (pageRangeString.length > pdfPageCount.toString().length ||
            int.parse(pageRangeString) > pdfPageCount) {
        } else if (pageRangeString == "0") {
        } else {
          tempPageRangeStringList.add(pageRangeString);
        }
      }
    }
    pageRangeStringList = List.from(tempPageRangeStringList);
  }

  return pageRangeStringList;
}

String? pageRangeGeneralValidator(
    {required List<String> pageRangeStringList, required int pdfPageCount}) {
  if (pageRangeStringList.isEmpty) {
    return 'Enter valid number & range from 1 to $pdfPageCount';
  }
  return null;
}

List<String> pageRangeGeneralSanitized(
    {required List<String> sanitizedPageRange}) {
  List<String> tempPageRangeStringList = [];
  for (int i = 0; i < sanitizedPageRange.length; i++) {
    String pageRangeString = sanitizedPageRange[i];
    if (pageRangeString.contains("-")) {
      List<String> tempSplit = pageRangeString.split("-");
      int rangeStart = int.parse(tempSplit.first);
      int rangeEnd = int.parse(tempSplit.last);
      if (rangeStart > rangeEnd) {
        for (int i = rangeStart; i >= rangeEnd; i--) {
          tempPageRangeStringList.add(i.toString());
        }
      } else if (rangeEnd > rangeStart) {
        for (int i = rangeStart; i <= rangeEnd; i++) {
          tempPageRangeStringList.add(i.toString());
        }
      }
    } else {
      tempPageRangeStringList.add(pageRangeString);
    }
  }

  tempPageRangeStringList = tempPageRangeStringList.toList();

  List<int> numList = tempPageRangeStringList.map((e) => int.parse(e)).toList();

  tempPageRangeStringList = createListOfRangesFromNumbers(numList: numList);

  return tempPageRangeStringList;
}

List<String> pageRangeDuplicatesSanitized(
    {required List<String> sanitizedPageRange}) {
  List<String> tempPageRangeStringList = [];
  for (int i = 0; i < sanitizedPageRange.length; i++) {
    String pageRangeString = sanitizedPageRange[i];
    if (pageRangeString.contains("-")) {
      List<String> tempSplit = pageRangeString.split("-");
      int rangeStart = int.parse(tempSplit.first);
      int rangeEnd = int.parse(tempSplit.last);
      if (rangeStart > rangeEnd) {
        for (int i = rangeStart; i >= rangeEnd; i--) {
          tempPageRangeStringList.add(i.toString());
        }
      } else if (rangeEnd > rangeStart) {
        for (int i = rangeStart; i <= rangeEnd; i++) {
          tempPageRangeStringList.add(i.toString());
        }
      }
    } else {
      tempPageRangeStringList.add(pageRangeString);
    }
  }

  tempPageRangeStringList = tempPageRangeStringList.toSet().toList();

  List<int> numList = tempPageRangeStringList.map((e) => int.parse(e)).toList();

  tempPageRangeStringList = createListOfRangesFromNumbers(numList: numList);

  return tempPageRangeStringList;
}

List<String> pageRangeAscendingSanitized(
    {required List<String> sanitizedPageRange}) {
  List<String> tempPageRangeStringList = [];
  for (int i = 0; i < sanitizedPageRange.length; i++) {
    String pageRangeString = sanitizedPageRange[i];
    if (pageRangeString.contains("-")) {
      List<String> tempSplit = pageRangeString.split("-");
      int rangeStart = int.parse(tempSplit.first);
      int rangeEnd = int.parse(tempSplit.last);
      if (rangeStart > rangeEnd) {
        for (int i = rangeStart; i >= rangeEnd; i--) {
          tempPageRangeStringList.add(i.toString());
        }
      } else if (rangeEnd > rangeStart) {
        for (int i = rangeStart; i <= rangeEnd; i++) {
          tempPageRangeStringList.add(i.toString());
        }
      }
    } else {
      tempPageRangeStringList.add(pageRangeString);
    }
  }

  tempPageRangeStringList = tempPageRangeStringList.toList();

  List<int> numList = tempPageRangeStringList.map((e) => int.parse(e)).toList();
  numList.sort();

  tempPageRangeStringList = createListOfRangesFromNumbers(numList: numList);

  return tempPageRangeStringList;
}

List<String> createListOfRangesFromNumbers({required List<int> numList}) {
  List<String> tempPageRangeStringList = [];
  if (numList.isNotEmpty) {
    List<List<int>> result = [];

    List<int> temp = [];

    bool continuingIncrease = false;
    bool continuingDecrease = false;

    for (int i = 0; i < numList.length; i++) {
      if (continuingIncrease == false && continuingDecrease == false) {
        if (temp.isNotEmpty) {
          result.add(temp);
          temp = [];
          temp.add(numList[i]);
        } else {
          temp.add(numList[i]);
        }
      } else {
        temp.add(numList[i]);
      }

      if (i + 1 < numList.length &&
          numList[i + 1] == numList[i] + 1 &&
          continuingDecrease == false) {
        continuingIncrease = true;
      } else {
        if (continuingIncrease) {
          continuingIncrease = false;
          result.add(temp);
          temp = [];
        }
      }

      if (i + 1 < numList.length &&
          numList[i + 1] == numList[i] - 1 &&
          continuingIncrease == false) {
        continuingDecrease = true;
      } else {
        if (continuingDecrease) {
          continuingDecrease = false;
          result.add(temp);
          temp = [];
        }
      }
    }
    if (temp.isNotEmpty) {
      result.add(temp);
    }

    for (int i = 0; i < result.length; i++) {
      if (result[i].length == 1) {
        tempPageRangeStringList.add(result[i].first.toString());
      } else {
        tempPageRangeStringList.add("${result[i].first}-${result[i].last}");
      }
    }
  }
  return tempPageRangeStringList;
}
