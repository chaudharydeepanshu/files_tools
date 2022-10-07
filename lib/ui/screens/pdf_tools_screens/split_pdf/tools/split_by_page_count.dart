import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/split_pdf_tools_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:files_tools/route/route.dart' as route;

class SplitByPageCount extends StatelessWidget {
  const SplitByPageCount(
      {Key? key, required this.pdfPageCount, required this.file})
      : super(key: key);

  final int pdfPageCount;
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SplitByPageCountActionCard(pdfPageCount: pdfPageCount, file: file),
        const SizedBox(height: 16),
        const AboutActionCard(
          aboutText:
              'This method splits the pdf into multiple pdfs containing no. of pages equals to the page count.',
          exampleText: "",
        ),
      ],
    );
  }
}

class SplitByPageCountActionCard extends StatefulWidget {
  const SplitByPageCountActionCard(
      {Key? key, required this.pdfPageCount, required this.file})
      : super(key: key);

  final int pdfPageCount;
  final InputFileModel file;

  @override
  State<SplitByPageCountActionCard> createState() =>
      _SplitByPageCountActionCardState();
}

class _SplitByPageCountActionCardState
    extends State<SplitByPageCountActionCard> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController pageCountController = TextEditingController();

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
                          controller: pageCountController,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Enter Page Count',
                            // isDense: true,
                            helperText: 'Example- ${widget.pdfPageCount ~/ 2}',
                            // enabledBorder: const UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter number between 0 to ${widget.pdfPageCount}';
                            } else if (int.parse(value) <= 0) {
                              return 'Please enter number bigger than 0';
                            } else if (int.parse(value) > widget.pdfPageCount) {
                              return 'Please enter number lower than ${widget.pdfPageCount}';
                            }
                            return null;
                          },
                        ),
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
                                        pageCount: int.parse(
                                            pageCountController.value.text));
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
