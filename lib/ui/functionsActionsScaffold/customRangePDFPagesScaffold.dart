import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:files_tools/ads/ad_state.dart';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';
import 'package:files_tools/widgets/annotatedRegion.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingZipFileTemporarily.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/basicFunctionalityFunctions/processSelectedDataFromUser.dart';
import 'package:files_tools/widgets/functionsActionWidgets/pdfCustomRangesWidgets/customRangesWidget.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultPdfScaffold.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultZipScaffold.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/processingDialog.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

var uuid = Uuid();

class CustomRangePDFPagesScaffold extends StatefulWidget {
  static const String routeName = '/customRangePDFPagesScaffold';

  const CustomRangePDFPagesScaffold({Key? key, this.arguments})
      : super(key: key);

  final CustomRangePDFPagesScaffoldArguments? arguments;

  @override
  _CustomRangePDFPagesScaffoldState createState() =>
      _CustomRangePDFPagesScaffoldState();
}

class _CustomRangePDFPagesScaffoldState
    extends State<CustomRangePDFPagesScaffold> with TickerProviderStateMixin {
  late List<bool> selectedImages;
  List<List<TextEditingController>> listTextEditingControllerPairs = [];
  List<List<bool>> listOfQuartetsOfButtonsOfRanges = [];
  List<TextInputFormatter>? listTextInputFormatter;

  List<Widget> ranges = [];
  List<int> rangesReorderRecorder = [];
  List<int> rangeCountWithoutDeletion = [];

  @override
  void initState() {
    super.initState();
    selectedImages =
        List.filled(widget.arguments!.pdfPagesImages!.length, false);
    listTextInputFormatter = [
      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    ];

    ranges = [
      RangeWidget(
        listOfQuartetsOfButtonsOfRanges: listOfQuartetsOfButtonsOfRanges,
        listTextEditingControllerPairs: listTextEditingControllerPairs,
        index: 0,
        pdfPageCount: widget.arguments!.pdfPagesImages!.length,
        // key: Key('0'),
        key: Key('${uuid.v1()}'),
        onListOfQuartetsOfButtonsOfRanges: (List<List<bool>> value) {
          setState(() {
            listOfQuartetsOfButtonsOfRanges = value;
          });
        },
        onListTextEditingControllerPairs:
            (List<List<TextEditingController>> value) {
          setState(() {
            listTextEditingControllerPairs = value;
          });
        },
        onDeleteRange: (int value) {
          int? rangeToDelete;
          for (int i = 0; i < rangesReorderRecorder.length; i++) {
            if (value == rangesReorderRecorder[i]) {
              rangeToDelete = i;
              print(i);
            }
          }
          setState(() {
            print('rangeToDelete: $rangeToDelete');
            print('value: $value');
            ranges.removeAt(rangeToDelete!);
            rangesReorderRecorder.removeAt(rangeToDelete);
            setStateLimiterForAddPostFrameCallback = ranges.length - 1;
          });
        },
        rangeNumber: rangeCountWithoutDeletion.length,
        color: widget.arguments!.mapOfSubFunctionDetails!['Main Color'],
      )
    ];
    rangesReorderRecorder = [1];
    rangeCountWithoutDeletion = [1];

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
    appBarIconRightActionForSingleDocument = () async {
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
        },
      ); //shows the processing dialog
      print("${widget.arguments!.processType + " As Single Document"}");

      PdfDocument? document;
      Future.delayed(const Duration(milliseconds: 500), () async {
        document = await processSelectedDataFromUser(
            pdfChangesDataMap: {
              '_isSeparateDocumentsEnabled': _isSeparateDocumentsEnabled,
              'listTextEditingControllerPairs': listTextEditingControllerPairs,
              'listOfQuartetsOfButtonsOfRanges':
                  listOfQuartetsOfButtonsOfRanges,
              'Reordered Range List': rangesReorderRecorder,
              'PDF File Name': '${widget.arguments!.pdfFile.name}'
            },
            processType:
                "${widget.arguments!.processType + " As Single Document"}",
            filePath: widget.arguments!.pdfFile.path,
            shouldDataBeProcessed: shouldDataBeProcessed);

        Map map = Map();
        map['_pdfFileName'] = widget.arguments!.pdfFile.name;
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
                pdfFileName: widget.arguments!.pdfFile.name,
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

    appBarIconRightActionForSeparateDocuments = () async {
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

      List<String>? rangesPdfsFilePaths;
      Future.delayed(const Duration(milliseconds: 500), () async {
        rangesPdfsFilePaths = await processSelectedDataFromUser(
            pdfChangesDataMap: {
              '_isSeparateDocumentsEnabled': _isSeparateDocumentsEnabled,
              'listTextEditingControllerPairs': listTextEditingControllerPairs,
              'listOfQuartetsOfButtonsOfRanges':
                  listOfQuartetsOfButtonsOfRanges,
              'Reordered Range List': rangesReorderRecorder,
              'PDF File Name': '${widget.arguments!.pdfFile.name}'
            },
            processType:
                "${widget.arguments!.processType + " As Separate Documents"}",
            filePath: widget.arguments!.pdfFile.path,
            shouldDataBeProcessed: shouldDataBeProcessed);

        Map map = Map();
        map['_pdfFileName'] = widget.arguments!.pdfFile.name;
        map['_extraBetweenNameAndExtension'] = '';
        map['_rangesPdfsFilePaths'] = rangesPdfsFilePaths;

        // final result = await compute(creatingAndSavingFileTemporarily, map);
        // return result;
        //todo: setup isolates to decrease the jitter in circular progress bar a little bit
        //todo: to do this first find the culprit and then find a solution if possible
        //the main delay is getting the processed document so try to optimise its loop using isolate

        return Future.delayed(const Duration(milliseconds: 500), () async {
          return rangesPdfsFilePaths != null && shouldDataBeProcessed == true
              ? await creatingAndSavingZipFileTemporarily(map)
              : null;
        });
      }).then((value) {
        Future.delayed(const Duration(milliseconds: 500), () async {
          if (rangesPdfsFilePaths != null &&
              shouldDataBeProcessed == true &&
              value != null) {
            Navigator.pop(context); //closes the processing dialog
            Navigator.pushNamed(
              context,
              PageRoutes.resultZipScaffold,
              arguments: ResultZipScaffoldArguments(
                rangesPdfsFilePaths: rangesPdfsFilePaths!,
                rangesPdfsZipFilePath: value,
                pdfFile: widget.arguments!.pdfFile,
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
    for (int i = 0; i < listTextEditingControllerPairs.length; i++) {
      listTextEditingControllerPairs[i][0].dispose();
      listTextEditingControllerPairs[i][1].dispose();
    }
    super.dispose();
  }

  late IconData appBarIconLeft;
  late String appBarIconLeftToolTip;
  late dynamic Function()? appBarIconLeftAction;

  late IconData appBarIconRight;
  late String appBarIconRightToolTip;
  late dynamic Function()? appBarIconRightActionForSingleDocument;
  late dynamic Function()? appBarIconRightActionForSeparateDocuments;

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

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  Future<void> informationDialog() async {
    await showDialog<bool>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Center(
            child: const Text('Information'),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(
                          text:
                              'Use this option to specify individual pages and page ranges that should be added to the output document.'),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "• ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(),
                                        text:
                                            'Enter pages separated by commas, ex: 1, 4-8, 10, 22-24',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "• ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(),
                                        text:
                                            'To specify a reverse page order swap first/last pages, e.g: 5-1',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "• ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(),
                                        text:
                                            'To specify only even pages from a range enter: 1-5E',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "• ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(),
                                        text:
                                            'To specify only odd pages from a range enter: 1-5D',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "• ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(),
                                        text:
                                            'To specify a set of pages that contain a specific word or phrase, enter your search text in double or single quotes: \"Your Search Text Here\"',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isSeparateDocumentsEnabled = false;

  bool firstRun = true;
  int setStateLimiterForAddPostFrameCallback = 1;

  var bannerAdSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    if (!firstRun && setStateLimiterForAddPostFrameCallback < ranges.length) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {});
        setStateLimiterForAddPostFrameCallback++;
        return null;
      }); //addPostFrameCallback is important here to provide latest value of _formKey.currentState!.validate() as field widgets are formed after validation in appbar(appBarIconRightAction) so what we do is run build again through setState when build from setState of add range completes. With this the appbar has latest value of _formKey.currentState!.validate(). We also use setStateLimiterForAddPostFrameCallback to limit the stop continuous setState after _formKey.currentState!.validate() value is updated.
    }
    if (firstRun) {
      firstRun = false;
    }
    _isSeparateDocumentsEnabled =
        ranges.length < 2 ? false : _isSeparateDocumentsEnabled;
    print(
        "listTextEditingControllerPairs: ${listTextEditingControllerPairs.length}");
    print('rangesReorderRecorder: $rangesReorderRecorder');
    print('rangeCountWithoutDeletion: $rangeCountWithoutDeletion');
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
                    title: 'Specify Page Ranges',
                    titleColor: Colors.black,
                    leftButtonColor: Colors.red,
                    appBarIconLeft: appBarIconLeft,
                    appBarIconLeftToolTip: appBarIconLeftToolTip,
                    appBarIconLeftAction: appBarIconLeftAction,
                    rightButtonColor: Colors.blue,
                    appBarIconRight: appBarIconRight,
                    appBarIconRightToolTip: appBarIconRightToolTip,
                    appBarIconRightAction: ranges.length != 0
                        ? _formKey.currentState != null
                            ? _formKey.currentState!.validate()
                                ? _isSeparateDocumentsEnabled
                                    ? appBarIconRightActionForSeparateDocuments
                                    : appBarIconRightActionForSingleDocument
                                : null
                            : null
                        : null,
                  ),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            ReorderableListView(
                              header: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text('Add Pages and Ranges: '),
                                  ],
                                ),
                              ),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              children: ranges,
                              onReorder: (int oldIndex, int newIndex) {
                                setState(() {
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }
                                  final Widget item = ranges.removeAt(oldIndex);
                                  ranges.insert(newIndex, item);

                                  final int item2 =
                                      rangesReorderRecorder.removeAt(oldIndex);
                                  rangesReorderRecorder.insert(newIndex, item2);
                                });
                              },
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            OutlinedButton(
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                String temp = "${uuid.v1()}";
                                setState(() {
                                  ranges.add(RangeWidget(
                                    listOfQuartetsOfButtonsOfRanges:
                                        listOfQuartetsOfButtonsOfRanges,
                                    listTextEditingControllerPairs:
                                        listTextEditingControllerPairs,
                                    index: ranges.length,
                                    pdfPageCount: widget
                                        .arguments!.pdfPagesImages!.length,
                                    // key: Key('${ranges.length}'),
                                    key: Key('$temp'),
                                    onListOfQuartetsOfButtonsOfRanges:
                                        (List<List<bool>> value) {
                                      setState(() {
                                        listOfQuartetsOfButtonsOfRanges = value;
                                      });
                                    },
                                    onListTextEditingControllerPairs:
                                        (List<List<TextEditingController>>
                                            value) {
                                      setState(() {
                                        listTextEditingControllerPairs = value;
                                      });
                                    },
                                    onDeleteRange: (int value) {
                                      int? rangeToDelete;
                                      for (int i = 0;
                                          i < rangesReorderRecorder.length;
                                          i++) {
                                        if (value == rangesReorderRecorder[i]) {
                                          rangeToDelete = i;
                                          print(i);
                                        }
                                      }
                                      setState(() {
                                        print('rangeToDelete: $rangeToDelete');
                                        print('value: $value');
                                        ranges.removeAt(rangeToDelete!);
                                        rangesReorderRecorder
                                            .removeAt(rangeToDelete);
                                        setStateLimiterForAddPostFrameCallback =
                                            ranges.length - 1;
                                      });
                                    },
                                    rangeNumber:
                                        rangeCountWithoutDeletion.length,
                                    color: widget.arguments!
                                                .mapOfSubFunctionDetails![
                                            'Main Color'] ??
                                        Colors.lightBlue,
                                  ));
                                });
                                rangesReorderRecorder
                                    .add(rangeCountWithoutDeletion.length + 1);
                                rangeCountWithoutDeletion
                                    .add(rangeCountWithoutDeletion.length + 1);
                              },
                              child: Text('+ Add Range'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CheckboxListTile(
                              title: const Text(
                                  'Create separate documents for each page range'),
                              value: _isSeparateDocumentsEnabled,
                              onChanged: ranges.length < 2
                                  ? null
                                  : (bool? newValue) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      setState(() {
                                        _isSeparateDocumentsEnabled = newValue!;
                                        print(
                                            "_isSeparateDocumentsEnabled: $_isSeparateDocumentsEnabled");
                                      });
                                    },
                            ),
                            Platform.isAndroid
                                ? Provider.of<AdState>(context)
                                            .bannerAdUnitId !=
                                        null
                                    ? SizedBox(
                                        height: bannerAdSize.height.toDouble(),
                                      )
                                    : Container()
                                : Container(),
                          ],
                        ),
                      ),
                      Platform.isAndroid
                          ? Column(
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
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              // selectedDataProcessed == true ? progressFakeDialogBox : Container(),
            ],
          ),
        //),
      ),
    );
  }
}

class CustomRangePDFPagesScaffoldArguments {
  List? pdfPagesImages;
  PlatformFile pdfFile;
  String processType;
  Map<String, dynamic>? mapOfSubFunctionDetails;

  CustomRangePDFPagesScaffoldArguments(
      {this.pdfPagesImages,
      required this.pdfFile,
      required this.processType,
      this.mapOfSubFunctionDetails});
}
