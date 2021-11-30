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
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/processingDialog.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CompressPDFScaffold extends StatefulWidget {
  static const String routeName = '/compressPDFScaffold';

  const CompressPDFScaffold({Key? key, this.arguments}) : super(key: key);

  final CompressPDFScaffoldArguments? arguments;

  @override
  _CompressPDFScaffoldState createState() => _CompressPDFScaffoldState();
}

enum Qualities { low, medium, high, custom }

class _CompressPDFScaffoldState extends State<CompressPDFScaffold>
    with TickerProviderStateMixin {
  List<TextInputFormatter>? listTextInputFormatter;

  @override
  void initState() {
    super.initState();

    listTextInputFormatter = [
      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      LengthLimitingTextInputFormatter(
          18), //as 9999...19 times throws following exception "Positive input exceeds the limit of integer 9999999999999999999"
    ];

    customQualityTextEditingController.text = 88.toString();

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
              'PDF File Name': '${widget.arguments!.pdfFile.name}',
              'PDF Compress Quality': _method.toString(),
              'Quality Custom Value': _method == Qualities.custom
                  ? int.parse(customQualityTextEditingController.text)
                  : 0,
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

  Qualities? _method = Qualities.medium;

  var bannerAdSize = Size.zero;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController customQualityTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  title: 'Specify Compression',
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
                      : appBarIconRightAction,
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
                            RadioListTile<Qualities>(
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: Row(
                                children: [
                                  const Text('Custom Compression'),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      onTap: () {
                                        setState(() {
                                          _method = Qualities.custom;
                                        });
                                      },
                                      controller:
                                          customQualityTextEditingController,
                                      inputFormatters: listTextInputFormatter,
                                      decoration: const InputDecoration(
                                        hintText: '88',
                                        labelText: 'Quality % *',
                                        helperText: ' ',
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      onSaved: (String? value) {
                                        // This optional block of code can be used to run
                                        // code when the user saves the form.
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (String? value) {
                                        return (_method == Qualities.custom &&
                                                (value == null ||
                                                    value.isEmpty))
                                            ? 'Can\'t be Empty'
                                            : (_method == Qualities.custom &&
                                                    (int.parse(value!) < 1 ||
                                                        int.parse(value) > 100))
                                                ? 'Enter from 1 - 100'
                                                : null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              subtitle:
                                  const Text('Enter quality from 1 to 100'),
                              value: Qualities.custom,
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
            ),
            // selectedDataProcessed == true ? progressFakeDialogBox : Container(),
          ],
        ),
        // ),
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
