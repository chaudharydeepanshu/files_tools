import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/split_pdf_tools_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:files_tools/route/route.dart' as route;

class SplitByPageRange extends StatelessWidget {
  const SplitByPageRange(
      {Key? key, required this.pdfPageCount, required this.file})
      : super(key: key);

  final int pdfPageCount;
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SplitByPageRangeActionCard(pdfPageCount: pdfPageCount, file: file),
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

class SplitByPageRangeActionCard extends StatefulWidget {
  const SplitByPageRangeActionCard(
      {Key? key, required this.pdfPageCount, required this.file})
      : super(key: key);

  final int pdfPageCount;
  final InputFileModel file;

  @override
  State<SplitByPageRangeActionCard> createState() =>
      _SplitByPageRangeActionCardState();
}

class _SplitByPageRangeActionCardState
    extends State<SplitByPageRangeActionCard> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController pageNumbersController = TextEditingController();
  List<String> pageRangeStringList = [];

  List<String> sanitizedData = [];

  bool isRemoveDuplicates = false;
  bool isForceAscending = false;

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
            const Icon(Icons.looks_3),
            const Divider(),
            Text(
              'Pages in selected pdf = ${widget.pdfPageCount}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            widget.pdfPageCount > 1
                ? Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: pageNumbersController,
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: 'Enter Page Range',
                            // isDense: true,
                            helperText: 'Example- 3,5-7',
                            // enabledBorder: const UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp("[0-9,-]"),
                                allow: true),
                          ],
                          onChanged: (String value) {
                            pageRangeStringList = getPageRangeStringList(
                                value: value,
                                pdfPageCount: widget.pdfPageCount,
                                isRemoveDuplicates: isRemoveDuplicates,
                                isForceAscending: isForceAscending);
                            setState(() {
                              sanitizedData = pageRangeStringList;
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            return pageRangeGeneralValidator(
                                pageRangeStringList: pageRangeStringList,
                                pdfPageCount: widget.pdfPageCount);
                          },
                        ),
                      ),
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
                              pageNumbersController.text =
                                  pageRangeStringList.join(",");
                              pageNumbersController.selection =
                                  TextSelection.collapsed(
                                      offset:
                                          pageNumbersController.text.length);
                            },
                            child: const Text("Sanitize Input"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          CheckboxListTile(
                              tileColor:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              // contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              title: Text("Remove repeats in range",
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              value: isRemoveDuplicates,
                              onChanged: (bool? value) {
                                isRemoveDuplicates =
                                    value ?? !isRemoveDuplicates;
                                pageRangeStringList = getPageRangeStringList(
                                    value: pageNumbersController.value.text,
                                    pdfPageCount: widget.pdfPageCount,
                                    isRemoveDuplicates: isRemoveDuplicates,
                                    isForceAscending: isForceAscending);
                                setState(() {
                                  sanitizedData = pageRangeStringList;
                                });
                              }),
                          const SizedBox(height: 10),
                          CheckboxListTile(
                              tileColor:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              // contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              title: Text("Force Ascending",
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              value: isForceAscending,
                              onChanged: (bool? value) {
                                isForceAscending = value ?? !isForceAscending;
                                pageRangeStringList = getPageRangeStringList(
                                    value: pageNumbersController.value.text,
                                    pdfPageCount: widget.pdfPageCount,
                                    isRemoveDuplicates: isRemoveDuplicates,
                                    isForceAscending: isForceAscending);
                                setState(() {
                                  sanitizedData = pageRangeStringList;
                                });
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
                                  style: Theme.of(context).textTheme.caption,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          final ToolsActionsState
                              watchToolsActionsStateProviderValue =
                              ref.watch(toolsActionsStateProvider);
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ).copyWith(
                                elevation: ButtonStyleButton.allOrNull(0.0)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                pageRangeStringList =
                                    enableReverseRangeForSanitizedRange(
                                        sanitizedPageRange:
                                            pageRangeStringList);
                                watchToolsActionsStateProviderValue
                                    .splitSelectedFile(files: [
                                  widget.file
                                ], pageRange: pageRangeStringList.join(","));
                                Navigator.pushNamed(
                                  context,
                                  route.resultPage,
                                );
                              }
                            },
                            child: const Text("Split PDF"),
                          );
                        },
                      ),
                    ],
                  )
                : Text(
                    'Sorry, can\'t split a pdf with less than 2 pages.',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
          ],
        ),
      ),
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