import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/color_picker.dart';
import 'package:files_tools/utils/decimal_text_input_formatter.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:files_tools/route/route.dart' as route;
import 'package:pdf_manipulator/pdf_manipulator.dart';

class WatermarkPDF extends StatelessWidget {
  const WatermarkPDF({Key? key, required this.pdfPageCount, required this.file})
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

  TextEditingController textController =
      TextEditingController(text: 'Watermark Text');

  TextEditingController fontSizeController = TextEditingController(text: '50');

  TextEditingController textOpacityController =
      TextEditingController(text: '0.7');

  TextEditingController textRotationAngleController =
      TextEditingController(text: '45');

  WatermarkLayer watermarkLayer = WatermarkLayer.overContent;

  Color watermarkColor = Colors.black;

  PositionType positionType = PositionType.center;

  final List<bool> isSelectedForLayerTypes = <bool>[false, true];

  List<Widget> layerTypes = const [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text('Under Content'),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text('Over Content'),
    )
  ];

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
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: textController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Enter Watermark Text',
                      isDense: true,
                      helperText: 'Example- Confidential',
                      // enabledBorder: const UnderlineInputBorder(),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter watermark text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: fontSizeController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Enter Font Size',
                      isDense: true,
                      helperText: 'Example- 55',
                      // enabledBorder: const UnderlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter(RegExp("[0-9.]"),
                          allow: true),
                      DecimalTextInputFormatter(decimalRange: 2),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number greater than 0';
                      } else if (double.parse(value) <= 0) {
                        return 'Please enter number greater than 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: textOpacityController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Enter Text Opacity',
                      isDense: true,
                      helperText: 'Example- 0.5',
                      // enabledBorder: const UnderlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter(RegExp("[0-9.]"),
                          allow: true),
                      DecimalTextInputFormatter(decimalRange: 2),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    controller: textRotationAngleController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Enter Rotation Angle',
                      isDense: true,
                      helperText: 'Example- 135',
                      // enabledBorder: const UnderlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter(RegExp("[0-9.-]"),
                          allow: true),
                      TextInputFormatter.withFunction(
                          (TextEditingValue oldValue,
                              TextEditingValue newValue) {
                        final newValueText = newValue.text;

                        if (newValueText == "-" ||
                            newValueText == "-." ||
                            newValueText == ".") {
                          // Returning new value if text field contains only "." or "-." or ".".
                          return newValue;
                        } else if (newValueText.isNotEmpty) {
                          // If text filed not empty and value updated then trying to parse it as a double.
                          try {
                            double.parse(newValueText);
                            // Here double parsing succeeds so returning that new value.
                            return newValue;
                          } catch (e) {
                            // Here double parsing failed so returning that old value.
                            return oldValue;
                          }
                        } else {
                          // Returning new value if text field was empty.
                          return newValue;
                        }
                      }),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter watermark rotation angle';
                      } else {
                        try {
                          double.parse(value);
                          // Here double parsing succeeds so returning that new value.
                          return null;
                        } catch (e) {
                          // Here double parsing failed so returning that old value.
                          return 'Please enter watermark rotation angle';
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: Theme.of(context).colorScheme.surfaceVariant,
              title: Text('Choose watermark color',
                  style: Theme.of(context).textTheme.bodyMedium),
              visualDensity: VisualDensity.compact,
              subtitle: Text(
                  '${ColorTools.materialNameAndCode(watermarkColor, colorSwatchNameMap: colorsNameMap)} '
                  'aka ${ColorTools.nameThatColor(watermarkColor)}',
                  style: Theme.of(context).textTheme.bodySmall),
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
                    });
              },
            ),
            const SizedBox(height: 10),
            const Text("Choose watermark layer:"),
            ToggleButtons(
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelectedForLayerTypes.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelectedForLayerTypes[buttonIndex] = true;
                    } else {
                      isSelectedForLayerTypes[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: isSelectedForLayerTypes,
              children: layerTypes,
            ),
            const SizedBox(height: 10),
            const Text("Choose watermark position:"),
            Flexible(
              child: SizedBox(
                width: 200,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisExtent: 50,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                  ),
                  itemCount: 9,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return WatermarkPositionButton(
                        positionText: "TL",
                        isPositionSelected:
                            positionType == PositionType.topLeft,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.topLeft;
                          });
                        },
                      );
                    } else if (index == 1) {
                      return WatermarkPositionButton(
                        positionText: "TC",
                        isPositionSelected:
                            positionType == PositionType.topCenter,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.topCenter;
                          });
                        },
                      );
                    } else if (index == 2) {
                      return WatermarkPositionButton(
                        positionText: "TR",
                        isPositionSelected:
                            positionType == PositionType.topRight,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.topRight;
                          });
                        },
                      );
                    } else if (index == 3) {
                      return WatermarkPositionButton(
                        positionText: "CL",
                        isPositionSelected:
                            positionType == PositionType.centerLeft,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.centerLeft;
                          });
                        },
                      );
                    } else if (index == 4) {
                      return WatermarkPositionButton(
                        positionText: "CC",
                        isPositionSelected: positionType == PositionType.center,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.center;
                          });
                        },
                      );
                    } else if (index == 5) {
                      return WatermarkPositionButton(
                        positionText: "CR",
                        isPositionSelected:
                            positionType == PositionType.centerRight,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.centerRight;
                          });
                        },
                      );
                    } else if (index == 6) {
                      return WatermarkPositionButton(
                        positionText: "BL",
                        isPositionSelected:
                            positionType == PositionType.bottomLeft,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.bottomLeft;
                          });
                        },
                      );
                    } else if (index == 7) {
                      return WatermarkPositionButton(
                        positionText: "BC",
                        isPositionSelected:
                            positionType == PositionType.bottomCenter,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.bottomCenter;
                          });
                        },
                      );
                    } else {
                      return WatermarkPositionButton(
                        positionText: "BR",
                        isPositionSelected:
                            positionType == PositionType.bottomRight,
                        onPositionChange: () {
                          setState(() {
                            positionType = PositionType.bottomRight;
                          });
                        },
                      );
                    }
                  },
                ),
              ),
            ),
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
                        if (_formKey.currentState!.validate()) {
                          watchToolsActionsStateProviderValue
                              .watermarkSelectedFile(
                            files: [widget.file],
                            text: textController.value.text,
                            fontSize:
                                double.parse(fontSizeController.value.text),
                            watermarkLayer: watermarkLayer,
                            opacity:
                                double.parse(textOpacityController.value.text),
                            rotationAngle: double.parse(
                                textRotationAngleController.value.text),
                            watermarkColor: watermarkColor,
                            positionType: positionType,
                          );
                          Navigator.pushNamed(
                            context,
                            route.resultPage,
                          );
                        }
                      },
                      child: const Text("Watermark PDF"),
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

class WatermarkPositionButton extends StatelessWidget {
  const WatermarkPositionButton(
      {Key? key,
      required this.positionText,
      this.onPositionChange,
      required this.isPositionSelected})
      : super(key: key);

  final String positionText;
  final void Function()? onPositionChange;
  final bool isPositionSelected;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: isPositionSelected
          ? OutlinedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            )
          : null,
      onPressed: onPositionChange,
      child: Text(positionText),
    );
  }
}
