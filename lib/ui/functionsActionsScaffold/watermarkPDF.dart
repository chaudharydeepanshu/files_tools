import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:files_tools/ads/ad_state.dart';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultPdfScaffold.dart';
import 'package:files_tools/widgets/annotatedRegion.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/basicFunctionalityFunctions/processSelectedDataFromUser.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/processingDialog.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as pdfRenderer;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class WatermarkPDFPagesScaffold extends StatefulWidget {
  static const String routeName = '/watermarkPDFPagesScaffold';

  const WatermarkPDFPagesScaffold({Key? key, this.arguments}) : super(key: key);

  final WatermarkPDFPagesScaffoldArguments? arguments;

  @override
  _WatermarkPDFPagesScaffoldState createState() =>
      _WatermarkPDFPagesScaffoldState();
}

class _WatermarkPDFPagesScaffoldState extends State<WatermarkPDFPagesScaffold>
    with TickerProviderStateMixin {
  late List<bool> selectedImages;
  List<TextInputFormatter>? fontSizeTextInputFormatter;
  List<TextInputFormatter>? transparencyTextInputFormatter;
  List<TextInputFormatter>? rotationAngleTextInputFormatter;
  TextEditingController watermarkTextEditingController =
      TextEditingController(text: 'Watermark');
  TextEditingController fontSizeTextEditingController =
      TextEditingController(text: '40');
  TextEditingController transparencyTextEditingController =
      TextEditingController(text: '0.50');
  TextEditingController rotationAngleTextEditingController =
      TextEditingController(text: '-40');
  int? pdfPagesCount;
  int numberOfPDFCreated = 0;
  Future<void> pdfsPageCount() async {
    String? filePath = widget.arguments!.pdfFile.path;
    final newDocument = await pdfRenderer.PdfDocument.openFile(filePath!);
    pdfPagesCount = newDocument.pagesCount;
    newDocument.close();
  }

  // Color for the picker in a dialog using onChanged.
  late Color dialogPickerColor;

  @override
  void initState() {
    super.initState();
    dialogPickerColor = Colors.red; // Material red.

    fontSizeTextInputFormatter = [
      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      LengthLimitingTextInputFormatter(
          18), //as 9999...19 times throws following exception "Positive input exceeds the limit of integer 9999999999999999999"
    ];
    transparencyTextInputFormatter = [
      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
      LengthLimitingTextInputFormatter(
          18), //as 9999...19 times throws following exception "Positive input exceeds the limit of integer 9999999999999999999"
    ];
    rotationAngleTextInputFormatter = [
      FilteringTextInputFormatter.allow(RegExp('[0-9.-]')),
      LengthLimitingTextInputFormatter(
          18), //as 9999...19 times throws following exception "Positive input exceeds the limit of integer 9999999999999999999"
    ];

    pdfsPageCount().whenComplete(() {
      setState(() {});
      return null;
    });

    watermarkTextEditingController.addListener(() {
      setState(() {});
    });
    fontSizeTextEditingController.addListener(() {
      setState(() {});
    });
    // [
    //   FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 \"‘\'‘,-]')),
    // ];
    // print(
    //     "test: ${_controller.text.substring(_controller.text.length - 1)}");
    // if()
    // listTextInputFormatter = [
    //   FilteringTextInputFormatter.allow(RegExp('[0-9,-]')),
    // ];
    super.initState();

    appBarIconLeft = Icons.arrow_back;
    appBarIconLeftToolTip = 'Back';
    appBarIconLeftAction = () {
      return Navigator.of(context).pop();
    };

    appBarIconRight = Icons.check;
    appBarIconRightToolTip = 'Done';
    appBarIconRightAction = () async {
      FocusManager.instance.primaryFocus?.unfocus();
      shouldWePopScaffold = false;
      shouldDataBeProcessed = true;
      setState(() {
        selectedDataProcessed = true;
      });
      processingDialog(
        context,
        (bool value) {
          setState(() {
            shouldDataBeProcessed = value;
          });
          _onWillPop();
        },
      ); //shows the processing dialog

      PdfDocument? document;
      Future.delayed(const Duration(milliseconds: 500), () async {
        document = await processSelectedDataFromUser(
            pdfChangesDataMap: {
              'Watermark TextEditingController':
                  watermarkTextEditingController.text,
              'FontSize TextEditingController':
                  double.parse(fontSizeTextEditingController.text),
              //'Number Of PDFs': numberOfPDFCreated,
              'List Of Watermark Layer Buttons Status':
                  listOfWatermarkLayerButtonsStatus,
              'List Of Positions Status': listOfPositionsStatus,
              'Color Of Watermark':
                  "0x${ColorTools.colorCode(dialogPickerColor)}",
              'Watermark Transparency':
                  double.parse(transparencyTextEditingController.text),
              'Watermark Rotation Angle':
                  double.parse(rotationAngleTextEditingController.text),
              'PDF File Name': '${widget.arguments!.pdfFile.name}'
            },
            processType: "${widget.arguments!.processType}",
            filePath: widget.arguments!.pdfFile.path,
            shouldDataBeProcessed: shouldDataBeProcessed);

        Map map = Map();
        map['_pdfFileName'] = '${widget.arguments!.pdfFile.name}';
        map['_extraBetweenNameAndExtension'] = '';
        map['_document'] = document;

        // final result = await compute(creatingAndSavingFileTemporarily, map);
        // return result;
        //todo: setup isolates to decrease the jitter in circular progress bar a little bit
        //todo: to do this first find the culprit and then find a solution if possible
        //the main delay is getting the processed document so try to optimise its loop using isolate

        return Future.delayed(const Duration(milliseconds: 500), () async {
          return document != null && shouldDataBeProcessed == true
              ? await creatingAndSavingPDFFileTemporarily(map)
              : null;
        });
      }).then((value) {
        Future.delayed(const Duration(milliseconds: 500), () async {
          if (document != null &&
              shouldDataBeProcessed == true &&
              value != null) {
            Navigator.pop(context); //closes the processing dialog
            Navigator.pushNamed(
              context,
              PageRoutes.resultPDFScaffold,
              arguments: ResultPDFScaffoldArguments(
                document: document!,
                pdfFilePath: value,
                pdfFileName: 'Watermarked ${widget.arguments!.pdfFile.name}',
                mapOfSubFunctionDetails:
                    widget.arguments!.mapOfSubFunctionDetails,
              ),
            );
          }
        }).whenComplete(() {
          // setState(() {
          selectedDataProcessed = false;
          shouldWePopScaffold = true;
          // });
        });
      });
    };
  }

  @override
  void dispose() {
    // textEditingController.dispose();
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

  List<bool> listOfWatermarkLayerButtonsStatus = [true, false];

  var bannerAdSize = Size.zero;

  // Define custom colors. The 'guide' color values are from
  // https://material.io/design/color/the-color-system.html#color-theme-creation
  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  // Make a custom ColorSwatch to name map from the above custom colors.
  final Map<ColorSwatch<Object>, String> colorsNameMap =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      // Use the dialogPickerColor as start color.
      color: dialogPickerColor,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) =>
          setState(() => dialogPickerColor = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      colorCodeTextStyle: Theme.of(context).textTheme.caption,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

  List<bool> listOfPositionsStatus = List<bool>.generate(9, (int index) {
    return index == 4 ? true : false;
  });

  ScrollController scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("0x${ColorTools.colorCode(dialogPickerColor)}");
    return ReusableAnnotatedRegion(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        //child: WillPopScope(
        // onWillPop: shouldWePopScaffold == true ? _directPop : _onWillPop, // no use as we handle onWillPop on dialog box it in processingDialog and we used it before here because we were using a fake dialog box which looks like a dialog box but actually just a lookalike created using stack
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Scaffold(
                  appBar: ReusableSilverAppBar(
                    title: 'Watermark PDF Pages',
                    titleColor: Colors.black,
                    leftButtonColor: Colors.red,
                    appBarIconLeft: appBarIconLeft,
                    appBarIconLeftToolTip: appBarIconLeftToolTip,
                    appBarIconLeftAction: appBarIconLeftAction,
                    rightButtonColor: Colors.blue,
                    appBarIconRight: appBarIconRight,
                    appBarIconRightToolTip: appBarIconRightToolTip,
                    appBarIconRightAction: _formKey.currentState != null
                        ? _formKey.currentState!.validate()
                            ? appBarIconRightAction
                            : null
                        : null,
                  ),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Note: ',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      Expanded(
                                        child: Text(
                                            'For best results try to keep watermark text short and font size below 100.'),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text('Watermark Text:'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller: watermarkTextEditingController,
                                    //keyboardType: TextInputType.number,
                                    //inputFormatters: listTextInputFormatter,
                                    onChanged: (String value) {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Enter your watermark',
                                      helperText: ' ',
                                      hintText: 'Ex: Your Name',
                                      border: OutlineInputBorder(),
                                    ),
                                    //autofocus: true,
                                    showCursor: true,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Empty Field';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text('Font size:'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller: fontSizeTextEditingController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: fontSizeTextInputFormatter,
                                    onChanged: (String value) {
                                      setState(() {
                                        if (value.isNotEmpty) {
                                          if (int.parse(
                                                  value.substring(0, 1)) ==
                                              0) {
                                            String newValue =
                                                value.substring(0, 0) +
                                                    '' +
                                                    value.substring(0 + 1);
                                            fontSizeTextEditingController
                                                .value = TextEditingValue(
                                              text: newValue,
                                              selection:
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: newValue.length),
                                              ),
                                            );
                                          }
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Enter watermark font size',
                                      helperText: ' ',
                                      hintText: 'Ex: 40',
                                      border: OutlineInputBorder(),
                                    ),
                                    //autofocus: true,
                                    showCursor: true,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Empty Field';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text('Position of watermark:'),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    child: GridView.count(
                                      controller: scrollController,
                                      shrinkWrap: true,
                                      crossAxisCount: 3,
                                      children: List.generate(
                                          9, //this is the total number of cards
                                          (index) {
                                        return Container(
                                          margin: EdgeInsets.all(5),
                                          child: Material(
                                            //elevation: 6,
                                            color: listOfPositionsStatus[index]
                                                ? Colors.lightBlue
                                                : null,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color!,
                                                  width: 2),
                                            ),
                                            child: InkWell(
                                              customBorder:
                                                  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                side: BorderSide(
                                                    color: Colors.lightBlue,
                                                    width: 2),
                                              ),
                                              focusColor:
                                                  Colors.black.withOpacity(0.1),
                                              highlightColor:
                                                  Colors.black.withOpacity(0.1),
                                              splashColor:
                                                  Colors.black.withOpacity(0.1),
                                              hoverColor:
                                                  Colors.black.withOpacity(0.1),
                                              onTap: () {
                                                if (listOfPositionsStatus[
                                                        index] ==
                                                    false) {
                                                  List<bool> tempList =
                                                      List<bool>.generate(9,
                                                          (int tempIndex) {
                                                    return tempIndex == index
                                                        ? true
                                                        : false;
                                                  });
                                                  setState(() {
                                                    listOfPositionsStatus =
                                                        tempList;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              Row(
                                children: [
                                  Text('Color:'),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              ListTile(
                                title:
                                    const Text('Click the color to change it'),
                                subtitle: Text(
                                  '${ColorTools.materialNameAndCode(dialogPickerColor, colorSwatchNameMap: colorsNameMap)} '
                                  'aka ${ColorTools.nameThatColor(dialogPickerColor)}',
                                ),
                                trailing: ColorIndicator(
                                  width: 44,
                                  height: 44,
                                  borderRadius: 4,
                                  color: dialogPickerColor,
                                  onSelectFocus: false,
                                  onSelect: () async {
                                    // Store current color before we open the dialog.
                                    final Color colorBeforeDialog =
                                        dialogPickerColor;
                                    // Wait for the picker to close, if dialog was dismissed,
                                    // then restore the color we had before it was opened.
                                    if (!(await colorPickerDialog())) {
                                      setState(() {
                                        dialogPickerColor = colorBeforeDialog;
                                      });
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              Row(
                                children: [
                                  Text('Layer:'),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    WatermarkLayerButtons(
                                      buttonAsset:
                                          'assets/images/functions_internal_icons/over_the_content_watermark_icon.svg',
                                      buttonText: 'Over the PDF content',
                                      buttonStatus:
                                          listOfWatermarkLayerButtonsStatus[0],
                                      onButtonStatus: (bool value) {
                                        setState(() {
                                          listOfWatermarkLayerButtonsStatus[0] =
                                              value;
                                          listOfWatermarkLayerButtonsStatus[1] =
                                              !value;
                                        });
                                      },
                                    ),
                                    WatermarkLayerButtons(
                                      buttonAsset:
                                          'assets/images/functions_internal_icons/below_the_content_watermark_icon.svg',
                                      buttonText: 'Below the PDF content',
                                      buttonStatus:
                                          listOfWatermarkLayerButtonsStatus[1],
                                      onButtonStatus: (bool value) {
                                        setState(() {
                                          listOfWatermarkLayerButtonsStatus[1] =
                                              value;
                                          listOfWatermarkLayerButtonsStatus[0] =
                                              !value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              Row(
                                children: [
                                  Text('Set transparency:'),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: transparencyTextEditingController,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: transparencyTextInputFormatter,
                                onChanged: (String value) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  labelText: 'Enter transparency',
                                  helperText: ' ',
                                  hintText: 'Ex: 0.50',
                                  border: OutlineInputBorder(),
                                ),
                                //autofocus: true,
                                showCursor: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Empty Field';
                                  } else if (double.tryParse(value) == null) {
                                    return 'Please enter a value less than 1';
                                  } else if (double.parse(value) > 1) {
                                    return 'Please enter a value less than 1';
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                children: [
                                  Text('Set rotation angle:'),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: rotationAngleTextEditingController,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters:
                                    rotationAngleTextInputFormatter,
                                onChanged: (String value) {
                                  setState(() {
                                    if (value.isNotEmpty) {
                                      if (double.tryParse(
                                              value.substring(0, 1)) !=
                                          null) {
                                        // if (double.parse(value.substring(0, 1)) ==
                                        //     0) {
                                        //   String newValue =
                                        //       value.substring(0, 0) +
                                        //           '' +
                                        //           value.substring(0 + 1);
                                        //   rotationAngleTextEditingController
                                        //       .value = TextEditingValue(
                                        //     text: newValue,
                                        //     selection: TextSelection.fromPosition(
                                        //       TextPosition(
                                        //           offset: newValue.length),
                                        //     ),
                                        //   );
                                        // }
                                      }
                                      if (value.length > 1) {
                                        if (value.substring(value.length - 1) ==
                                            '-') {
                                          String newValue = value.substring(
                                              0, value.length - 1);
                                          rotationAngleTextEditingController
                                              .value = TextEditingValue(
                                            text: newValue,
                                            selection:
                                                TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: newValue.length),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Enter rotation angle',
                                  helperText: ' ',
                                  hintText: 'Ex: -40',
                                  border: OutlineInputBorder(),
                                ),
                                //autofocus: true,
                                showCursor: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Empty Field';
                                  } else if (double.tryParse(value) == null) {
                                    return 'Please enter a valid value between -360 to 360';
                                  } else if (double.parse(value) < -360 ||
                                      double.parse(value) > 360) {
                                    return 'Please enter a valid value between -360 to 360';
                                  }
                                  return null;
                                },
                              ),
                              Provider.of<AdState>(context).bannerAdUnitId !=
                                      null
                                  ? SizedBox(
                                      height: bannerAdSize.height.toDouble(),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Material(
                type: MaterialType.transparency,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MeasureSize(
                      onChange: (Size size) {
                        setState(() {
                          bannerAdSize = size;
                        });
                      },
                      child: BannerAD(),
                    ),
                  ],
                ),
              ),
              // selectedDataProcessed == true ? progressFakeDialogBox : Container(),
            ],
          ),
       // ),
      ),
    );
  }
}

class WatermarkPDFPagesScaffoldArguments {
  List? pdfPagesImages;
  PlatformFile pdfFile;
  String processType;
  Map<String, dynamic>? mapOfSubFunctionDetails;

  WatermarkPDFPagesScaffoldArguments(
      {this.pdfPagesImages,
      required this.pdfFile,
      required this.processType,
      this.mapOfSubFunctionDetails});
}

class WatermarkLayerButtons extends StatefulWidget {
  const WatermarkLayerButtons(
      {Key? key,
      required this.buttonText,
      required this.buttonAsset,
      required this.buttonStatus,
      required this.onButtonStatus})
      : super(key: key);

  final String buttonText;
  final String buttonAsset;
  final bool buttonStatus;
  final ValueChanged<bool> onButtonStatus;

  @override
  _WatermarkLayerButtonsState createState() => _WatermarkLayerButtonsState();
}

class _WatermarkLayerButtonsState extends State<WatermarkLayerButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        //height: 150,
        width: 250,
        child: Material(
          //elevation: 6,
          color: widget.buttonStatus == true ? Colors.lightBlue : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            side: BorderSide(
                color: widget.buttonStatus == true
                    ? Colors.lightBlue
                    : Theme.of(context).iconTheme.color!,
                width: 2),
          ),
          child: InkWell(
            onTap: () {
              if (widget.buttonStatus == false) {
                widget.onButtonStatus.call(true);
              } else {
                //widget.onButtonStatus.call(false);
              }
            },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              side: BorderSide(color: Colors.lightBlue, width: 2),
            ),
            focusColor: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.1),
            splashColor: Colors.black.withOpacity(0.1),
            hoverColor: Colors.black.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(widget.buttonAsset,
                      fit: BoxFit.fitHeight,
                      height: 25,
                      color: Theme.of(context).iconTheme.color,
                      alignment: Alignment.center,
                      semanticsLabel: 'No Asset Function Icon'),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.buttonText,
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
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
