import 'dart:math' as math;

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/tools_about_card.dart';
import 'package:files_tools/utils/decimal_text_input_formatter.dart';
import 'package:files_tools/utils/format_bytes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:files_tools/route/route.dart' as route;

class SplitBySize extends StatelessWidget {
  const SplitBySize({Key? key, required this.pdfPageCount, required this.file})
      : super(key: key);

  final int pdfPageCount;
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        SplitBySizeActionCard(pdfPageCount: pdfPageCount, file: file),
        const SizedBox(height: 16),
        const AboutActionCard(
          aboutText:
              'This method splits the pdf into multiple pdfs with the specified size.',
          exampleText: "",
        ),
      ],
    );
  }
}

class SplitBySizeActionCard extends StatefulWidget {
  const SplitBySizeActionCard(
      {Key? key, required this.pdfPageCount, required this.file})
      : super(key: key);

  final int pdfPageCount;
  final InputFileModel file;

  @override
  State<SplitBySizeActionCard> createState() => _SplitBySizeActionCardState();
}

class _SplitBySizeActionCardState extends State<SplitBySizeActionCard> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController sizeController = TextEditingController();

  final List<bool> isSelected = <bool>[true, false, false];

  List<Widget> sizeTypes = const [Text('KB'), Text('MB'), Text('GB')];

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
              'Size of selected pdf = ${widget.file.fileSizeFormatBytes}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            widget.pdfPageCount > 1
                ? Column(
                    children: [
                      ToggleButtons(
                        onPressed: (int index) {
                          setState(() {
                            for (int buttonIndex = 0;
                                buttonIndex < isSelected.length;
                                buttonIndex++) {
                              if (buttonIndex == index) {
                                isSelected[buttonIndex] = true;
                              } else {
                                isSelected[buttonIndex] = false;
                              }
                            }
                          });
                        },
                        isSelected: isSelected,
                        children: sizeTypes,
                      ),
                      const SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: sizeController,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Enter Size',
                            // isDense: true,
                            helperText: isSelected[0] == true
                                ? 'Example- ${double.parse(formatBytes(bytes: widget.file.fileSizeBytes, decimals: 2, formatType: BytesFormatType.KB)) / 2}'
                                : isSelected[1] == true
                                    ? 'Example- ${double.parse(formatBytes(bytes: widget.file.fileSizeBytes, decimals: 2, formatType: BytesFormatType.MB)) / 2}'
                                    : 'Example- ${double.parse(formatBytes(bytes: widget.file.fileSizeBytes, decimals: 2, formatType: BytesFormatType.GB)) / 2}',
                            // enabledBorder: const UnderlineInputBorder(),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            DecimalTextInputFormatter(decimalRange: 2)
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (isSelected[0] == true) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter number between 0 to ${formatBytes(bytes: widget.file.fileSizeBytes, decimals: 2, formatType: BytesFormatType.KB)}';
                              } else if (double.parse(value) <= 0) {
                                return 'Please enter number bigger than 0';
                              } else if (double.parse(value) >
                                  double.parse(formatBytes(
                                      bytes: widget.file.fileSizeBytes,
                                      decimals: 2,
                                      formatType: BytesFormatType.KB))) {
                                return 'Please enter number lower than ${formatBytes(bytes: widget.file.fileSizeBytes, decimals: 2, formatType: BytesFormatType.KB)}';
                              }
                              return null;
                            } else if (isSelected[1] == true) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter number between 0 to ${formatBytes(bytes: widget.file.fileSizeBytes, decimals: 2, formatType: BytesFormatType.MB)}';
                              } else if (double.parse(value) <= 0) {
                                return 'Please enter number bigger than 0';
                              } else if (double.parse(value) >
                                  double.parse(formatBytes(
                                      bytes: widget.file.fileSizeBytes,
                                      decimals: 2,
                                      formatType: BytesFormatType.MB))) {
                                return 'Please enter number lower than ${formatBytes(bytes: widget.file.fileSizeBytes, decimals: 2, formatType: BytesFormatType.MB)}';
                              }
                              return null;
                            } else {
                              if (value == null || value.isEmpty) {
                                return 'Please enter number between 0 to ${formatBytes(bytes: widget.file.fileSizeBytes, decimals: 2, formatType: BytesFormatType.GB)}';
                              } else if (double.parse(value) <= 0) {
                                return 'Please enter number bigger than 0';
                              } else if (double.parse(value) >
                                  double.parse(formatBytes(
                                      bytes: widget.file.fileSizeBytes,
                                      decimals: 2,
                                      formatType: BytesFormatType.GB))) {
                                return 'Please enter number lower than ${formatBytes(bytes: widget.file.fileSizeBytes, decimals: 2, formatType: BytesFormatType.GB)}';
                              }
                              return null;
                            }
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
                          return FilledButton.icon(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                watchToolsActionsStateProviderValue
                                    .splitSelectedFile(
                                  files: [widget.file],
                                  byteSize: isSelected[0] == true
                                      ? (math.pow(1000, 1) *
                                              double.parse(
                                                  sizeController.value.text))
                                          .toInt()
                                      : isSelected[1] == true
                                          ? (math.pow(1000, 2) *
                                                  double.parse(sizeController
                                                      .value.text))
                                              .toInt()
                                          : (math.pow(1000, 3) *
                                                  double.parse(sizeController
                                                      .value.text))
                                              .toInt(),
                                );
                                Navigator.pushNamed(
                                  context,
                                  route.resultPage,
                                );
                              }
                            },
                            icon: const Icon(Icons.check),
                            label: const Text("Split PDF"),
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
