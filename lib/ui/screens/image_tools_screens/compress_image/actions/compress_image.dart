import 'package:files_tools/constants.dart';
import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/tools_about_card.dart';
import 'package:files_tools/utils/decimal_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Action screen for compressing image.
class CompressImage extends StatelessWidget {
  /// Defining [CompressImage] constructor.
  const CompressImage({Key? key, required this.files}) : super(key: key);

  /// Takes input files.
  final List<InputFileModel> files;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String pdfSingular = appLocale.pdf(1);
    String pdfPlural = appLocale.pdf(1);
    String aboutCompressTitle = appLocale
        .tool_Compress_InfoTitle(files.length > 1 ? pdfPlural : pdfSingular);
    String aboutCompressBody = appLocale
        .tool_Compress_InfoBody(files.length > 1 ? pdfPlural : pdfSingular);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: <Widget>[
        CompressImageActionCard(files: files),
        const SizedBox(height: 16),
        AboutActionCard(
          aboutTitle: aboutCompressTitle,
          aboutBody: aboutCompressBody,
        ),
      ],
    );
  }
}

/// Card for compression configuration.
class CompressImageActionCard extends StatefulWidget {
  /// Defining [CompressImageActionCard] constructor.
  const CompressImageActionCard({Key? key, required this.files})
      : super(key: key);

  /// Takes input files.
  final List<InputFileModel> files;

  @override
  State<CompressImageActionCard> createState() =>
      _CompressImageActionCardState();
}

class _CompressImageActionCardState extends State<CompressImageActionCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController imageScalingController =
      TextEditingController(text: '0.6');
  TextEditingController imageQualityController =
      TextEditingController(text: '70');

  bool removeExifData = false;

  CompressionTypes compressionType = CompressionTypes.less;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String lowCompression = appLocale.tool_Compress_CompressionType_Low;
    String mediumCompression = appLocale.tool_Compress_CompressionType_Medium;
    String highCompression = appLocale.tool_Compress_CompressionType_High;
    String customCompression = appLocale.tool_Compress_CompressionType_Custom;
    String lowQuality = appLocale.tool_Compress_QualityType_Low;
    String okQuality = appLocale.tool_Compress_QualityType_Ok;
    String goodQuality = appLocale.tool_Compress_QualityType_Good;
    String customQuality = appLocale.tool_Compress_QualityType_Custom;
    String enterImageScaling = appLocale.textField_LabelText_EnterImageScaling;
    String enterImageQuality = appLocale.textField_LabelText_EnterImageQuality;
    String example = appLocale.example;
    String removeExifDataListTileTitle =
        appLocale.tool_CompressImage_RemoveExifData_ListTileTitle;
    String removeExifDataListTileSubtitle =
        appLocale.tool_CompressImage_RemoveExifData_ListTileSubtitle;
    String enterNumberFrom0To1Excluding0 =
        appLocale.textField_ErrorText_EnterNumberInRangeExcludingBegin(
      0,
      1,
    );
    String enterNumberFrom0To100Excluding0 =
        appLocale.textField_ErrorText_EnterNumberInRangeExcludingBegin(
      0,
      100,
    );
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
            RadioListTile<CompressionTypes>(
              visualDensity: VisualDensity.compact,
              title: Text(lowCompression),
              subtitle: Text(goodQuality),
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
              visualDensity: VisualDensity.compact,
              title: Text(mediumCompression),
              subtitle: Text(okQuality),
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
              visualDensity: VisualDensity.compact,
              title: Text(highCompression),
              subtitle: Text(lowQuality),
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
              visualDensity: VisualDensity.compact,
              title: Text(customCompression),
              subtitle: compressionType != CompressionTypes.custom
                  ? Text(customQuality)
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              controller: imageScalingController,
                              decoration: InputDecoration(
                                filled: true,
                                labelText: enterImageScaling,
                                isDense: true,
                                helperText: '$example- 0.6',
                                // enabledBorder: const UnderlineInputBorder(),
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
                              // The validator receives the text that the user
                              // has entered.
                              validator: (String? value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    double.parse(value) <= 0 ||
                                    double.parse(value) > 1) {
                                  return enterNumberFrom0To1Excluding0;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: imageQualityController,
                              decoration: InputDecoration(
                                filled: true,
                                labelText: enterImageQuality,
                                isDense: true,
                                helperText: '$example- 70',
                                // enabledBorder: const UnderlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // The validator receives the text that the user
                              // has entered.
                              validator: (String? value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    int.parse(value) <= 0 ||
                                    int.parse(value) > 100) {
                                  return enterNumberFrom0To100Excluding0;
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
              visualDensity: VisualDensity.compact,
              title: Text(removeExifDataListTileTitle),
              subtitle: Text(removeExifDataListTileSubtitle),
              value: removeExifData,
              onChanged: (bool? value) {
                setState(() {
                  removeExifData = value ?? !removeExifData;
                });
              },
            ),
            const SizedBox(height: 10),
            Column(
              children: <Widget>[
                const Divider(),
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    final ToolsActionsState
                        watchToolsActionsStateProviderValue =
                        ref.watch(toolsActionsStateProvider);

                    return FilledButton.icon(
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
                                            imageScalingController.value.text,
                                          )
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
                                            imageQualityController.value.text,
                                          )
                                        : 100;

                        if (compressionType == CompressionTypes.custom &&
                            _formKey.currentState!.validate()) {
                          watchToolsActionsStateProviderValue
                              .mangeCompressImageFileAction(
                            sourceFiles: widget.files,
                            imageScale: imageScale,
                            imageQuality: imageQuality,
                            removeExifData: removeExifData,
                          );
                          Navigator.pushNamed(
                            context,
                            route.AppRoutes.resultPage,
                          );
                        } else {
                          watchToolsActionsStateProviderValue
                              .mangeCompressImageFileAction(
                            sourceFiles: widget.files,
                            imageScale: imageScale,
                            imageQuality: imageQuality,
                            removeExifData: removeExifData,
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
            ),
          ],
        ),
      ),
    );
  }
}
