import 'dart:typed_data';
import 'dart:ui';
import 'package:extended_image/extended_image.dart';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingImageFileUsingBytesTemporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingPDFRendererImageFileTemporarily.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultImageScaffold.dart';
import 'package:files_tools/widgets/annotatedRegion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/currentDateTimeInString.dart';
import 'package:files_tools/basicFunctionalityFunctions/processSelectedDataFromUser.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/bottomNavBarButtonsForFileModifications.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/card_carousel.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/progressFakeDialogBox.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/reorder_pages_scaffold.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultPdfScaffold.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

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
  _AspectRatioWidgetState createState() => _AspectRatioWidgetState();
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
//todo: dispose them as they could lead to memory leak
        final _formKey = GlobalKey<FormState>();
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
                    key: _formKey,
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
                          SizedBox(
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
                          if (_formKey.currentState!.validate()) {
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
        child: Container(
          height: 48,
          width: 90,
          child: Material(
            color: widget.isSelected == true ? Colors.blue : Colors.grey,
            shape: StadiumBorder(),
            child: InkWell(
              onTap: () {
                if (widget.aspectRatioS! != 'specific') {
                  widget.onTap.call(widget.aspectRatio);
                } else if (widget.aspectRatioS! == 'specific') {
                  specifyDialog(context).then((value) {
                    print('it run');
                    if (value != null) {
                      widget.onTap.call(value);
                    }
                  });
                }
              },
              customBorder: StadiumBorder(),
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
                    child: Icon(Icons.aspect_ratio),
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

// class AspectRatioWidget extends StatelessWidget {
//   const AspectRatioWidget(
//       {this.aspectRatioS, this.aspectRatio, this.isSelected = false});
//   final String? aspectRatioS;
//   final double? aspectRatio;
//   final bool isSelected;
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: const Size(100, 100),
//       painter: AspectRatioPainter(
//           aspectRatio: aspectRatio,
//           aspectRatioS: aspectRatioS,
//           isSelected: isSelected),
//     );
//   }
// }
//
// class AspectRatioPainter extends CustomPainter {
//   AspectRatioPainter(
//       {this.aspectRatioS, this.aspectRatio, this.isSelected = false});
//   final String? aspectRatioS;
//   final double? aspectRatio;
//   final bool isSelected;
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Color color = isSelected ? Colors.blue : Colors.grey;
//     final Rect rect = Offset.zero & size;
//     //https://github.com/flutter/flutter/issues/49328
//     final Paint paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;
//     final double aspectRatioResult =
//         (aspectRatio != null && aspectRatio! > 0.0) ? aspectRatio! : 1.0;
//     int gap = 3;
//     int smallMarkWidth = 20;
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             Rect.fromLTWH(
//               10,
//               15,
//               80,
//               33,
//             ),
//             Radius.circular(15.0)),
//         // getDestinationRect(
//         //     rect: const EdgeInsets.all(10.0).deflateRect(rect),
//         //     inputSize: Size(aspectRatioResult * 100, 100.0),
//         //     fit: BoxFit.fitWidth),
//         paint);
//
//     final TextPainter textPainter = TextPainter(
//         text: TextSpan(
//             text: aspectRatioS,
//             style: TextStyle(
//               color:
//                   color.computeLuminance() < 0.5 ? Colors.white : Colors.black,
//               fontSize: 16.0,
//             )),
//         textDirection: TextDirection.ltr,
//         maxLines: 1);
//     textPainter.layout(maxWidth: rect.width);
//
//     textPainter.paint(
//         canvas,
//         rect.center -
//             Offset(textPainter.width / 2.0, textPainter.height / 2.0));
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return oldDelegate is AspectRatioPainter &&
//         (oldDelegate.isSelected != isSelected ||
//             oldDelegate.aspectRatioS != aspectRatioS ||
//             oldDelegate.aspectRatio != aspectRatio);
//   }
// }

class ModifyImageScaffold extends StatefulWidget {
  static const String routeName = '/modifyImageScaffold';

  const ModifyImageScaffold({Key? key, this.arguments}) : super(key: key);

  final ModifyImageScaffoldArguments? arguments;

  @override
  _ModifyImageScaffoldState createState() => _ModifyImageScaffoldState();
}

class _ModifyImageScaffoldState extends State<ModifyImageScaffold> {
  late var tempImageFile;

  final GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>> popupMenuKey =
      GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>>();

  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  final List<AspectRatioItem> _aspectRatios = <AspectRatioItem>[
    AspectRatioItem(text: 'custom', value: CropAspectRatios.custom),
    AspectRatioItem(text: 'original', value: CropAspectRatios.original),
    AspectRatioItem(text: 'specific', value: CropAspectRatios.custom),
    AspectRatioItem(text: '1*1', value: CropAspectRatios.ratio1_1),
    AspectRatioItem(text: '4*3', value: CropAspectRatios.ratio4_3),
    AspectRatioItem(text: '3*4', value: CropAspectRatios.ratio3_4),
    AspectRatioItem(text: '16*9', value: CropAspectRatios.ratio16_9),
    AspectRatioItem(text: '9*16', value: CropAspectRatios.ratio9_16)
  ];

  AspectRatioItem? _aspectRatio;
  bool _cropping = false;

  EditorCropLayerPainter? _cropLayerPainter;

  @override
  void initState() {
    _aspectRatio = _aspectRatios.first;
    _cropLayerPainter = const EditorCropLayerPainter();
    tempImageFile = widget.arguments!.compressedFile;

    appBarIconLeft = Icons.arrow_back;
    appBarIconLeftToolTip = 'Back';
    appBarIconLeftAction = () {
      return Navigator.of(context).pop();
    };

    appBarIconRight = Icons.check;
    appBarIconRightToolTip = 'Done';
    appBarIconRightAction = () async {
      shouldWePopScaffold = false;
      shouldDataBeProcessed = true;
      setState(() {
        selectedDataProcessed = true;
      });
      processingDialog(context); //shows the processing dialog

      Uint8List? fileData;
      Future.delayed(const Duration(milliseconds: 500), () async {
        fileData = await processSelectedDataFromUser(
            pdfChangesDataMap: {
              'PDF File Name': "Image to pdf ${currentDateTimeInString()}.pdf",
              'State': editorKey.currentState!,
            },
            processType: widget.arguments!.processType,
            // filePath: widget.arguments!.filePath,
            filePath: widget.arguments!.compressedFilesPath,
            shouldDataBeProcessed: shouldDataBeProcessed);

        Map map = Map();
        map['_imageName'] = "Modified Image ${currentDateTimeInString()}.jpg";
        map['_extraBetweenNameAndExtension'] = '';
        map['_imageBytes'] = fileData;

        // final result = await compute(creatingAndSavingFileTemporarily, map);
        // return result;
        //todo: setup isolates to decrease the jitter in circular progress bar a little bit
        //todo: to do this first find the culprit and then find a solution if possible
        //the main delay is getting the processed document so try to optimise its loop using isolate

        return Future.delayed(const Duration(milliseconds: 500), () async {
          return fileData != null && shouldDataBeProcessed == true
              ? await creatingAndSavingImageFileUsingBytesTemporarily(map)
              : null;
        });
      }).then((value) {
        // //Get the document security.
        // PdfSecurity security = document!.security;
        //
        // //Get the permissions
        // PdfPermissions permissions = security.permissions;
        //
        // permissions.clear();
        // print('permissions : ${permissions.count}');

        Future.delayed(const Duration(milliseconds: 500), () async {
          if (fileData != null &&
              shouldDataBeProcessed == true &&
              value != null) {
            Navigator.pop(context); //closes the processing dialog
            Navigator.pushNamed(
              context,
              PageRoutes.resultImageScaffold,
              arguments: ResultImageScaffoldArguments(
                fileData: fileData!,
                filePath: value,
                pdfFileName: "Modified Image ${currentDateTimeInString()}.jpg",
                mapOfSubFunctionDetails:
                    widget.arguments!.mapOfSubFunctionDetails,
              ),
            );
          }
        }).whenComplete(() {
          setState(() {
            selectedDataProcessed = false;
            shouldWePopScaffold = true;
          });
        });
      });
    };
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late IconData appBarIconLeft;
  late String appBarIconLeftToolTip;
  late dynamic Function()? appBarIconLeftAction;

  late IconData appBarIconRight;
  late String appBarIconRightToolTip;
  late dynamic Function()? appBarIconRightAction;

  bool selectedDataProcessed = false;
  bool shouldDataBeProcessed = true;
  bool shouldWePopScaffold = true;

  Future<bool> _onWillPop() async {
    setState(() {
      shouldWePopScaffold = true;
      shouldDataBeProcessed = false;
      selectedDataProcessed = false;
    });
    return false;
  }

  Future<bool> _directPop() async {
    return true;
  }

  bool proceedButton() {
    return true;
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    print('modify_pdf image active');
    return ReusableAnnotatedRegion(
      child: WillPopScope(
        onWillPop: shouldWePopScaffold == true ? _directPop : _onWillPop,
        child: Stack(
          children: [
            Scaffold(
              appBar: ReusableSilverAppBar(
                title: 'Modify Image',
                titleColor: Colors.black,
                leftButtonColor: Colors.red,
                appBarIconLeft: appBarIconLeft,
                appBarIconLeftToolTip: appBarIconLeftToolTip,
                appBarIconLeftAction: appBarIconLeftAction,
                rightButtonColor: Colors.blue,
                appBarIconRight: appBarIconRight,
                appBarIconRightToolTip: appBarIconRightToolTip,
                appBarIconRightAction:
                    proceedButton() ? appBarIconRightAction : null,
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                      child: ExtendedImage.file(
                    tempImageFile,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.editor,
                    enableLoadState: true,
                    extendedImageEditorKey: editorKey,
                    initEditorConfigHandler: (ExtendedImageState? state) {
                      return EditorConfig(
                        maxScale: 8.0,
                        cropRectPadding: const EdgeInsets.all(20.0),
                        hitTestSize: 20.0,
                        cropLayerPainter: _cropLayerPainter!,
                        initCropRectType: InitCropRectType.imageRect,
                        cropAspectRatio: _aspectRatio!.value,
                      );
                    },
                    cacheRawData: true,
                  )),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      bottomNavBarButtonsForFileModifications(
                        buttonIcon: Icon(Icons.crop),
                        buttonLabel: Text('Crop'),
                        onTapAction: () {
                          showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 100,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.all(20.0),
                                        itemBuilder: (_, int index) {
                                          final AspectRatioItem item =
                                              _aspectRatios[index];
                                          return
                                              //GestureDetector(child:
                                              AspectRatioWidget(
                                            aspectRatio: item.value,
                                            aspectRatioS: item.text,
                                            isSelected: item == _aspectRatio,
                                            onTap: (value) {
                                              if (item.text != 'specific') {
                                                Navigator.pop(context);
                                                setState(() {
                                                  _aspectRatio = item;
                                                });
                                              } else if (item.text ==
                                                  'specific') {
                                                Navigator.pop(context);
                                                setState(() {
                                                  item.value = value;
                                                  _aspectRatio = item;
                                                });
                                              }
                                            },
                                          );
                                        },
                                        itemCount: _aspectRatios.length,
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        mapOfSubFunctionDetails:
                            widget.arguments!.mapOfSubFunctionDetails,
                      ),
                      bottomNavBarButtonsForFileModifications(
                        buttonIcon: Icon(Icons.flip),
                        buttonLabel: Text('Flip'),
                        onTapAction: () {
                          editorKey.currentState!.flip();
                        },
                        mapOfSubFunctionDetails:
                            widget.arguments!.mapOfSubFunctionDetails,
                      ),
                      bottomNavBarButtonsForFileModifications(
                        buttonIcon: Icon(Icons.rotate_left),
                        buttonLabel: Text('Rotate Left'),
                        onTapAction: () {
                          editorKey.currentState!.rotate(right: false);
                        },
                        mapOfSubFunctionDetails:
                            widget.arguments!.mapOfSubFunctionDetails,
                      ),
                      bottomNavBarButtonsForFileModifications(
                        buttonIcon: Icon(Icons.rotate_right),
                        buttonLabel: Text('Rotate Right'),
                        onTapAction: () {
                          editorKey.currentState!.rotate(right: true);
                        },
                        mapOfSubFunctionDetails:
                            widget.arguments!.mapOfSubFunctionDetails,
                      ),
                      bottomNavBarButtonsForFileModifications(
                        buttonIcon: Icon(Icons.rounded_corner_sharp),
                        buttonLabel: PopupMenuButton<EditorCropLayerPainter>(
                          key: popupMenuKey,
                          enabled: false,
                          offset: const Offset(100, -300),
                          child: const Text(
                            'Painter',
                            style: TextStyle(fontSize: 8.0),
                          ),
                          initialValue: _cropLayerPainter,
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuEntry<EditorCropLayerPainter>>[
                              PopupMenuItem<EditorCropLayerPainter>(
                                child: Row(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.rounded_corner_sharp,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Default'),
                                  ],
                                ),
                                value: const EditorCropLayerPainter(),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem<EditorCropLayerPainter>(
                                child: Row(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.circle,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Dot'),
                                  ],
                                ),
                                value: const CustomEditorCropLayerPainter(),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem<EditorCropLayerPainter>(
                                child: Row(
                                  children: const <Widget>[
                                    Icon(
                                      CupertinoIcons.circle,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Circle'),
                                  ],
                                ),
                                value: const CircleEditorCropLayerPainter(),
                              ),
                            ];
                          },
                          onSelected: (EditorCropLayerPainter value) {
                            if (_cropLayerPainter != value) {
                              setState(() {
                                if (value is CircleEditorCropLayerPainter) {
                                  _aspectRatio = _aspectRatios[2];
                                }
                                _cropLayerPainter = value;
                              });
                            }
                          },
                        ),
                        onTapAction: () {
                          popupMenuKey.currentState!.showButtonMenu();
                        },
                        mapOfSubFunctionDetails:
                            widget.arguments!.mapOfSubFunctionDetails,
                      ),
                      bottomNavBarButtonsForFileModifications(
                        buttonIcon: Icon(Icons.restore),
                        buttonLabel: Text('Reset'),
                        onTapAction: () {
                          editorKey.currentState!.reset();
                        },
                        mapOfSubFunctionDetails:
                            widget.arguments!.mapOfSubFunctionDetails,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //selectedDataProcessed == true ? progressFakeDialogBox : Container(),
          ],
        ),
      ),
    );
  }
}

class ModifyImageScaffoldArguments {
  //List imagesList;
  File file;
  File compressedFile;
  String filePath;
  String compressedFilesPath;
  String fileName;
  int fileSize;
  String processType;
  Map<String, dynamic> mapOfSubFunctionDetails;

  ModifyImageScaffoldArguments({
    //required this.imagesList,
    required this.file,
    required this.compressedFile,
    required this.filePath,
    required this.compressedFilesPath,
    required this.processType,
    required this.fileName,
    required this.fileSize,
    required this.mapOfSubFunctionDetails,
  });
}
