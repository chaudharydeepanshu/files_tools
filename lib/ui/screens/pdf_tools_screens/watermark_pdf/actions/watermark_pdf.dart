import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/color_picker.dart';
import 'package:files_tools/utils/decimal_text_input_formatter.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';

/// Action screen for watermarking PDF.
class WatermarkPDF extends StatelessWidget {
  /// Defining [WatermarkPDF] constructor.
  const WatermarkPDF({Key? key, required this.pdfPageCount, required this.file})
      : super(key: key);

  /// Takes PDF file total page number..
  final int pdfPageCount;

  /// Takes input file.
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: <Widget>[
        WatermarkPdfActionCard(pdfPageCount: pdfPageCount, file: file),
      ],
    );
  }
}

/// Card for watermarking configuration.
class WatermarkPdfActionCard extends StatefulWidget {
  /// Defining [WatermarkPdfActionCard] constructor.
  const WatermarkPdfActionCard({
    Key? key,
    required this.pdfPageCount,
    required this.file,
  }) : super(key: key);

  /// Takes PDF file total page number..
  final int pdfPageCount;

  /// Takes input file.
  final InputFileModel file;

  @override
  State<WatermarkPdfActionCard> createState() => _WatermarkPdfActionCardState();
}

class _WatermarkPdfActionCardState extends State<WatermarkPdfActionCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController textController =
      TextEditingController(text: 'Watermark Text');

  TextEditingController fontSizeController = TextEditingController(text: '50');

  TextEditingController textOpacityController =
      TextEditingController(text: '0.7');

  TextEditingController textRotationAngleController =
      TextEditingController(text: '45');

  Color watermarkColor = Colors.black;

  PositionType positionType = PositionType.center;

  WatermarkLayer watermarkLayer = WatermarkLayer.overContent;

  late String colorMaterialNameAndCode = ColorTools.materialNameAndCode(
    watermarkColor,
    colorSwatchNameMap: colorsNameMap,
  );

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String enterWatermarkText =
        appLocale.textField_LabelText_EnterWatermarkText;
    String example = appLocale.example;
    String fieldMustBeFilled = appLocale.textField_ErrorText_FldMustBeFilled;
    String enterWatermarkFontSize =
        appLocale.textField_LabelText_EnterWatermarkFontSize;
    String enterNumberGreaterThan0 =
        appLocale.textField_ErrorText_EnterNumberGreaterThanXNumber(0);
    String enterWatermarkOpacity =
        appLocale.textField_LabelText_EnterWatermarkOpacity;
    String enterNumberFrom0To1Excluding0 =
        appLocale.textField_ErrorText_EnterNumberInRangeExcludingBegin(
      0,
      1,
    );
    String enterWatermarkRotationAngle =
        appLocale.textField_LabelText_EnterWatermarkRotationAngle;
    String chooseWatermarkColor = appLocale.tool_Watermark_SelectWatermarkColor;
    String chooseWatermarkLayer = appLocale.tool_Watermark_SelectWatermarkLayer;
    String layerTypeOverContent =
        appLocale.tool_Watermark_LayerType_OverContent;
    String layerTypeUnderContent =
        appLocale.tool_Watermark_LayerType_UnderContent;
    String chooseWatermarkPosition =
        appLocale.tool_Watermark_SelectWatermarkPosition;
    String positionTypeTopLeft = appLocale.tool_Watermark_PositionType_TopLeft;
    String positionTypeTopCenter =
        appLocale.tool_Watermark_PositionType_TopCenter;
    String positionTypeTopRight =
        appLocale.tool_Watermark_PositionType_TopRight;
    String positionTypeCenterLeft =
        appLocale.tool_Watermark_PositionType_CenterLeft;
    String positionTypeCenter = appLocale.tool_Watermark_PositionType_Center;
    String positionTypeCenterRight =
        appLocale.tool_Watermark_PositionType_CenterRight;
    String positionTypeBottomLeft =
        appLocale.tool_Watermark_PositionType_BottomLeft;
    String positionTypeBottomCenter =
        appLocale.tool_Watermark_PositionType_BottomCenter;
    String positionTypeBottomRight =
        appLocale.tool_Watermark_PositionType_BottomRight;
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
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: enterWatermarkText,
                      isDense: true,
                      helperText: '$example- Confidential',
                      // enabledBorder: const UnderlineInputBorder(),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // The validator receives the text that the user
                    // has entered.
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return fieldMustBeFilled;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: fontSizeController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: enterWatermarkFontSize,
                      isDense: true,
                      helperText: '$example- 55',
                      // enabledBorder: const UnderlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      DecimalTextInputFormatter(decimalRange: 2),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // The validator receives the text that the user
                    // has entered.
                    validator: (String? value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.parse(value) <= 0) {
                        return enterNumberGreaterThan0;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: textOpacityController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: enterWatermarkOpacity,
                      isDense: true,
                      helperText: '${appLocale.example}- 0.5',
                      // enabledBorder: const UnderlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      DecimalTextInputFormatter(decimalRange: 2),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    controller: textRotationAngleController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: enterWatermarkRotationAngle,
                      isDense: true,
                      helperText: '${appLocale.example}- 135',
                      // enabledBorder: const UnderlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      DecimalTextInputFormatter(decimalRange: 2),
                      FilteringTextInputFormatter(
                        RegExp('[0-9.-]'),
                        allow: true,
                      ),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // The validator receives the text that the user
                    // has entered.
                    validator: (String? value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.tryParse(value) == null) {
                        return fieldMustBeFilled;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(
                chooseWatermarkColor,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              visualDensity: VisualDensity.compact,
              subtitle: Text(
                '$colorMaterialNameAndCode '
                'aka ${ColorTools.nameThatColor(watermarkColor)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: ColorIndicator(
                width: 42,
                height: 42,
                borderRadius: 12,
                color: watermarkColor,
                onSelectFocus: false,
              ),
              onTap: () async {
                // Wait for the picker to close, if dialog was dismissed,
                // then restore the color we had before it was opened.
                await colorPickerDialog(
                  context: context,
                  dialogPickerColor: watermarkColor,
                  onColorChanged: (Color value) {
                    setState(() {
                      watermarkColor = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            Text('$chooseWatermarkLayer :-'),
            SegmentedButton<WatermarkLayer>(
              segments: <ButtonSegment<WatermarkLayer>>[
                ButtonSegment<WatermarkLayer>(
                  value: WatermarkLayer.overContent,
                  label: Text(layerTypeOverContent),
                ),
                ButtonSegment<WatermarkLayer>(
                  value: WatermarkLayer.underContent,
                  label: Text(layerTypeUnderContent),
                ),
              ],
              selected: <WatermarkLayer>{watermarkLayer},
              onSelectionChanged: (Set<WatermarkLayer> value) {
                setState(() {
                  watermarkLayer = value.first;
                });
              },
            ),
            const SizedBox(height: 10),
            Text('$chooseWatermarkPosition :-'),
            Flexible(
              child: SizedBox(
                // width: 200,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 50,
                  ),
                  itemCount: 9,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return WatermarkPositionButton(
                        positionText: positionTypeTopLeft,
                        isPositionSelected:
                            positionType == PositionType.topLeft,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.topLeft;
                          });
                        },
                        positionBorderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                        ),
                      );
                    } else if (index == 1) {
                      return WatermarkPositionButton(
                        positionText: positionTypeTopCenter,
                        isPositionSelected:
                            positionType == PositionType.topCenter,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.topCenter;
                          });
                        },
                        positionBorderRadius: const BorderRadius.only(),
                      );
                    } else if (index == 2) {
                      return WatermarkPositionButton(
                        positionText: positionTypeTopRight,
                        isPositionSelected:
                            positionType == PositionType.topRight,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.topRight;
                          });
                        },
                        positionBorderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                        ),
                      );
                    } else if (index == 3) {
                      return WatermarkPositionButton(
                        positionText: positionTypeCenterLeft,
                        isPositionSelected:
                            positionType == PositionType.centerLeft,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.centerLeft;
                          });
                        },
                        positionBorderRadius: const BorderRadius.only(),
                      );
                    } else if (index == 4) {
                      return WatermarkPositionButton(
                        positionText: positionTypeCenter,
                        isPositionSelected: positionType == PositionType.center,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.center;
                          });
                        },
                        positionBorderRadius: const BorderRadius.only(),
                      );
                    } else if (index == 5) {
                      return WatermarkPositionButton(
                        positionText: positionTypeCenterRight,
                        isPositionSelected:
                            positionType == PositionType.centerRight,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.centerRight;
                          });
                        },
                        positionBorderRadius: const BorderRadius.only(),
                      );
                    } else if (index == 6) {
                      return WatermarkPositionButton(
                        positionText: positionTypeBottomLeft,
                        isPositionSelected:
                            positionType == PositionType.bottomLeft,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.bottomLeft;
                          });
                        },
                        positionBorderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                        ),
                      );
                    } else if (index == 7) {
                      return WatermarkPositionButton(
                        positionText: positionTypeBottomCenter,
                        isPositionSelected:
                            positionType == PositionType.bottomCenter,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.bottomCenter;
                          });
                        },
                        positionBorderRadius: const BorderRadius.only(),
                      );
                    } else {
                      return WatermarkPositionButton(
                        positionText: positionTypeBottomRight,
                        isPositionSelected:
                            positionType == PositionType.bottomRight,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.bottomRight;
                          });
                        },
                        positionBorderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(12),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
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
                        if (_formKey.currentState!.validate()) {
                          watchToolsActionsStateProviderValue
                              .mangeWatermarkPdfFileAction(
                            sourceFile: widget.file,
                            text: textController.value.text,
                            fontSize:
                                double.parse(fontSizeController.value.text),
                            watermarkLayer: watermarkLayer,
                            opacity:
                                double.parse(textOpacityController.value.text),
                            rotationAngle: double.parse(
                              textRotationAngleController.value.text,
                            ),
                            watermarkColor: watermarkColor,
                            positionType: positionType,
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

/// Widget for watermark position buttons.
class WatermarkPositionButton extends StatelessWidget {
  /// Defining [WatermarkPositionButton] constructor.
  const WatermarkPositionButton({
    Key? key,
    required this.positionText,
    this.onPositionChange,
    required this.isPositionSelected,
    required this.positionBorderRadius,
  }) : super(key: key);

  /// Position button text.
  final String positionText;

  /// Position button click action.
  final void Function()? onPositionChange;

  /// Is true if this position is selected.
  final bool isPositionSelected;

  /// Position button border radius.
  final BorderRadiusGeometry positionBorderRadius;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: isPositionSelected
          ? OutlinedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              shape: RoundedRectangleBorder(borderRadius: positionBorderRadius),
            )
          : OutlinedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(borderRadius: positionBorderRadius),
            ),
      onPressed: onPositionChange,
      child: Text(
        positionText,
        textAlign: TextAlign.center,
        style: isPositionSelected
            ? Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                )
            : null,
      ),
    );
  }
}
