// import 'package:flutter/material.dart';
// import 'package:files_tools/widgets/topLevelPagesWidgets/ReusableTopAppBar.dart';
//
// class PDFPagesSelectionScaffold extends StatefulWidget {
//   static const String routeName = '/pdfPagesSelectionScaffold';
//
//   const PDFPagesSelectionScaffold({Key key, this.arguments}) : super(key: key);
//
//   final PDFPagesSelectionScaffoldArguments arguments;
//
//   @override
//   _PDFPagesSelectionScaffoldState createState() =>
//       _PDFPagesSelectionScaffoldState();
// }
//
// class _PDFPagesSelectionScaffoldState extends State<PDFPagesSelectionScaffold> {
//   //List<bool> selectedImages = [];
//   List<bool> selectedImages;
//   @override
//   void initState() {
//     super.initState();
//     selectedImages = List.filled(widget.arguments.pdfPagesImages.length, false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: ReusableSilverAppBar(
//         title: 'Reorder',
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 8.0),
//         child: GridView.count(
//           childAspectRatio: 0.8,
//           crossAxisCount: 2,
//           children: List.generate(
//             widget.arguments.pdfPagesImages.length ?? 0,
//             (index) {
//               final item = widget.arguments.pdfPagesImages[index];
//               //selectedImages.insert(index, false);
//               return Column(
//                 children: <Widget>[
//                   Expanded(
//                     child: Material(
//                       color: selectedImages[index] == true
//                           ? Colors.lightBlue
//                           : Colors.transparent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: InkWell(
//                         onTap: () {
//                           setState(() {
//                             selectedImages[index] = !selectedImages[index];
//                           });
//                         },
//                         customBorder: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         focusColor: Colors.black.withOpacity(0.1),
//                         highlightColor: Colors.black.withOpacity(0.1),
//                         splashColor: Colors.black.withOpacity(0.1),
//                         hoverColor: Colors.black.withOpacity(0.1),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: selectedImages[index] == true
//                                   ? Colors.lightBlue
//                                   : Colors.black,
//                             ),
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(10),
//                               topRight: Radius.circular(10),
//                               bottomLeft: Radius.circular(10),
//                               bottomRight: Radius.circular(10),
//                             ),
//                           ),
//                           child: ConstrainedBox(
//                             constraints: BoxConstraints(
//                               maxHeight: 234,
//                               maxWidth: 165,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(10.0),
//                                   topRight: Radius.circular(10.0),
//                                   bottomLeft: Radius.circular(10.0),
//                                   bottomRight: Radius.circular(10.0),
//                                 ),
//                                 child: Image(
//                                     image: MemoryImage(item.bytes),
//                                     height: 234,
//                                     width: 165,
//                                     fit: BoxFit.fitWidth),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Text('${index + 1}'),
//                   SizedBox(
//                     height: 5,
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class PDFPagesSelectionScaffoldArguments {
//   List pdfPagesImages;
//
//   PDFPagesSelectionScaffoldArguments({this.pdfPagesImages});
// }

import 'package:file_picker/file_picker.dart';
import 'package:files_tools/ads/ad_state.dart';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';
import 'package:files_tools/widgets/annotatedRegion.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/basicFunctionalityFunctions/processSelectedDataFromUser.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultPdfScaffold.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/processingDialog.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';

class PDFPagesSelectionScaffold extends StatefulWidget {
  static const String routeName = '/pdfPagesSelectionScaffold';

  const PDFPagesSelectionScaffold({Key? key, this.arguments}) : super(key: key);

  final PDFPagesSelectionScaffoldArguments? arguments;

  @override
  _PDFPagesSelectionScaffoldState createState() =>
      _PDFPagesSelectionScaffoldState();
}

class _PDFPagesSelectionScaffoldState extends State<PDFPagesSelectionScaffold>
    with TickerProviderStateMixin {
  //late AnimationController controller;
  late List<bool> selectedImages;

  @override
  void initState() {
    super.initState();
    selectedImages =
        List.filled(widget.arguments!.pdfPagesImages!.length, false);

    // controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 5),
    // )..addListener(() {
    //     setState(() {});
    //   });
    // controller.repeat(reverse: true);
    super.initState();

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
              'PDF File Name': '${widget.arguments!.pdfFile.name}'
            },
            selectedData: selectedImages,
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
        // //Get the document security.
        // PdfSecurity security = document!.security;
        //
        // //Get the permissions
        // PdfPermissions permissions = security.permissions;
        //
        // permissions.clear();
        // print('permissions : ${permissions.count}');

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
                //pdfPagesSelectedImages: selectedImages,
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
  }

  @override
  void dispose() {
    // controller.dispose();
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

  bool proceedButton() {
    bool ifEveryFalse = selectedImages.every((element) {
      return (element == false);
    });

    bool ifEveryTrue = selectedImages.every((element) {
      return (element == true);
    });

    if (ifEveryFalse == true || ifEveryTrue == true) {
      return false;
    } else {
      return true;
    }
  }

  var bannerAdSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    print('setState Ran');
    print(bannerAdSize.height);
    return ReusableAnnotatedRegion(
      //child: WillPopScope(
      // onWillPop: shouldWePopScaffold == true ? _directPop : _onWillPop, // no use as we handle onWillPop on dialog box it in processingDialog and we used it before here because we were using a fake dialog box which looks like a dialog box but actually just a lookalike created using stack
      child: Stack(
        children: [
          Scaffold(
            appBar: ReusableSilverAppBar(
              title: 'Select Pages',
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
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.69, //childAspectRatio: 3 / 4.5,
                          ),
                          children: List.generate(
                            widget.arguments!.pdfPagesImages!.length,
                            (index) {
                              final item =
                                  widget.arguments!.pdfPagesImages![index];
                              return Column(
                                children: <Widget>[
                                  Container(
                                    height: 270,
                                    width: 165,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: selectedImages[index] == true
                                            ? 2
                                            : 1,
                                        color: selectedImages[index] == true
                                            ? widget.arguments!
                                                        .mapOfSubFunctionDetails![
                                                    'Main Color'] ??
                                                Colors.blue
                                            : Colors.black,
                                      ),
                                    ),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: 234,
                                        maxWidth: 165,
                                      ),
                                      child: ClipRRect(
                                        child: Container(
                                          height: 234,
                                          width: 165,
                                          decoration: BoxDecoration(
                                            color: selectedImages[index] == true
                                                ? widget.arguments!
                                                            .mapOfSubFunctionDetails![
                                                        'Button Color'] ??
                                                    Colors.lightBlue[100]
                                                : Colors.transparent,
                                            image: DecorationImage(
                                                image: MemoryImage(item.bytes),
                                                fit: BoxFit.scaleDown),
                                          ),
                                          child: Stack(
                                            children: [
                                              selectedImages[index] == true
                                                  ? Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Icon(
                                                        Icons.check_circle,
                                                        color: widget.arguments!
                                                                    .mapOfSubFunctionDetails![
                                                                'Main Color'] ??
                                                            Colors.blueAccent,
                                                      ),
                                                    )
                                                  : Container(),
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedImages[index] =
                                                          !selectedImages[
                                                              index];
                                                    });
                                                  },
                                                  focusColor: widget.arguments!
                                                              .mapOfSubFunctionDetails![
                                                          'Button Effects Color'] ??
                                                      Colors.black
                                                          .withOpacity(0.1),
                                                  highlightColor: widget
                                                              .arguments!
                                                              .mapOfSubFunctionDetails![
                                                          'Button Effects Color'] ??
                                                      Colors.black
                                                          .withOpacity(0.1),
                                                  splashColor: widget.arguments!
                                                              .mapOfSubFunctionDetails![
                                                          'Button Effects Color'] ??
                                                      Colors.black
                                                          .withOpacity(0.1),
                                                  hoverColor: widget.arguments!
                                                              .mapOfSubFunctionDetails![
                                                          'Button Effects Color'] ??
                                                      Colors.black
                                                          .withOpacity(0.1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text('${index + 1}'),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
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
          //selectedDataProcessed == true ? progressFakeDialogBox : Container(),
        ],
      ),
      //),
    );
  }
}

class PDFPagesSelectionScaffoldArguments {
  List? pdfPagesImages;
  PlatformFile pdfFile;
  String processType;
  Map<String, dynamic>? mapOfSubFunctionDetails;

  PDFPagesSelectionScaffoldArguments(
      {this.pdfPagesImages,
      required this.pdfFile,
      required this.processType,
      this.mapOfSubFunctionDetails});
}
