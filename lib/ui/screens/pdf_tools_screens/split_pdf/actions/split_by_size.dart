import 'dart:math' as math;

import 'package:files_tools/constants.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/tools_about_card.dart';
import 'package:files_tools/utils/decimal_text_input_formatter.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Action screen for splitting PDF by size.
class SplitBySize extends StatelessWidget {
  /// Defining [SplitBySize] constructor.
  const SplitBySize({Key? key, required this.pdfPageCount, required this.file})
      : super(key: key);

  /// Takes PDF file total page number..
  final int pdfPageCount;

  /// Takes input file.
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const SizedBox(height: 16),
        SplitBySizeActionCard(pdfPageCount: pdfPageCount, file: file),
        const SizedBox(height: 16),
        const AboutActionCard(
          aboutTitle: 'This function splits a pdf into multiple pdfs of '
              'specified size.',
          aboutBodyTitle: 'Example :-',
          aboutBody: 'If a PDF size = 100 MB'
              '\n\nAnd, your input(in MB) = 25'
              '\n\nThen, all result pdfs size will be under 25 MB'
              '\n\nNote: If a provided size is not possible then it'
              ' creates PDFs of minimum possible size.',
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Card for PDF size for splitting configuration.
class SplitBySizeActionCard extends StatefulWidget {
  /// Defining [SplitBySizeActionCard] constructor.
  const SplitBySizeActionCard({
    Key? key,
    required this.pdfPageCount,
    required this.file,
  }) : super(key: key);

  /// Takes PDF file total page number..
  final int pdfPageCount;

  /// Takes input file.
  final InputFileModel file;

  @override
  State<SplitBySizeActionCard> createState() => _SplitBySizeActionCardState();
}

class _SplitBySizeActionCardState extends State<SplitBySizeActionCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController sizeController = TextEditingController();

  BytesFormatType selected = BytesFormatType.KB;

  late double fileSizeInKB;
  late double fileSizeInMB;
  late double fileSizeInGB;

  @override
  void initState() {
    fileSizeInKB = double.parse(
      Utility.formatBytes(
        bytes: widget.file.fileSizeBytes,
        decimals: 2,
        formatType: BytesFormatType.KB,
      ),
    );
    fileSizeInMB = double.parse(
      Utility.formatBytes(
        bytes: widget.file.fileSizeBytes,
        decimals: 2,
        formatType: BytesFormatType.MB,
      ),
    );
    fileSizeInGB = double.parse(
      Utility.formatBytes(
        bytes: widget.file.fileSizeBytes,
        decimals: 2,
        formatType: BytesFormatType.GB,
      ),
    );
    super.initState();
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
          children: <Widget>[
            const Icon(Icons.looks_3),
            const Divider(),
            Text(
              'Size of selected pdf = ${widget.file.fileSizeFormatBytes}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            widget.pdfPageCount > 1
                ? Column(
                    children: <Widget>[
                      SegmentedButton<BytesFormatType>(
                        segments: const <ButtonSegment<BytesFormatType>>[
                          ButtonSegment<BytesFormatType>(
                            value: BytesFormatType.KB,
                            label: Text('KB'),
                          ),
                          ButtonSegment<BytesFormatType>(
                            value: BytesFormatType.MB,
                            label: Text('MB'),
                          ),
                          ButtonSegment<BytesFormatType>(
                            value: BytesFormatType.GB,
                            label: Text('GB'),
                          ),
                        ],
                        selected: <BytesFormatType>{selected},
                        onSelectionChanged: (Set<BytesFormatType> value) {
                          setState(() {
                            selected = value.first;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: (selected == BytesFormatType.KB
                                    ? fileSizeInKB
                                    : selected == BytesFormatType.MB
                                        ? fileSizeInMB
                                        : fileSizeInGB) >
                                0
                            ? TextFormField(
                                controller: sizeController,
                                decoration: InputDecoration(
                                  filled: true,
                                  labelText: 'Enter Size',
                                  // isDense: true,
                                  helperText: selected == BytesFormatType.KB
                                      ? 'Example- ${fileSizeInKB / 2}'
                                      : selected == BytesFormatType.MB
                                          ? 'Example- ${fileSizeInMB / 2}'
                                          : 'Example- ${fileSizeInGB / 2}',
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  DecimalTextInputFormatter(decimalRange: 2),
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'),
                                  ),
                                ],
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // The validator receives the text that the
                                // user has entered.
                                validator: (String? value) {
                                  if (selected == BytesFormatType.KB) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter number between 0 to '
                                          '$fileSizeInKB';
                                    } else if (double.parse(value) <= 0) {
                                      return 'Please enter number bigger '
                                          'than 0';
                                    } else if (double.parse(value) >
                                        double.parse(
                                          Utility.formatBytes(
                                            bytes: widget.file.fileSizeBytes,
                                            decimals: 2,
                                            formatType: BytesFormatType.KB,
                                          ),
                                        )) {
                                      return 'Please enter number lower than '
                                          '$fileSizeInKB';
                                    }
                                    return null;
                                  } else if (selected == BytesFormatType.MB) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter number between '
                                          '0 to '
                                          '$fileSizeInMB';
                                    } else if (double.parse(value) <= 0) {
                                      return 'Please enter number bigger '
                                          'than 0';
                                    } else if (double.parse(value) >
                                        double.parse(
                                          Utility.formatBytes(
                                            bytes: widget.file.fileSizeBytes,
                                            decimals: 2,
                                            formatType: BytesFormatType.MB,
                                          ),
                                        )) {
                                      return 'Please enter number lower than '
                                          '$fileSizeInMB';
                                    }
                                    return null;
                                  } else {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter number between 0 to '
                                          '$fileSizeInGB';
                                    } else if (double.parse(value) <= 0) {
                                      return 'Please enter number bigger '
                                          'than 0';
                                    } else if (double.parse(value) >
                                        double.parse(
                                          Utility.formatBytes(
                                            bytes: widget.file.fileSizeBytes,
                                            decimals: 2,
                                            formatType: BytesFormatType.GB,
                                          ),
                                        )) {
                                      return 'Please enter number lower than '
                                          '$fileSizeInGB';
                                    }
                                    return null;
                                  }
                                },
                              )
                            : Text(
                                'Sorry, pdf size is too small for taking '
                                'input in this unit. Please choose a '
                                'smaller unit.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                textAlign: TextAlign.center,
                              ),
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
                                watchToolsActionsStateProviderValue
                                    .mangeSplitPdfFileAction(
                                  toolAction: ToolAction.splitPdfByByteSize,
                                  sourceFile: widget.file,
                                  byteSize: selected == BytesFormatType.KB
                                      ? (math.pow(1000, 1) *
                                              double.parse(
                                                sizeController.value.text,
                                              ))
                                          .toInt()
                                      : selected == BytesFormatType.MB
                                          ? (math.pow(1000, 2) *
                                                  double.parse(
                                                    sizeController.value.text,
                                                  ))
                                              .toInt()
                                          : (math.pow(1000, 3) *
                                                  double.parse(
                                                    sizeController.value.text,
                                                  ))
                                              .toInt(),
                                );
                                Navigator.pushNamed(
                                  context,
                                  route.AppRoutes.resultPage,
                                );
                              }
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Split PDF'),
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