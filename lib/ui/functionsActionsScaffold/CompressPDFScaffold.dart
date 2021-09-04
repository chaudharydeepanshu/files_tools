import 'package:file_picker/file_picker.dart';
import 'package:files_tools/ads/ad_state.dart';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';
import 'package:files_tools/widgets/annotatedRegion.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/basicFunctionalityFunctions/processSelectedDataFromUser.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultPdfScaffold.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/progressFakeDialogBox.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CompressPDFScaffold extends StatefulWidget {
  static const String routeName = '/compressPDFScaffold';

  const CompressPDFScaffold({Key? key, this.arguments}) : super(key: key);

  final CompressPDFScaffoldArguments? arguments;

  @override
  _CompressPDFScaffoldState createState() => _CompressPDFScaffoldState();
}

enum Qualities { low, medium, high }

class _CompressPDFScaffoldState extends State<CompressPDFScaffold>
    with TickerProviderStateMixin {
  @override
  void initState() {
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
      processingDialog(context); //shows the processing dialog

      PdfDocument? document;
      Future.delayed(const Duration(milliseconds: 500), () async {
        document = await processSelectedDataFromUser(
            pdfChangesDataMap: {
              'PDF File Name': '${widget.arguments!.pdfFile.name}',
              'PDF Compress Quality': _method.toString(),
            },
            processType: widget.arguments!.processType,
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
          } else {
            selectedDataProcessed = false;
            shouldWePopScaffold = true;
            final functionFailedSnackBar = SnackBar(
              content:
                  const Text('Sorry, we failed to compress this specific file'),
              action: SnackBarAction(
                label: 'Ok',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(functionFailedSnackBar);
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

  Future<bool> _directPop() async {
    return true;
  }

  Qualities? _method = Qualities.medium;

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
              Scaffold(
                appBar: ReusableSilverAppBar(
                  title: 'Specify Compression',
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            RadioListTile<Qualities>(
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: const Text('Less Compression'),
                              subtitle:
                                  const Text('High quality, less compression'),
                              value: Qualities.high,
                              groupValue: _method,
                              onChanged: (Qualities? value) {
                                setState(() {
                                  _method = value;
                                });
                              },
                            ),
                            RadioListTile<Qualities>(
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: const Text('Recommended Compression'),
                              subtitle:
                                  const Text('Good quality, good compression'),
                              value: Qualities.medium,
                              groupValue: _method,
                              onChanged: (Qualities? value) {
                                setState(() {
                                  _method = value;
                                });
                              },
                            ),
                            RadioListTile<Qualities>(
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: const Text('Extreme Compression'),
                              subtitle:
                                  const Text('less quality, High compression'),
                              value: Qualities.low,
                              groupValue: _method,
                              onChanged: (Qualities? value) {
                                setState(() {
                                  _method = value;
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
        ),
      ),
    );
  }
}

class CompressPDFScaffoldArguments {
  List? pdfPagesImages;
  PlatformFile pdfFile;
  String processType;
  Map<String, dynamic>? mapOfSubFunctionDetails;

  CompressPDFScaffoldArguments({
    this.pdfPagesImages,
    required this.pdfFile,
    required this.processType,
    this.mapOfSubFunctionDetails,
  });
}
