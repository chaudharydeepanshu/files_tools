import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingZipFileTemporarily.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/basicFunctionalityFunctions/processSelectedDataFromUser.dart';
import 'package:files_tools/ui/pdfFunctionsResultsScaffold/resultZipScaffold.dart';
import 'package:files_tools/widgets/pdfFunctionsActionWidgets/reusableUIActionWidgets/progressFakeDialogBox.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';

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
  late int pdfPagesCount;
  int numberOfPDFCreated = 0;
  @override
  void initState() {
    super.initState();
    listTextInputFormatter = [
      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    ];
    pdfPagesCount = widget.arguments!.pdfPagesImages!.length;
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
            filePath: widget.arguments!.pdfFile.path!,
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

  int? pdfsCreatedCalc() {
    int currentValue = 1; //int.parse(textEditingController.text);
    numberOfPDFCreated = pdfPagesCount ~/
        currentValue; //this will give us the int value of division

    //here we are checking if the double value of division is equal to the double value but with decimal digits set to 0
    //if this condition passes than we can say that this is a perfect division otherwise not
    //for more info check https://stackoverflow.com/a/58012722
    if ((pdfPagesCount / currentValue) ==
        (pdfPagesCount / currentValue).roundToDouble()) {
      return numberOfPDFCreated;
    } else {
      //if not perfect division then add 1 to the number of pdf created
      return ++numberOfPDFCreated;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: shouldWePopScaffold == true ? _directPop : _onWillPop,
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
                appBarIconRightAction:
                    appBarIconRightActionForSeparateDocuments,
              ),
              body: SingleChildScrollView(
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
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                              'Number of PDFs will be created: $pdfPagesCount',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            decoration: BoxDecoration(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // selectedDataProcessed == true ? progressFakeDialogBox : Container(),
          ],
        ),
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
