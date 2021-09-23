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
import 'package:files_tools/ui/functionsResultsScaffold/resultZipScaffold.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/progressFakeDialogBox.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as pdfRenderer;
import 'package:provider/provider.dart';

class PDFToImagesScaffold extends StatefulWidget {
  static const String routeName = '/pdfToImagesScaffold';

  const PDFToImagesScaffold({Key? key, this.arguments}) : super(key: key);

  final PDFToImagesScaffoldArguments? arguments;

  @override
  _PDFToImagesScaffoldState createState() => _PDFToImagesScaffoldState();
}

class _PDFToImagesScaffoldState extends State<PDFToImagesScaffold>
    with TickerProviderStateMixin {
  late List<bool> selectedImages;
  List<TextInputFormatter>? listTextInputFormatter;
  // TextEditingController textEditingController = TextEditingController();
  int pdfPagesCount = 0;
  int numberOfPDFCreated = 0;
  Future<void> pdfsPageCount() async {
    String? filePath = widget.arguments!.pdfFile.path;
    final newDocument = await pdfRenderer.PdfDocument.openFile(filePath!);
    pdfPagesCount = newDocument.pagesCount;
    newDocument.close();
  }

  @override
  void initState() {
    super.initState();
    pdfsPageCount().whenComplete(() {
      setState(() {});
      return null;
    });

    listTextInputFormatter = [
      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    ];
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
      processingDialog(context); //shows the processing dialog

      List<String>? rangesPdfsFilePaths;
      Future.delayed(const Duration(milliseconds: 500), () async {
        rangesPdfsFilePaths = await processSelectedDataFromUser(
            pdfChangesDataMap: {
              //'TextEditingController': textEditingController,
              //'Number Of PDFs': numberOfPDFCreated,
              'PDF File Name': '${widget.arguments!.pdfFile.name}'
            },
            processType: "${widget.arguments!.processType}",
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

  Future<bool> _directPop() async {
    return true;
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

  var bannerAdSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    return ReusableAnnotatedRegion(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: WillPopScope(
          onWillPop: shouldWePopScaffold == true ? _directPop : _onWillPop,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Scaffold(
                  appBar: ReusableSilverAppBar(
                    title: 'Convert To Images',
                    titleColor: Colors.black,
                    leftButtonColor: Colors.red,
                    appBarIconLeft: appBarIconLeft,
                    appBarIconLeftToolTip: appBarIconLeftToolTip,
                    appBarIconLeftAction: appBarIconLeftAction,
                    rightButtonColor: Colors.blue,
                    appBarIconRight: appBarIconRight,
                    appBarIconRightToolTip: appBarIconRightToolTip,
                    appBarIconRightAction:
                        appBarIconRightActionForSeparateDocuments,
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
                                  Container(
                                    child: Text(
                                      'Total number of Pages in PDF: $pdfPagesCount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    decoration: BoxDecoration(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Text(
                                      'Number of Images will be created: $pdfPagesCount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    decoration: BoxDecoration(),
                                  ),
                                ],
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
              ),
              // selectedDataProcessed == true ? progressFakeDialogBox : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class PDFToImagesScaffoldArguments {
  List? pdfPagesImages;
  PlatformFile pdfFile;
  String processType;
  Map<String, dynamic>? mapOfSubFunctionDetails;

  PDFToImagesScaffoldArguments({
    this.pdfPagesImages,
    required this.pdfFile,
    required this.processType,
    this.mapOfSubFunctionDetails,
  });
}
