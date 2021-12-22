// import 'dart:ui';
import 'package:files_tools/ads/ad_state.dart';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/widgets/annotatedRegion.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/currentDateTimeInString.dart';
import 'package:files_tools/basicFunctionalityFunctions/getSizeFromBytes.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/basicFunctionalityFunctions/processSelectedDataFromUser.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultPdfScaffold.dart';
import 'package:files_tools/ui/pdfViewerScaffold/pdfScaffold.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/processingDialog.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as pdfRenderer;
import 'dart:io';

var uuid = Uuid();

class MergePDFPagesScaffold extends StatefulWidget {
  static const String routeName = '/mergePDFPagesScaffold';

  const MergePDFPagesScaffold({Key? key, this.arguments}) : super(key: key);

  final MergePDFPagesScaffoldArguments? arguments;

  @override
  _MergePDFPagesScaffoldState createState() => _MergePDFPagesScaffoldState();
}

class _MergePDFPagesScaffoldState extends State<MergePDFPagesScaffold>
    with TickerProviderStateMixin {
  late List<bool> selectedImages;

  List<Widget> filesListForReorderableListView = [];
  List<int> filesReorderRecorder = [];
  var myChildSize = Size.zero;

  var _openResult = 'Unknown';

  @override
  void initState() {
    super.initState();

    filesReorderRecorder =
        List<int>.generate(widget.arguments!.pdfFiles.length, (int index) {
      return index + 1;
    });

    filesListForReorderableListView =
        List<Widget>.generate(widget.arguments!.pdfFiles.length, (int index) {
      double defaultButtonElevation = 3;
      double onTapDownButtonElevation = 0;
      double buttonElevation = 3;
      var myChildSize = Size.zero;

      return StatefulBuilder(
          key: Key('${uuid.v1()}'),
          builder: (context, setState) {
            //key: Key('${uuid.v1()}'),
            return Padding(
              //key: Key('${uuid.v1()}'),
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: GestureDetector(
                        onTapDown: (TapDownDetails tapDownDetails) {
                          setState(() {
                            buttonElevation = onTapDownButtonElevation;
                          });
                        },
                        onTapUp: (TapUpDetails tapUpDetails) {
                          setState(() {
                            buttonElevation = defaultButtonElevation;
                          });
                        },
                        onTapCancel: () {
                          setState(() {
                            buttonElevation = defaultButtonElevation;
                          });
                        },
                        onPanEnd: (DragEndDetails dragEndDetails) {
                          setState(() {
                            buttonElevation = defaultButtonElevation;
                          });
                        },
                        child: Material(
                          elevation: buttonElevation,
                          color: widget.arguments!
                                  .mapOfSubFunctionDetails!['Button Color'] ??
                              Color(0xffE4EAF6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            onTap: () async {
                              final _result = await OpenFile.open(
                                  widget.arguments!.pdfFilesPaths[index]);
                              print(_result.message);

                              setState(() {
                                _openResult =
                                    "type=${_result.type}  message=${_result.message}";
                              });
                              if (_result.type == ResultType.noAppToOpen) {
                                print(_openResult);
                                //Using default app pdf viewer instead of suggesting downloading others
                                Navigator.pushNamed(
                                  context,
                                  PageRoutes.pdfScaffold,
                                  arguments: PDFScaffoldArguments(
                                    pdfPath:
                                        widget.arguments!.pdfFilesPaths[index],
                                  ),
                                );
                              }
                            },
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            focusColor:
                                widget.arguments!.mapOfSubFunctionDetails![
                                        'Button Effects Color'] ??
                                    Colors.black.withOpacity(0.1),
                            highlightColor:
                                widget.arguments!.mapOfSubFunctionDetails![
                                        'Button Effects Color'] ??
                                    Colors.black.withOpacity(0.1),
                            splashColor:
                                widget.arguments!.mapOfSubFunctionDetails![
                                        'Button Effects Color'] ??
                                    Colors.black.withOpacity(0.1),
                            hoverColor:
                                widget.arguments!.mapOfSubFunctionDetails![
                                        'Button Effects Color'] ??
                                    Colors.black.withOpacity(0.1),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      MeasureSize(
                                        onChange: (size) {
                                          setState(() {
                                            myChildSize = size;
                                            print(myChildSize);
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 20, bottom: 20),
                                          child: SvgPicture.asset(
                                              widget.arguments!
                                                          .mapOfSubFunctionDetails![
                                                      'File Icon Asset'] ??
                                                  'assets/images/tools_icons/pdf_tools_icon.svg',
                                              fit: BoxFit.fitHeight,
                                              height: 35,
                                              color: widget.arguments!
                                                          .mapOfSubFunctionDetails![
                                                      'File Icon Color'] ??
                                                  null,
                                              alignment: Alignment.center,
                                              semanticsLabel: 'File Icon'),
                                          // Image.asset(
                                          //   'assets/images/pdf_icon.png',
                                          //   fit: BoxFit.fitHeight,
                                          //   height: 35,
                                          // ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${widget.arguments!.pdfFilesNames[index]}",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: widget.arguments!
                                                            .mapOfSubFunctionDetails![
                                                        'Button Text Color'] ??
                                                    Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${formatBytes(widget.arguments!.pdfFilesSizes[index], 2)}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: widget.arguments!
                                                                .mapOfSubFunctionDetails![
                                                            'Button Text Color'] ??
                                                        Colors.black,
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
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    });
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
              'PDF File Name': "Merged Pdf ${currentDateTimeInString()}.pdf",
              'Files Reorder Recorder': filesReorderRecorder,
            },
            processType: "${widget.arguments!.processType}",
            filesPaths: widget.arguments!.pdfFilesPaths,
            shouldDataBeProcessed: shouldDataBeProcessed);

        Map map = Map();
        map['_pdfFileName'] = "Merged Pdf ${currentDateTimeInString()}.pdf";
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
                pdfFileName: "Merged Pdf ${currentDateTimeInString()}.pdf",
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

  var bannerAdSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    return ReusableAnnotatedRegion(
      //child: WillPopScope(
      // onWillPop: shouldWePopScaffold == true ? _directPop : _onWillPop, // no use as we handle onWillPop on dialog box it in processingDialog and we used it before here because we were using a fake dialog box which looks like a dialog box but actually just a lookalike created using stack
      child: Stack(
        children: [
          Scaffold(
            appBar: ReusableSilverAppBar(
              title: 'Reorder & Merge PDFs',
              titleColor: Colors.black,
              leftButtonColor: Colors.red,
              appBarIconLeft: appBarIconLeft,
              appBarIconLeftToolTip: appBarIconLeftToolTip,
              appBarIconLeftAction: appBarIconLeftAction,
              rightButtonColor: Colors.blue,
              appBarIconRight: appBarIconRight,
              appBarIconRightToolTip: appBarIconRightToolTip,
              appBarIconRightAction: appBarIconRightAction,
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
                              Text('Reorder PDFs:'),
                            ],
                          ),
                        ),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: filesListForReorderableListView,
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final Widget item = filesListForReorderableListView
                                .removeAt(oldIndex);
                            filesListForReorderableListView.insert(
                                newIndex, item);

                            final int item2 =
                                filesReorderRecorder.removeAt(oldIndex);
                            filesReorderRecorder.insert(newIndex, item2);
                          });
                        },
                      ),
                      Provider.of<AdState>(context).bannerAdUnitId != null
                          ? SizedBox(
                              height: bannerAdSize.height.toDouble(),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Column(
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
              ],
            ),
          ),
          // selectedDataProcessed == true ? progressFakeDialogBox : Container(),
        ],
      ),
      //),
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    Key? key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Checkbox(
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MergePDFPagesScaffoldArguments {
  List<List<pdfRenderer.PdfPageImage?>> listOfListPDFPagesImages;
  List<File> pdfFiles;
  List<String> pdfFilesPaths;
  List<String> pdfFilesNames;
  List<int> pdfFilesSizes;
  String processType;
  Map<String, dynamic>? mapOfSubFunctionDetails;

  MergePDFPagesScaffoldArguments({
    required this.listOfListPDFPagesImages,
    required this.pdfFiles,
    required this.pdfFilesPaths,
    required this.processType,
    required this.pdfFilesNames,
    required this.pdfFilesSizes,
    this.mapOfSubFunctionDetails,
  });
}
