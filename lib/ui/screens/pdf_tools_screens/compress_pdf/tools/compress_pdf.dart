import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:files_tools/route/route.dart' as route;

class CompressPDF extends StatelessWidget {
  const CompressPDF({Key? key, required this.pdfPageCount, required this.file})
      : super(key: key);

  final int pdfPageCount;
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        CompressPDFActionCard(pdfPageCount: pdfPageCount, file: file),
        const SizedBox(height: 16),
      ],
    );
  }
}

class CompressPDFActionCard extends StatefulWidget {
  const CompressPDFActionCard(
      {Key? key, required this.pdfPageCount, required this.file})
      : super(key: key);

  final int pdfPageCount;
  final InputFileModel file;

  @override
  State<CompressPDFActionCard> createState() => _CompressPDFActionCardState();
}

enum CompressionTypes { less, medium, extreme, custom }

class _CompressPDFActionCardState extends State<CompressPDFActionCard> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController imageScalingController =
      TextEditingController(text: '0.6');
  TextEditingController imageQualityController =
      TextEditingController(text: '70');

  bool isUnEmbedFonts = false;

  CompressionTypes compressionType = CompressionTypes.less;

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
            RadioListTile<CompressionTypes>(
              tileColor: Theme.of(context).colorScheme.surfaceVariant,
              // contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              title: const Text('Less Compression'),
              subtitle: const Text('High Quality'),
              value: CompressionTypes.less,
              groupValue: compressionType,
              onChanged: (CompressionTypes? value) {
                setState(() {
                  compressionType = value ?? CompressionTypes.less;
                });
              },
            ),
            const SizedBox(height: 10),
            RadioListTile<CompressionTypes>(
              tileColor: Theme.of(context).colorScheme.surfaceVariant,
              // contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              title: const Text('Medium Compression'),
              subtitle: const Text('Good Quality'),
              value: CompressionTypes.medium,
              groupValue: compressionType,
              onChanged: (CompressionTypes? value) {
                setState(() {
                  compressionType = value ?? CompressionTypes.less;
                });
              },
            ),
            const SizedBox(height: 10),
            RadioListTile<CompressionTypes>(
              tileColor: Theme.of(context).colorScheme.surfaceVariant,
              // contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              title: const Text('Extreme Compression'),
              subtitle: const Text('Low Quality'),
              value: CompressionTypes.extreme,
              groupValue: compressionType,
              onChanged: (CompressionTypes? value) {
                setState(() {
                  compressionType = value ?? CompressionTypes.less;
                });
              },
            ),
            const SizedBox(height: 10),
            RadioListTile<CompressionTypes>(
              tileColor: Theme.of(context).colorScheme.surfaceVariant,
              // contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              title: const Text('Custom Compression'),
              subtitle: compressionType != CompressionTypes.custom
                  ? const Text('Custom Quality')
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: imageScalingController,
                              decoration: const InputDecoration(
                                filled: true,
                                labelText: 'Enter Images Scaling',
                                isDense: true,
                                helperText: 'Example- 0.6',
                                // enabledBorder: const UnderlineInputBorder(),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter(RegExp("[0-9.]"),
                                    allow: true),
                              ],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter number greater than 0 and less than or equal to 1';
                                } else if (double.parse(value) <= 0) {
                                  return 'Please enter number greater than 0 and less than or equal to 1';
                                } else if (double.parse(value) > 1) {
                                  return 'Please enter number greater than 0 and less than or equal to 1';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: imageQualityController,
                              decoration: const InputDecoration(
                                filled: true,
                                labelText: 'Enter Images Quality',
                                isDense: true,
                                helperText: 'Example- 70',
                                // enabledBorder: const UnderlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter number from 1 to 100';
                                } else if (int.parse(value) <= 0) {
                                  return 'Please enter number from 1 to 100';
                                } else if (int.parse(value) > 100) {
                                  return 'Please enter number from 1 to 100';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
              value: CompressionTypes.custom,
              groupValue: compressionType,
              onChanged: (CompressionTypes? value) {
                setState(() {
                  compressionType = value ?? CompressionTypes.less;
                });
              },
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
                // contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                title: const Text("Remove fonts from pdf"),
                subtitle: const Text("Could make PDF text unreadable."),
                value: isUnEmbedFonts,
                onChanged: (bool? value) {
                  setState(() {
                    isUnEmbedFonts = value ?? !isUnEmbedFonts;
                  });
                }),
            const SizedBox(height: 10),
            Column(
              children: [
                const Divider(),
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    final ToolsActionsState
                        watchToolsActionsStateProviderValue =
                        ref.watch(toolsActionsStateProvider);

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      onPressed: () async {
                        double imageScale = compressionType ==
                                CompressionTypes.less
                            ? 0.9
                            : compressionType == CompressionTypes.medium
                                ? 0.7
                                : compressionType == CompressionTypes.extreme
                                    ? 0.7
                                    : compressionType == CompressionTypes.custom
                                        ? double.parse(
                                            imageScalingController.value.text)
                                        : 1;
                        int imageQuality = compressionType ==
                                CompressionTypes.less
                            ? 80
                            : compressionType == CompressionTypes.medium
                                ? 70
                                : compressionType == CompressionTypes.extreme
                                    ? 60
                                    : compressionType == CompressionTypes.custom
                                        ? int.parse(
                                            imageQualityController.value.text)
                                        : 100;
                        bool unEmbedFonts = isUnEmbedFonts;

                        if (compressionType == CompressionTypes.custom &&
                            _formKey.currentState!.validate()) {
                          watchToolsActionsStateProviderValue
                              .compressSelectedFile(
                            files: [widget.file],
                            imageScale: imageScale,
                            imageQuality: imageQuality,
                            unEmbedFonts: unEmbedFonts,
                          );
                          Navigator.pushNamed(
                            context,
                            route.resultPage,
                          );
                        } else {
                          watchToolsActionsStateProviderValue
                              .compressSelectedFile(
                            files: [widget.file],
                            imageScale: imageScale,
                            imageQuality: imageQuality,
                            unEmbedFonts: unEmbedFonts,
                          );
                          Navigator.pushNamed(
                            context,
                            route.resultPage,
                          );
                        }
                      },
                      child: const Text("Compress PDF"),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
