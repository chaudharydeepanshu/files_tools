import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/tools_about_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Action screen for extracting PDF pages based on page range.
class ExtractByPageRange extends StatelessWidget {
  /// Defining [ExtractByPageRange] constructor.
  const ExtractByPageRange({
    Key? key,
    required this.pdfPageCount,
    required this.file,
  }) : super(key: key);

  /// Takes PDF file total page number..
  final int pdfPageCount;

  /// Takes input file.
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String pdfSingular = appLocale.pdf(1);
    String splitWithPageIntervalInfoTitle =
        appLocale.tool_Split_WithPageRange_InfoTitle(pdfSingular);
    String splitWithPageIntervalInfoBody =
        appLocale.tool_Split_WithPageRange_InfoBody(pdfSingular);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: <Widget>[
        ExtractByPageRangeActionCard(pdfPageCount: pdfPageCount, file: file),
        const SizedBox(height: 16),
        AboutActionCard(
          aboutTitle: splitWithPageIntervalInfoTitle,
          aboutBodyTitle: '${appLocale.example}:-',
          aboutBody: splitWithPageIntervalInfoBody,
        ),
      ],
    );
  }
}

/// Card for PDF page range configuration.
class ExtractByPageRangeActionCard extends StatefulWidget {
  /// Defining [ExtractByPageRangeActionCard] constructor.
  const ExtractByPageRangeActionCard({
    Key? key,
    required this.pdfPageCount,
    required this.file,
  }) : super(key: key);

  /// Takes PDF file total page number..
  final int pdfPageCount;

  /// Takes input file.
  final InputFileModel file;

  @override
  State<ExtractByPageRangeActionCard> createState() =>
      _ExtractByPageRangeActionCardState();
}

