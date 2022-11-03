import 'dart:developer';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';

class CustomEditorCropLayerPainter extends EditorCropLayerPainter {
  const CustomEditorCropLayerPainter();
  @override
  void paintCorners(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    final Paint paint = Paint()
      ..color = painter.cornerColor
      ..style = PaintingStyle.fill;
    final Rect cropRect = painter.cropRect;
    const double radius = 6;
    canvas.drawCircle(Offset(cropRect.left, cropRect.top), radius, paint);
    canvas.drawCircle(Offset(cropRect.right, cropRect.top), radius, paint);
    canvas.drawCircle(Offset(cropRect.left, cropRect.bottom), radius, paint);
    canvas.drawCircle(Offset(cropRect.right, cropRect.bottom), radius, paint);
  }
}

class CircleEditorCropLayerPainter extends EditorCropLayerPainter {
  const CircleEditorCropLayerPainter();

  @override
  void paintCorners(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    // do nothing
  }

  @override
  void paintMask(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    final Rect rect = Offset.zero & size;
    final Rect cropRect = painter.cropRect;
    final Color maskColor = painter.maskColor;
    canvas.saveLayer(rect, Paint());
    canvas.drawRect(
        rect,
        Paint()
          ..style = PaintingStyle.fill
          ..color = maskColor);
    canvas.drawCircle(cropRect.center, cropRect.width / 2.0,
        Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  void paintLines(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    final Rect cropRect = painter.cropRect;
    if (painter.pointerDown) {
      canvas.save();
      canvas.clipPath(Path()..addOval(cropRect));
      super.paintLines(canvas, size, painter);
      canvas.restore();
    }
  }
}

class AspectRatioItem {
  AspectRatioItem({this.value, this.text});
  String? text;
  double? value;
}

class AspectRatioWidget extends StatefulWidget {
  const AspectRatioWidget(
      {Key? key,
      this.aspectRatioS,
      this.aspectRatio,
      this.isSelected,
      required this.onTap})
      : super(key: key);

  final String? aspectRatioS;
  final double? aspectRatio;
  final bool? isSelected;
  final ValueChanged onTap;

  @override
  State<AspectRatioWidget> createState() => _AspectRatioWidgetState();
}

class _AspectRatioWidgetState extends State<AspectRatioWidget> {
  Future<double?> specifyDialog(BuildContext context) async {
    double? aspectRatio;
    await showDialog<bool>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        TextEditingController xAxisTextEditingController =
            TextEditingController();
        TextEditingController yAxisTextEditingController =
            TextEditingController();

        final formKey = GlobalKey<FormState>();
        return StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SimpleDialog(
                title: const Text(
                  'Specify Aspect Ratio Values',
                  textAlign: TextAlign.center,
                ),
                children: [
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: xAxisTextEditingController,
                              decoration: const InputDecoration(
                                hintText: '2',
                                labelText: 'x unit *',
                                helperText: ' ',
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (String? value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                              },
                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
                              validator: (String? value) {
                                return (value == null || value.isEmpty)
                                    ? 'x unit can\'t be Empty'
                                    : (int.parse(value) >=
                                            int.parse(yAxisTextEditingController
                                                .text))
                                        ? 'x can\'t be >= to x'
                                        : null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: yAxisTextEditingController,
                              decoration: const InputDecoration(
                                hintText: '3',
                                labelText: 'y unit *',
                                helperText: ' ',
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (String? value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                              },
                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
                              validator: (String? value) {
                                return (value == null || value.isEmpty)
                                    ? 'y unit can\'t be Empty'
                                    : null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            aspectRatio =
                                int.parse(xAxisTextEditingController.text) /
                                    int.parse(yAxisTextEditingController.text);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    return aspectRatio;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          height: 48,
          width: 90,
          child: Material(
            color: widget.isSelected == true ? Colors.blue : Colors.grey,
            shape: const StadiumBorder(),
            child: InkWell(
              onTap: () {
                if (widget.aspectRatioS! != 'specific') {
                  widget.onTap.call(widget.aspectRatio);
                } else if (widget.aspectRatioS! == 'specific') {
                  specifyDialog(context).then((value) {
                    debugPrint('it run');
                    if (value != null) {
                      widget.onTap.call(value);
                    }
                  });
                }
              },
              customBorder: const StadiumBorder(),
              focusColor: Colors.black.withOpacity(0.1),
              highlightColor: Colors.black.withOpacity(0.1),
              splashColor: Colors.black.withOpacity(0.1),
              hoverColor: Colors.black.withOpacity(0.1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconTheme(
                    data: IconThemeData(
                      color: widget.isSelected == true
                          ? Colors.white
                          : Colors.black,
                      size: 24,
                    ),
                    child: const Icon(Icons.aspect_ratio),
                  ),
                  ClipRect(
                    child: SizedBox(
                      //height: 20,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: widget.isSelected == true
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                        child: Text(widget.aspectRatioS!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final List<AspectRatioItem> aspectRatios = <AspectRatioItem>[
  AspectRatioItem(text: 'custom', value: CropAspectRatios.custom),
  AspectRatioItem(text: 'original', value: CropAspectRatios.original),
  AspectRatioItem(text: 'specific', value: CropAspectRatios.custom),
  AspectRatioItem(text: '1*1', value: CropAspectRatios.ratio1_1),
  AspectRatioItem(text: '4*3', value: CropAspectRatios.ratio4_3),
  AspectRatioItem(text: '3*4', value: CropAspectRatios.ratio3_4),
  AspectRatioItem(text: '16*9', value: CropAspectRatios.ratio16_9),
  AspectRatioItem(text: '9*16', value: CropAspectRatios.ratio9_16)
];

Future<Uint8List?> modifyImage(ExtendedImageEditorState currentState) async {
  Future<Uint8List?> cropImageDataWithNativeLibrary(
      {required ExtendedImageEditorState state}) async {
    log('Native library start cropping');

    final Rect? cropRect = state.getCropRect();
    final EditActionDetails action = state.editAction!;

    final int rotateAngle = action.rotateAngle.toInt();
    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    final Uint8List img = state.rawImageData;

    final ImageEditorOption option = ImageEditorOption();

    if (action.needCrop) {
      option.addOption(ClipOption.fromRect(cropRect!));
    }

    if (action.needFlip) {
      option.addOption(
          FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    }

    if (action.hasRotateAngle) {
      option.addOption(RotateOption(rotateAngle));
    }

    // if (extensionOfFileName.toLowerCase() == '.jpg' ||
    //     extensionOfFileName.toLowerCase() == '.jpeg') {
    //   option.outputFormat = const OutputFormat.jpeg(100);
    // } else if (extensionOfFileName.toLowerCase() == '.png') {
    //   option.outputFormat = const OutputFormat.png(100);
    // }

    final DateTime start = DateTime.now();
    final Uint8List? result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    log('${DateTime.now().difference(start)} ：total time');
    return result;
  }

  Uint8List? fileData =
      await cropImageDataWithNativeLibrary(state: currentState);

  return fileData;
}
