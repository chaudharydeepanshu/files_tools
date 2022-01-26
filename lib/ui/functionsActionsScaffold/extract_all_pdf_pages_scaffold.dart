// import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:files_tools/ads/ad_state.dart';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/basicFunctionalityFunctions/size_calculator.dart';
import 'package:files_tools/widgets/annotated_region.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:files_tools/basicFunctionalityFunctions/creating_and_saving_zip_file_temporarily.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/basicFunctionalityFunctions/process_selected_data_from_user.dart';
import 'package:files_tools/ui/functionsResultsScaffold/result_zip_scaffold.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/processing_dialog.dart';
import 'package:files_tools/widgets/reusableUIWidgets/reusable_top_appbar.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as pdf_renderer;
import 'package:provider/provider.dart';

class ExtractAllPDFPagesScaffold extends StatefulWidget {
  static const String routeName = '/extractAllPDFPagesScaffold';

  const ExtractAllPDFPagesScaffold({Key? key, this.arguments})
      : super(key: key);

  final ExtractAllPDFPagesScaffoldArguments? arguments;

  @override
  _ExtractAllPDFPagesScaffoldState createState() =>
      _ExtractAllPDFPagesScaffoldState();
}

class _ExtractAllPDFPagesScaffoldState extends State<ExtractAllPDFPagesScaffold>
    with TickerProviderStateMixin {
  late List<bool> selectedImages;
  List<TextInputFormatter>? listTextInputFormatter;
  // TextEditingController textEditingController = TextEditingController();
  int? pdfPagesCount;
  int numberOfPDFCreated = 0;
  Future<void> pdfsPageCount() async {
    String? filePath = widget.arguments!.pdfFile.path;
    final newDocument = await pdf_renderer.PdfDocument.openFile(filePath!);
    pdfPagesCount = newDocument.pagesCount;
    newDocument.close();
  }

  @override
  void initState() {
    super.initState();
    listTextInputFormatter = [
      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    ];

    pdfsPageCount().whenComplete(() {
      setState(() {});
      return null;
    });

    // textEditingController.addListener(() {
    //   setState(() {});
    // });
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
              //'TextEditingController': textEditingController,
              //'Number Of PDFs': numberOfPDFCreated,
              'PDF File Name': widget.arguments!.pdfFile.name
            },
            processType: widget.arguments!.processType,
            filePath: widget.arguments!.pdfFile.path,
            shouldDataBeProcessed: shouldDataBeProcessed);

        Map map = {};
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
    // textEditingController.dispose();
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

  var bannerAdSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    return ReusableAnnotatedRegion(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        //child: WillPopScope(
        // onWillPop: shouldWePopScaffold == true ? _directPop : _onWillPop, // no use as we handle onWillPop on dialog box it in processingDialog and we used it before here because we were using a fake dialog box which looks like a dialog box but actually just a lookalike created using stack
        child: Stack(
          children: [
            Scaffold(
              appBar: ReusableSilverAppBar(
                title: 'Extract All Pages',
                titleColor: Colors.black,
                leftButtonColor: Colors.red,
                appBarIconLeft: appBarIconLeft,
                appBarIconLeftToolTip: appBarIconLeftToolTip,
                appBarIconLeftAction: appBarIconLeftAction,
                rightButtonColor: Colors.blue,
                appBarIconRight: appBarIconRight,
                appBarIconRightToolTip: appBarIconRightToolTip,
                appBarIconRightAction: pdfPagesCount != null
                    ? pdfPagesCount! >= 2
                        ? appBarIconRightActionForSeparateDocuments
                        : null
                    : null,
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  child: pdfPagesCount != null
                                      ? Text(
                                          'Total number of Pages in PDF: $pdfPagesCount',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        )
                                      : Container(),
                                  decoration: const BoxDecoration(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          pdfPagesCount != null
                              ? pdfPagesCount! >= 2
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: pdfPagesCount != null
                                                ? Text(
                                                    'Number of PDFs will be created: $pdfPagesCount',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  )
                                                : Container(),
                                            decoration: const BoxDecoration(),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: pdfPagesCount != null
                                                ? const Text(
                                                    'Can\'t proceed further as pdf pages are less than 2',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                    textAlign: TextAlign.center,
                                                  )
                                                : Container(),
                                            decoration: const BoxDecoration(),
                                          ),
                                        ),
                                      ],
                                    )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: pdfPagesCount != null
                                            ? const Text(
                                                'Can\'t proceed further as pdf pages are less than 2',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                                textAlign: TextAlign.center,
                                              )
                                            : Container(),
                                        decoration: const BoxDecoration(),
                                      ),
                                    ),
                                  ],
                                ),
                          Provider.of<AdState>(context).bannerAdUnitId != null
                              ? SizedBox(
                                  height: bannerAdSize.height.toDouble(),
                                )
                              : Container(),
                        ],
                      ),
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
                        child: const BannerAD(),
                      ),
                    ],
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

class ExtractAllPDFPagesScaffoldArguments {
  List? pdfPagesImages;
  PlatformFile pdfFile;
  String processType;
  Map<String, dynamic>? mapOfSubFunctionDetails;

  ExtractAllPDFPagesScaffoldArguments(
      {this.pdfPagesImages,
      required this.pdfFile,
      required this.processType,
      this.mapOfSubFunctionDetails});
}
