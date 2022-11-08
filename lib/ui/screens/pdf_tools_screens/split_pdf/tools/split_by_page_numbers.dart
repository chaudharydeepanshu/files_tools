import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/components/tools_about_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:files_tools/route/route.dart' as route;

class SplitByPageNumbers extends StatelessWidget {
  const SplitByPageNumbers(
      {Key? key, required this.pdfPageCount, required this.file})
      : super(key: key);

  final int pdfPageCount;
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        SplitByPageNumbersActionCard(pdfPageCount: pdfPageCount, file: file),
        const SizedBox(height: 16),
        const AboutActionCard(
          aboutText:
              'This method splits the pdf into multiple pdfs by providing page numbers.',
          exampleText:
              "If pages in selected PDF = 10\n\nAnd, your input = 3,7\n(Tip: 1 is default in input)\n\nThen, it will split the PDF from 1, 3 and 7\n\nSo, we will get 3 PDFs\n\nPDF 1 contain pages - 1,2\nPDF 2 contain pages - 3,4,5,6\nPDF 3 contain pages - 7,8,9,10",
        ),
      ],
    );
  }
}

class SplitByPageNumbersActionCard extends StatefulWidget {
  const SplitByPageNumbersActionCard(
      {Key? key, required this.pdfPageCount, required this.file})
      : super(key: key);

  final int pdfPageCount;
  final InputFileModel file;

  @override
  State<SplitByPageNumbersActionCard> createState() =>
      _SplitByPageNumbersActionCardState();
}

class _SplitByPageNumbersActionCardState
    extends State<SplitByPageNumbersActionCard> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController pageNumbersController = TextEditingController();
  List<int> pageNumbers = [];

  List<String> sets = [];

  List<String> getSetsFromPageNumbers(
      {required List<int> pageNumbers, required int pdfPageCount}) {
    List<String> sets = [];
    for (int i = 0; i < pageNumbers.length; i++) {
      int setStart = pageNumbers[i];
      int setEnd;
      if (i + 1 < pageNumbers.length) {
        setEnd = pageNumbers[i + 1] - 1;
      } else if (i + 1 == pageNumbers.length &&
          pageNumbers[i] != pdfPageCount) {
        setEnd = pdfPageCount;
      } else {
        setEnd = setStart;
      }
      sets.add("$setStart-$setEnd");
    }
    return sets;
  }

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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: pageNumbersController,
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: 'Enter Page Numbers',
                            // isDense: true,
                            helperText:
                                'Separate numbers by "," to set split point',
                            // enabledBorder: const UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp("[0-9,]"),
                                allow: true),
                          ],
                          onChanged: (String value) {
                            pageNumbers.clear();
                            List<String> pageNumbersStringList = value
                                .split(",") //splits string from comma
                                .map((e) => e
                                    .trim()) //removes all leading and trailing with spaces
                                .map((e) => e.replaceAll(RegExp(r'^0+(?=.)'),
                                    '')) //removes all leading zeros
                                .toSet() //combines all identical strings
                                .toList();
                            // removes all empty and longer strings than maximum page number possible
                            pageNumbersStringList.removeWhere((element) =>
                                element.isEmpty ||
                                element.length >
                                    widget.pdfPageCount.toString().length);
                            // converts strings to integer
                            for (var pageNumberString
                                in pageNumbersStringList) {
                              pageNumbers.add(int.parse(pageNumberString));
                            }
                            // Sorting list into ascending order
                            pageNumbers.sort((a, b) => a.compareTo(b));
                            // removes all number less than 1 and greater than maximum page number possible
                            pageNumbers.removeWhere((element) =>
                                element < 1 || element > widget.pdfPageCount);
                            // Inserts 1 ate index 0 if not found
                            if (pageNumbers.isNotEmpty && pageNumbers[0] != 1) {
                              pageNumbers.insert(0, 1);
                            }
                            setState(() {
                              sets = getSetsFromPageNumbers(
                                  pageNumbers: pageNumbers,
                                  pdfPageCount: widget.pdfPageCount);
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (pageNumbers.isEmpty) {
                              return 'Please enter number from 1 to ${widget.pdfPageCount} separated by ,';
                            }
                            return null;
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
                              pageNumbers.removeWhere((element) =>
                                  element < 1 || element > widget.pdfPageCount);
                              pageNumbersController.text =
                                  pageNumbers.join(",");
                              pageNumbersController.selection =
                                  TextSelection.collapsed(
                                      offset:
                                          pageNumbersController.text.length);
                            },
                            child: const Text("Sanitize Entered Data"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Input will generate PDF sets:-',
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
                                  sets.join(", "),
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
                                watchToolsActionsStateProviderValue
                                    .splitSelectedFile(
                                        files: [widget.file],
                                        pageNumbers: pageNumbers);
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
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
          ],
        ),
      ),
    );
  }
}