class _ExtractByPageRangeActionCardState
    extends State<ExtractByPageRangeActionCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController pageNumbersController = TextEditingController();
  List<String> pageRangeStringList = <String>[];

  List<String> sanitizedData = <String>[];

  bool isRemoveDuplicates = false;
  bool isForceAscending = false;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String pdfSingular = appLocale.pdf(1);
    String resultFilePagesOrder =
        appLocale.tool_Action_ResultFilePagesOrder(pdfSingular);
    String enterPageRange = appLocale.textField_LabelText_EnterPageRange;
    String enterNumberFrom1ToPageCount =
        appLocale.textField_ErrorText_EnterNumbersAndRangeInRange(
      1,
      widget.pdfPageCount,
    );
    String sanitizeUserInput = appLocale.tool_Action_SanitizeUserInput;
    String discardRangeRepeatsListTileTitle =
        appLocale.tool_Split_DiscardRangeRepeats_ListTileTitle;
    String discardRangeRepeatsListTileSubTitle =
        appLocale.tool_Split_DiscardRangeRepeats_ListTileSubtitle;
    String forceRangeAscendingListTileTitle =
        appLocale.tool_Split_ForceRangeAscending_ListTileTitle;
    String forceRangeAscendingListTileSubTitle =
        appLocale.tool_Split_ForceRangeAscending_ListTileSubtitle;
    String extractSinglePageFileError =
        appLocale.tool_Split_ExtractSinglePageFileError(pdfSingular);
    String process = appLocale.button_Process;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.looks_3),
            const Divider(),
            Text(
              appLocale.noOfPagesInFile(appLocale.pdf(1), widget.pdfPageCount),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            widget.pdfPageCount > 1
                ? Column(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: pageNumbersController,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: enterPageRange,
                            // isDense: true,
                            helperText: '${appLocale.example}- 3,5-7',
                            // enabledBorder: const UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter(
                              RegExp('[0-9,-]'),
                              allow: true,
                            ),
                          ],
                          onChanged: (String value) {
                            pageRangeStringList = getPageRangeStringList(
                              value: value,
                              pdfPageCount: widget.pdfPageCount,
                              isRemoveDuplicates: isRemoveDuplicates,
                              isForceAscending: isForceAscending,
                            );
                            setState(() {
                              sanitizedData = pageRangeStringList;
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // The validator receives the text that the user
                          // has entered.
                          validator: (String? value) {
                            if (pageRangeStringList.isEmpty) {
                              return enterNumberFrom1ToPageCount;
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
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
                                  pageRangeStringList.join(',');
                              pageNumbersController.selection =
                                  TextSelection.collapsed(
                                offset: pageNumbersController.text.length,
                              );
                            },
                            child: Text(sanitizeUserInput),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: <Widget>[
                          CheckboxListTile(
                            visualDensity: VisualDensity.compact,
                            title: Text(discardRangeRepeatsListTileTitle),
                            subtitle: Text(discardRangeRepeatsListTileSubTitle),
                            value: isRemoveDuplicates,
                            onChanged: (bool? value) {
                              isRemoveDuplicates = value ?? !isRemoveDuplicates;
                              pageRangeStringList = getPageRangeStringList(
                                value: pageNumbersController.value.text,
                                pdfPageCount: widget.pdfPageCount,
                                isRemoveDuplicates: isRemoveDuplicates,
                                isForceAscending: isForceAscending,
                              );
                              setState(() {
                                sanitizedData = pageRangeStringList;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          CheckboxListTile(
                            visualDensity: VisualDensity.compact,
                            title: Text(forceRangeAscendingListTileTitle),
                            subtitle: Text(forceRangeAscendingListTileSubTitle),
                            value: isForceAscending,
                            onChanged: (bool? value) {
                              isForceAscending = value ?? !isForceAscending;
                              pageRangeStringList = getPageRangeStringList(
                                value: pageNumbersController.value.text,
                                pdfPageCount: widget.pdfPageCount,
                                isRemoveDuplicates: isRemoveDuplicates,
                                isForceAscending: isForceAscending,
                              );
                              setState(() {
                                sanitizedData = pageRangeStringList;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Text(
                                '$resultFilePagesOrder:-',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  sanitizedData.join(', '),
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      Consumer(
                        builder: (
                          BuildContext context,
                          WidgetRef ref,
                          Widget? child,
                        ) {
                          final ToolsActionsState
                              watchToolsActionsStateProviderValue =
                              ref.watch(toolsActionsStateProvider);
                          return FilledButton.icon(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                pageRangeStringList =
                                    enableReverseRangeForSanitizedRange(
                                  sanitizedPageRange: pageRangeStringList,
                                );
                                watchToolsActionsStateProviderValue
                                    .mangeSplitPdfFileAction(
                                  toolAction: ToolAction.extractPdfByPageRange,
                                  sourceFile: widget.file,
                                  pageRange: pageRangeStringList.join(','),
                                );
                                Navigator.pushNamed(
                                  context,
                                  route.AppRoutes.resultPage,
                                );
                              }
                            },
                            icon: const Icon(Icons.check),
                            label: Text(process),
                          );
                        },
                      ),
                    ],
                  )
                : Text(
                    extractSinglePageFileError,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
          ],
        ),
      ),
    );
  }
}

/// Called to get the page range for extraction based on current configuration.
List<String> getPageRangeStringList({
  required String? value,
  required int pdfPageCount,
  required bool isRemoveDuplicates,
  required bool isForceAscending,
}) {
  List<String> pageRangeStringList = <String>[];
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

/// Used to remove provided characters from the start and end of a string.
String strip(String str, String charactersToRemove) {
  String escapedChars = RegExp.escape(charactersToRemove);
  RegExp regex = RegExp(r'^[' + escapedChars + r']+|[' + escapedChars + r']+$');
  String newStr = str.replaceAll(regex, '').trim();
  return newStr;
}

/// Called to get a page range compatible with reverse page range.
///
/// Example:- If a reverse page range is 5-3, 15-7. Then this method will
/// convert the range to 5,4,3,15,14,13,12,11,10,9,8,7.
/// This needs to be done as our plugin doesn't understand large no.-smaller no.
/// as reverse range. So we need to convert then to single numbers in reverse
/// before providing to the plugin for extraction.
List<String> enableReverseRangeForSanitizedRange({
  required List<String> sanitizedPageRange,
}) {
  List<String> tempPageRangeStringList = <String>[];
  for (int i = 0; i < sanitizedPageRange.length; i++) {
    String pageRangeString = sanitizedPageRange[i];
    if (pageRangeString.contains('-')) {
      List<String> tempSplit = pageRangeString.split('-');
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

/// Mandatory sanitization of provided a page range.
List<String> pageRangeSanitized({
  required String? value,
  required int pdfPageCount,
}) {
  List<String> pageRangeStringList = <String>[];
  if (value != null) {
    // Removing extra/unused - and , at start and end.
    String newStrippedValue = strip(value, r'-,');
    // Getting list of elements in range and removing extra/unused - and , and
    // space at start and end of individual element in range.
    pageRangeStringList = newStrippedValue
        .split(',')
        .map((String e) => e.trim())
        .map((String e) => strip(e, r'-').replaceAll(RegExp(r'^0+(?=.)'), ''))
        .toList();
    // Removing empty elements in range.
    pageRangeStringList.removeWhere((String element) => element.isEmpty);
    // Recreating the range with left over elements and .
    List<String> tempPageRangeStringList = <String>[];
    for (int i = 0; i < pageRangeStringList.length; i++) {
      String pageRangeString = pageRangeStringList[i];
      if (pageRangeString.contains('-')) {
        // If element is range.
        // Removing 0 from front of each element of a range element.
        List<String> tempSplit = pageRangeString
            .split('-')
            .map((String e) => e.replaceAll('^0+', ''))
            .toList();
        // Removing 0 from front of each element of a range element.
        String rangeStart = tempSplit.first.replaceAll(RegExp(r'^0+(?=.)'), '');
        String rangeEnd = tempSplit.last.replaceAll(RegExp(r'^0+(?=.)'), '');

        if (rangeStart.length > pdfPageCount.toString().length ||
            int.parse(rangeStart) > pdfPageCount) {
          // If start element string length is larger than total page string
          // length then do not add.
          // If start element number is larger than total page then then do
          // not add.
        } else if (rangeEnd == rangeStart) {
          // If both start and end element is same then add start element.
          tempPageRangeStringList.add(rangeStart);
        } else {
          if (rangeEnd.length > pdfPageCount.toString().length ||
              int.parse(rangeEnd) > pdfPageCount) {
            // If end element number is larger than total page then
            // use total page as end element and add the new range.
            tempPageRangeStringList.add('$rangeStart-$pdfPageCount');
          } else {
            // Add range again if no change required.
            tempPageRangeStringList.add('$rangeStart-$rangeEnd');
          }
        }
      } else {
        // If element is not a range.
        if (pageRangeString.length > pdfPageCount.toString().length ||
            int.parse(pageRangeString) > pdfPageCount) {
          // If element string length is larger than total page string
          // length then then do not add.
          // If element number is larger than total page then then do not add.
        } else if (pageRangeString == '0') {
          // If element number is 0 then do not add.
        } else {
          // Add element again if no change required.
          tempPageRangeStringList.add(pageRangeString);
        }
      }
    }
    // Assigning the temporary rage list to final range.
    pageRangeStringList = List<String>.from(tempPageRangeStringList);
  }

  return pageRangeStringList;
}

/// Sanitization when force ascending and remove duplicates are turned off.
///
/// Recreates the page range string connecting the elements which are
/// consecutive range but are still separated.
List<String> pageRangeGeneralSanitized({
  required List<String> sanitizedPageRange,
}) {
  List<String> tempPageRangeStringList = <String>[];
  for (int i = 0; i < sanitizedPageRange.length; i++) {
    String pageRangeString = sanitizedPageRange[i];
    if (pageRangeString.contains('-')) {
      List<String> tempSplit = pageRangeString.split('-');
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

  List<int> numList =
      tempPageRangeStringList.map((String e) => int.parse(e)).toList();

  tempPageRangeStringList = createListOfRangesFromNumbers(numList: numList);

  return tempPageRangeStringList;
}

/// Sanitization when remove duplicates is turned on.
///
/// Recreates the page range string splitting range into single page number
/// and removing repeated duplicates from that. And then converts back to
/// page range with connecting the elements which are consecutive range but
/// are still separated.
List<String> pageRangeDuplicatesSanitized({
  required List<String> sanitizedPageRange,
}) {
  List<String> tempPageRangeStringList = <String>[];
  for (int i = 0; i < sanitizedPageRange.length; i++) {
    String pageRangeString = sanitizedPageRange[i];
    if (pageRangeString.contains('-')) {
      List<String> tempSplit = pageRangeString.split('-');
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

  List<int> numList =
      tempPageRangeStringList.map((String e) => int.parse(e)).toList();

  tempPageRangeStringList = createListOfRangesFromNumbers(numList: numList);

  return tempPageRangeStringList;
}

/// Sanitization when remove duplicates is turned on.
///
/// Recreates the page range string splitting range into single page number
/// and arranging them to ascending order. And then converts back to
/// page range with connecting the elements which are consecutive range but
/// are still separated.
List<String> pageRangeAscendingSanitized({
  required List<String> sanitizedPageRange,
}) {
  List<String> tempPageRangeStringList = <String>[];
  for (int i = 0; i < sanitizedPageRange.length; i++) {
    String pageRangeString = sanitizedPageRange[i];
    if (pageRangeString.contains('-')) {
      List<String> tempSplit = pageRangeString.split('-');
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

  List<int> numList =
      tempPageRangeStringList.map((String e) => int.parse(e)).toList();
  numList.sort();

  tempPageRangeStringList = createListOfRangesFromNumbers(numList: numList);

  return tempPageRangeStringList;
}

/// For creating list of range from list of numbers.
///
/// Example if a list of number is: 1,2,3,4,6,8,9 then list of range would
/// be: 1-4,6-6,8-9
List<String> createListOfRangesFromNumbers({required List<int> numList}) {
  List<String> tempPageRangeStringList = <String>[];
  if (numList.isNotEmpty) {
    List<List<int>> result = <List<int>>[];

    List<int> temp = <int>[];

    bool continuingIncrease = false;
    bool continuingDecrease = false;

    for (int i = 0; i < numList.length; i++) {
      if (continuingIncrease == false && continuingDecrease == false) {
        if (temp.isNotEmpty) {
          result.add(temp);
          temp = <int>[];
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
          temp = <int>[];
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
          temp = <int>[];
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
        tempPageRangeStringList.add('${result[i].first}-${result[i].last}');
      }
    }
  }
  return tempPageRangeStringList;
}
