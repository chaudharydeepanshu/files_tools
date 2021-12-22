// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';
// import 'darg_drop_gridview/devdrag.dart';
//
// class ReorderPDFPagesScaffold extends StatefulWidget {
//   static const String routeName = '/reorderPDFPagesScaffold';
//
//   const ReorderPDFPagesScaffold({Key? key, this.arguments}) : super(key: key);
//
//   final ReorderPDFPagesScaffoldArguments? arguments;
//
//   @override
//   _ReorderPDFPagesScaffoldState createState() =>
//       _ReorderPDFPagesScaffoldState();
// }
//
// class _ReorderPDFPagesScaffoldState extends State<ReorderPDFPagesScaffold>
//     with TickerProviderStateMixin {
//   //late AnimationController controller;
//   late List<bool> selectedImages;
//   late List tmpImagesList;
//   late List<RotatedBox> tmp2ImagesList;
//   late List<int> tmpReorderedList;
//   late List<int> tmpListOfRotationOfImages;
//   late List<bool> tmpListOfDeletedImagesRecord;
//   late List<double> tmpControllerValueList;
//
//   int? pos;
//   @override
//   void initState() {
//     tmpImagesList = [...?widget.arguments!.pdfPagesImages];
//     tmp2ImagesList = [...?widget.arguments!.decorationImageListForReorder];
//
//     tmpListOfRotationOfImages =
//         List.from(widget.arguments!.listOfRotationOfImages!);
//     tmpListOfDeletedImagesRecord =
//         List.from(widget.arguments!.listOfDeletedImagesRecord!);
//
//     tmpReorderedList = List.from(widget.arguments!.reorderedList!);
//
//     tmpControllerValueList = List.from(widget.arguments!.controllerValueList!);
//
//     selectedImages =
//         List.filled(widget.arguments!.pdfPagesImages!.length, false);
//
//     // controller = AnimationController(
//     //   vsync: this,
//     //   duration: const Duration(seconds: 5),
//     // )..addListener(() {
//     //     setState(() {});
//     //   });
//     // controller.repeat(reverse: true);
//
//     appBarIconLeft = Icons.arrow_back;
//     appBarIconLeftToolTip = 'Back';
//     appBarIconLeftAction = () {
//       return Navigator.of(context).pop();
//     };
//
//     appBarIconRight = Icons.check;
//     appBarIconRightToolTip = 'Done';
//     appBarIconRightAction = () async {
//       widget.arguments!.onPDFPagesImages?.call(tmpImagesList);
//       widget.arguments!.onListOfRotationOfImages
//           ?.call(tmpListOfRotationOfImages);
//       widget.arguments!.onListOfDeletedImagesRecord
//           ?.call(tmpListOfDeletedImagesRecord);
//       widget.arguments!.onDecorationImageListForReorder?.call(tmp2ImagesList);
//       widget.arguments!.onReorderedList?.call(tmpReorderedList);
//       widget.arguments!.onControllerValueList?.call(tmpControllerValueList);
//       return Navigator.of(context).pop();
//       // shouldWePopScaffold = false;
//       // shouldDataBeProcessed = true;
//       // setState(() {
//       //   selectedDataProcessed = true;
//       // });
//       //
//       // PdfDocument? document;
//       // Future.delayed(const Duration(milliseconds: 500), () async {
//       //   document = await processSelectedDataFromUser(
//       //       selectedData: selectedImages,
//       //       processType: 'Remove PDF Data',
//       //       filePath: widget.arguments!.pdfFile.path!,
//       //       shouldDataBeProcessed: shouldDataBeProcessed);
//       //
//       //   Map map = Map();
//       //   map['_pdfFileName'] = widget.arguments!.pdfFile.name;
//       //   map['_document'] = document;
//       //
//       //   // final result = await compute(creatingAndSavingFileTemporarily, map);
//       //   // return result;
//       //   //todo: setup isolates to decrease the jitter in circular progress bar a little bit
//       //   //todo: to do this first find the culprit and then find a solution if possible
//       //   //the main delay is getting the processed document so try to optimise its loop using isolate
//       //
//       //   return Future.delayed(const Duration(milliseconds: 500), () async {
//       //     return document != null
//       //         ? await creatingAndSavingFileTemporarily(map)
//       //         : null;
//       //   });
//       // }).then((value) {
//       //   // //Get the document security.
//       //   // PdfSecurity security = document!.security;
//       //   //
//       //   // //Get the permissions
//       //   // PdfPermissions permissions = security.permissions;
//       //   //
//       //   // permissions.clear();
//       //   // print('permissions : ${permissions.count}');
//       //
//       //   Future.delayed(const Duration(milliseconds: 500), () async {
//       //     if (document != null && shouldDataBeProcessed == true) {
//       //       Navigator.pushNamed(
//       //         context,
//       //         PageRoutes.resultPDFScaffold,
//       //         arguments: ResultPDFScaffoldArguments(
//       //           document: document!,
//       //           pdfPagesSelectedImages: selectedImages,
//       //           pdfFilePath: value!,
//       //           pdfFile: widget.arguments!.pdfFile,
//       //         ),
//       //       );
//       //     }
//       //   }).whenComplete(() {
//       //     // setState(() {
//       //     selectedDataProcessed = false;
//       //     shouldWePopScaffold = true;
//       //     // });
//       //   });
//       // });
//     };
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // controller.dispose();
//     super.dispose();
//   }
//
//   late IconData appBarIconLeft;
//   late String appBarIconLeftToolTip;
//   late dynamic Function()? appBarIconLeftAction;
//
//   late IconData appBarIconRight;
//   late String appBarIconRightToolTip;
//   late dynamic Function()? appBarIconRightAction;
//
//   bool selectedDataProcessed = false;
//   bool shouldDataBeProcessed = true;
//   bool shouldWePopScaffold = true;
//
//   Future<bool> _onWillPop() async {
//     setState(() {
//       shouldWePopScaffold = true;
//       shouldDataBeProcessed = false;
//       selectedDataProcessed = false;
//     });
//     return false;
//   }
//
//   Future<bool> _directPop() async {
//     return true;
//   }
//
//   bool proceedButton() {
//     // bool ifEveryFalse = selectedImages.every((element) {
//     //   return (element == false);
//     // });
//     //
//     // bool ifEveryTrue = selectedImages.every((element) {
//     //   return (element == true);
//     // });
//     //
//     // if (ifEveryFalse == true || ifEveryTrue == true) {
//     //   return false;
//     // } else {
//     //   return true;
//     // }
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('tmpListOfDeletedImagesRecord: $tmpListOfDeletedImagesRecord');
//     print('reorderedList: $tmpReorderedList');
//     print('setState Ran');
//     return WillPopScope(
//       onWillPop: shouldWePopScaffold == true ? _directPop : _onWillPop,
//       child: Stack(
//         children: [
//           Scaffold(
//             appBar: ReusableSilverAppBar(
//               title: 'Reorder Pages',
//               appBarIconLeft: appBarIconLeft,
//               appBarIconLeftToolTip: appBarIconLeftToolTip,
//               appBarIconLeftAction: appBarIconLeftAction,
//               appBarIconRight: appBarIconRight,
//               appBarIconRightToolTip: appBarIconRightToolTip,
//               appBarIconRightAction:
//                   proceedButton() ? appBarIconRightAction : null,
//             ),
//             body: Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: DragAndDropGridView(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.69, //childAspectRatio: 3 / 4.5,
//                 ),
//                 itemBuilder: (BuildContext context, int index) {
//                   print('itemBuilder ran');
//
//                   RotatedBox rotatedBoxImage =
//                       widget.arguments!.decorationImageListForReorder![index];
//                   return Opacity(
//                     opacity: pos != null
//                         ? pos == index
//                             ? 0 //0.6
//                             : 1
//                         : 1,
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               width: 1, //selectedImages[index] == true ? 2 : 1,
//                               color: selectedImages[index] == true
//                                   ? Colors.blue
//                                   : Colors.grey,
//                             ),
//                             // borderRadius: BorderRadius.only(
//                             //   topLeft: Radius.circular(10),
//                             //   topRight: Radius.circular(10),
//                             //   bottomLeft: Radius.circular(10),
//                             //   bottomRight: Radius.circular(10),
//                             // ),
//                           ),
//                           child: ConstrainedBox(
//                             constraints: BoxConstraints(
//                               maxHeight: 234,
//                               maxWidth: 165,
//                             ),
//                             child: ClipRRect(
//                               // borderRadius: BorderRadius.only(
//                               //   topLeft: Radius.circular(10.0),
//                               //   topRight: Radius.circular(10.0),
//                               //   bottomLeft: Radius.circular(10.0),
//                               //   bottomRight: Radius.circular(10.0),
//                               // ),
//                               child: Container(
//                                 height: 234,
//                                 width: 165,
//                                 decoration: BoxDecoration(
//                                   color: selectedImages[index] == true
//                                       ? Colors.lightBlue[100]
//                                       : Colors.transparent,
//                                 ),
//                                 child: Stack(
//                                   children: [
//                                     rotatedBoxImage,
//                                     // Stack(
//                                     //   children: [
//                                     //     selectedImages[index] == true
//                                     //         ? Align(
//                                     //             alignment: Alignment.topRight,
//                                     //             child: Icon(
//                                     //               Icons.check_circle,
//                                     //               color: Colors.blueAccent,
//                                     //             ),
//                                     //           )
//                                     //         : Container(),
//                                     //     Material(
//                                     //       color: Colors.transparent,
//                                     //       // shape: RoundedRectangleBorder(
//                                     //       //   borderRadius:
//                                     //       //       BorderRadius.circular(10.0),
//                                     //       // ),
//                                     //       child: InkWell(
//                                     //         onTap: () {
//                                     //           setState(() {
//                                     //             selectedImages[index] =
//                                     //                 !selectedImages[index];
//                                     //           });
//                                     //         },
//                                     //         // onLongPress: () {
//                                     //         //   // Do some work (e.g. check if the long press is valid)
//                                     //         //   Feedback.forLongPress(context);
//                                     //         //   // Do more work (e.g. respond to the long press)
//                                     //         // },
//                                     //         // customBorder:
//                                     //         //     RoundedRectangleBorder(
//                                     //         //   borderRadius:
//                                     //         //       BorderRadius.circular(10.0),
//                                     //         // ),
//                                     //         focusColor:
//                                     //             Colors.black.withOpacity(0.1),
//                                     //         highlightColor:
//                                     //             Colors.black.withOpacity(0.1),
//                                     //         splashColor:
//                                     //             Colors.black.withOpacity(0.1),
//                                     //         hoverColor:
//                                     //             Colors.black.withOpacity(0.1),
//                                     //       ),
//                                     //     ),
//                                     //   ],
//                                     // ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         // SizedBox(
//                         //   height: selectedImages[index] == true ? 0 : 2,
//                         // ),
//                         Text('${index + 1}'),
//                         SizedBox(
//                           height: 5,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 isCustomChildWhenDragging: false,
//                 childWhenDragging: (pos) => Container(),
//                 isCustomFeedback: true,
//                 feedback: (index) {
//                   RotatedBox rotatedBoxImage =
//                       widget.arguments!.decorationImageListForReorder![index];
//                   return Opacity(
//                     opacity: pos != null
//                         ? pos == index
//                             ? 0.6
//                             : 1
//                         : 1,
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               width: 1, //selectedImages[index] == true ? 2 : 1,
//                               color: Colors.blue,
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
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(10.0),
//                                 topRight: Radius.circular(10.0),
//                                 bottomLeft: Radius.circular(10.0),
//                                 bottomRight: Radius.circular(10.0),
//                               ),
//                               child: Container(
//                                   height: 234,
//                                   width: 165,
//                                   decoration: BoxDecoration(
//                                     color: selectedImages[index] == true
//                                         ? Colors.lightBlue[100]
//                                         : Colors.transparent,
//                                   ),
//                                   child: rotatedBoxImage
//                                   //   child: Stack(
//                                   //     children: [
//                                   //       selectedImages[index] == true
//                                   //           ? Align(
//                                   //               alignment: Alignment.topRight,
//                                   //               child: Icon(
//                                   //                 Icons.check_circle,
//                                   //                 color: Colors.blueAccent,
//                                   //               ),
//                                   //             )
//                                   //           : Container(),
//                                   //       Material(
//                                   //         color: Colors.transparent,
//                                   //         shape: RoundedRectangleBorder(
//                                   //           borderRadius:
//                                   //               BorderRadius.circular(10.0),
//                                   //         ),
//                                   //         child: InkWell(
//                                   //           onTap: () {
//                                   //             setState(() {
//                                   //               selectedImages[index] =
//                                   //                   !selectedImages[index];
//                                   //             });
//                                   //           },
//                                   //           // onLongPress: () {
//                                   //           //   // Do some work (e.g. check if the long press is valid)
//                                   //           //   Feedback.forLongPress(context);
//                                   //           //   // Do more work (e.g. respond to the long press)
//                                   //           // },
//                                   //           customBorder: RoundedRectangleBorder(
//                                   //             borderRadius:
//                                   //                 BorderRadius.circular(10.0),
//                                   //           ),
//                                   //           focusColor:
//                                   //               Colors.black.withOpacity(0.1),
//                                   //           highlightColor:
//                                   //               Colors.black.withOpacity(0.1),
//                                   //           splashColor:
//                                   //               Colors.black.withOpacity(0.1),
//                                   //           hoverColor:
//                                   //               Colors.black.withOpacity(0.1),
//                                   //         ),
//                                   //       ),
//                                   //     ],
//                                   //   ),
//                                   // ),
//                                   ),
//                             ),
//                           ),
//                         ),
//                         // SizedBox(
//                         //   height: selectedImages[index] == true ? 0 : 2,
//                         // ),
//                         // Text(
//                         //   '${pos != null ? pos! + 1 : index + 1}',
//                         //   style: TextStyle(
//                         //       color: Colors.black,
//                         //       fontSize: 14,
//                         //       fontWeight: FontWeight.normal),
//                         // ),
//                       ],
//                     ),
//                   );
//                 },
//                 onWillAccept: (oldIndex, newIndex) {
//                   print('onWillAccept ran');
//                   widget.arguments!.pdfPagesImages = [...tmpImagesList];
//                   int indexOfFirstItem = widget.arguments!.pdfPagesImages!
//                       .indexOf(widget.arguments!.pdfPagesImages![oldIndex]);
//                   int indexOfSecondItem = widget.arguments!.pdfPagesImages!
//                       .indexOf(widget.arguments!.pdfPagesImages![newIndex]);
//
//                   if (indexOfFirstItem > indexOfSecondItem) {
//                     for (int i = widget.arguments!.pdfPagesImages!.indexOf(
//                             widget.arguments!.pdfPagesImages![oldIndex]);
//                         i >
//                             widget.arguments!.pdfPagesImages!.indexOf(
//                                 widget.arguments!.pdfPagesImages![newIndex]);
//                         i--) {
//                       var tmp = widget.arguments!.pdfPagesImages![i - 1];
//                       widget.arguments!.pdfPagesImages![i - 1] =
//                           widget.arguments!.pdfPagesImages![i];
//                       widget.arguments!.pdfPagesImages![i] = tmp;
//                     }
//                   } else {
//                     for (int i = widget.arguments!.pdfPagesImages!.indexOf(
//                             widget.arguments!.pdfPagesImages![oldIndex]);
//                         i <
//                             widget.arguments!.pdfPagesImages!.indexOf(
//                                 widget.arguments!.pdfPagesImages![newIndex]);
//                         i++) {
//                       var tmp = widget.arguments!.pdfPagesImages![i + 1];
//                       widget.arguments!.pdfPagesImages![i + 1] =
//                           widget.arguments!.pdfPagesImages![i];
//                       widget.arguments!.pdfPagesImages![i] = tmp;
//                     }
//                   }
//
//                   //
//                   widget.arguments!.decorationImageListForReorder = [
//                     ...tmp2ImagesList
//                   ];
//                   int indexOfFirstItem2 = widget
//                       .arguments!.decorationImageListForReorder!
//                       .indexOf(widget
//                           .arguments!.decorationImageListForReorder![oldIndex]);
//                   int indexOfSecondItem2 = widget
//                       .arguments!.decorationImageListForReorder!
//                       .indexOf(widget
//                           .arguments!.decorationImageListForReorder![newIndex]);
//
//                   if (indexOfFirstItem2 > indexOfSecondItem2) {
//                     for (int i = widget
//                             .arguments!.decorationImageListForReorder!
//                             .indexOf(widget.arguments!
//                                 .decorationImageListForReorder![oldIndex]);
//                         i >
//                             widget.arguments!.decorationImageListForReorder!
//                                 .indexOf(widget.arguments!
//                                     .decorationImageListForReorder![newIndex]);
//                         i--) {
//                       var tmp = widget
//                           .arguments!.decorationImageListForReorder![i - 1];
//                       widget.arguments!.decorationImageListForReorder![i - 1] =
//                           widget.arguments!.decorationImageListForReorder![i];
//                       widget.arguments!.decorationImageListForReorder![i] = tmp;
//                     }
//                   } else {
//                     for (int i = widget
//                             .arguments!.decorationImageListForReorder!
//                             .indexOf(widget.arguments!
//                                 .decorationImageListForReorder![oldIndex]);
//                         i <
//                             widget.arguments!.decorationImageListForReorder!
//                                 .indexOf(widget.arguments!
//                                     .decorationImageListForReorder![newIndex]);
//                         i++) {
//                       var tmp = widget
//                           .arguments!.decorationImageListForReorder![i + 1];
//                       widget.arguments!.decorationImageListForReorder![i + 1] =
//                           widget.arguments!.decorationImageListForReorder![i];
//                       widget.arguments!.decorationImageListForReorder![i] = tmp;
//                     }
//                   }
//
//                   setState(
//                     () {
//                       pos = newIndex;
//                       print(pos);
//                     },
//                   );
//                   return true;
//                 },
//                 onReorder: (oldIndex, newIndex) {
//                   HapticFeedback.lightImpact();
//
//                   widget.arguments!.pdfPagesImages = [...tmpImagesList];
//                   int indexOfFirstItem = widget.arguments!.pdfPagesImages!
//                       .indexOf(widget.arguments!.pdfPagesImages![oldIndex]);
//                   int indexOfSecondItem = widget.arguments!.pdfPagesImages!
//                       .indexOf(widget.arguments!.pdfPagesImages![newIndex]);
//
//                   if (indexOfFirstItem > indexOfSecondItem) {
//                     for (int i = widget.arguments!.pdfPagesImages!.indexOf(
//                             widget.arguments!.pdfPagesImages![oldIndex]);
//                         i >
//                             widget.arguments!.pdfPagesImages!.indexOf(
//                                 widget.arguments!.pdfPagesImages![newIndex]);
//                         i--) {
//                       var tmp = widget.arguments!.pdfPagesImages![i - 1];
//                       widget.arguments!.pdfPagesImages![i - 1] =
//                           widget.arguments!.pdfPagesImages![i];
//                       widget.arguments!.pdfPagesImages![i] = tmp;
//                     }
//                   } else {
//                     for (int i = widget.arguments!.pdfPagesImages!.indexOf(
//                             widget.arguments!.pdfPagesImages![oldIndex]);
//                         i <
//                             widget.arguments!.pdfPagesImages!.indexOf(
//                                 widget.arguments!.pdfPagesImages![newIndex]);
//                         i++) {
//                       var tmp = widget.arguments!.pdfPagesImages![i + 1];
//                       widget.arguments!.pdfPagesImages![i + 1] =
//                           widget.arguments!.pdfPagesImages![i];
//                       widget.arguments!.pdfPagesImages![i] = tmp;
//                     }
//                   }
//                   tmpImagesList = [...widget.arguments!.pdfPagesImages!];
//
//                   //For decoration of image
//                   widget.arguments!.decorationImageListForReorder = [
//                     ...tmp2ImagesList
//                   ];
//                   int indexOfFirstItem2 = widget
//                       .arguments!.decorationImageListForReorder!
//                       .indexOf(widget
//                           .arguments!.decorationImageListForReorder![oldIndex]);
//                   int indexOfSecondItem2 = widget
//                       .arguments!.decorationImageListForReorder!
//                       .indexOf(widget
//                           .arguments!.decorationImageListForReorder![newIndex]);
//
//                   if (indexOfFirstItem2 > indexOfSecondItem2) {
//                     for (int i = widget
//                             .arguments!.decorationImageListForReorder!
//                             .indexOf(widget.arguments!
//                                 .decorationImageListForReorder![oldIndex]);
//                         i >
//                             widget.arguments!.decorationImageListForReorder!
//                                 .indexOf(widget.arguments!
//                                     .decorationImageListForReorder![newIndex]);
//                         i--) {
//                       var tmp = widget
//                           .arguments!.decorationImageListForReorder![i - 1];
//                       widget.arguments!.decorationImageListForReorder![i - 1] =
//                           widget.arguments!.decorationImageListForReorder![i];
//                       widget.arguments!.decorationImageListForReorder![i] = tmp;
//
//                       //for recording reorder of images as list. Not to be misunderstood as reordered list of images. Real images reordered is tmpImagesList
//                       int tmp1 = tmpReorderedList[i - 1];
//                       tmpReorderedList[i - 1] = tmpReorderedList[i];
//                       tmpReorderedList[i] = tmp1;
//
//                       //for recording reorder of RotationOfImages images as list. Which would be passed back to carousel list for display
//                       int tmp2 = tmpListOfRotationOfImages[i - 1];
//                       tmpListOfRotationOfImages[i - 1] =
//                           tmpListOfRotationOfImages[i];
//                       tmpListOfRotationOfImages[i] = tmp2;
//
//                       //for recording reorder of deletedImages as list.  Which would be passed back to carousel list for display
//                       bool tmp3 = tmpListOfDeletedImagesRecord[i - 1];
//                       tmpListOfDeletedImagesRecord[i - 1] =
//                           tmpListOfDeletedImagesRecord[i];
//                       tmpListOfDeletedImagesRecord[i] = tmp3;
//
//                       //for recording reorder of controllerValueList as list.  Which would be passed back to carousel list for changes in controllerValue due to reorder
//                       double tmp4 = tmpControllerValueList[i - 1];
//                       tmpControllerValueList[i - 1] = tmpControllerValueList[i];
//                       tmpControllerValueList[i] = tmp4;
//                     }
//                   } else {
//                     for (int i = widget
//                             .arguments!.decorationImageListForReorder!
//                             .indexOf(widget.arguments!
//                                 .decorationImageListForReorder![oldIndex]);
//                         i <
//                             widget.arguments!.decorationImageListForReorder!
//                                 .indexOf(widget.arguments!
//                                     .decorationImageListForReorder![newIndex]);
//                         i++) {
//                       var tmp = widget
//                           .arguments!.decorationImageListForReorder![i + 1];
//                       widget.arguments!.decorationImageListForReorder![i + 1] =
//                           widget.arguments!.decorationImageListForReorder![i];
//                       widget.arguments!.decorationImageListForReorder![i] = tmp;
//
//                       //for recording reorder of images as list. Not to be misunderstood as reordered list of images. Real images reordered is tmpImagesList
//                       int tmp1 = tmpReorderedList[i + 1];
//                       tmpReorderedList[i + 1] = tmpReorderedList[i];
//                       tmpReorderedList[i] = tmp1;
//
//                       //for recording reorder of RotationOfImages images as list. Which would be passed back to carousel list for display
//                       int tmp2 = tmpListOfRotationOfImages[i + 1];
//                       tmpListOfRotationOfImages[i + 1] =
//                           tmpListOfRotationOfImages[i];
//                       tmpListOfRotationOfImages[i] = tmp2;
//
//                       //for recording reorder of deletedImages as list.  Which would be passed back to carousel list for display
//                       bool tmp3 = tmpListOfDeletedImagesRecord[i + 1];
//                       tmpListOfDeletedImagesRecord[i + 1] =
//                           tmpListOfDeletedImagesRecord[i];
//                       tmpListOfDeletedImagesRecord[i] = tmp3;
//
//                       //for recording reorder of controllerValueList as list.  Which would be passed back to carousel list for changes in controllerValue due to reorder
//                       double tmp4 = tmpControllerValueList[i + 1];
//                       tmpControllerValueList[i + 1] = tmpControllerValueList[i];
//                       tmpControllerValueList[i] = tmp4;
//                     }
//                   }
//                   tmp2ImagesList = [
//                     ...widget.arguments!.decorationImageListForReorder!
//                   ];
//
//                   setState(
//                     () {
//                       pos = null;
//                       print(pos);
//                     },
//                   );
//                 },
//                 itemCount: widget.arguments!.pdfPagesImages!.length,
//               ),
//             ),
//           ),
//           selectedDataProcessed == true
//               ? SafeArea(
//                   child: Scaffold(
//                     backgroundColor: Colors.grey.withOpacity(0.5),
//                     body: Center(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(18.0),
//                           color: Colors.white,
//                         ),
//                         height: 200,
//                         width: 200,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CircularProgressIndicator(),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Text('Processing Data'),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }
// }
//
// class ReorderPDFPagesScaffoldArguments {
//   List? pdfPagesImages;
//   PlatformFile pdfFile;
//   ValueChanged<List>? onPDFPagesImages;
//   List<int>? listOfRotationOfImages;
//   ValueChanged<List<int>>? onListOfRotationOfImages;
//   List<bool>? listOfDeletedImagesRecord;
//   ValueChanged<List<bool>>? onListOfDeletedImagesRecord;
//   List? decorationImageListForReorder;
//   ValueChanged<List<RotatedBox>>? onDecorationImageListForReorder;
//   List<int>? reorderedList;
//   ValueChanged<List<int>>? onReorderedList;
//   List<double>? controllerValueList;
//   ValueChanged<List<double>>? onControllerValueList;
//
//   ReorderPDFPagesScaffoldArguments(
//       {this.pdfPagesImages,
//       required this.pdfFile,
//       this.onPDFPagesImages,
//       this.listOfRotationOfImages,
//       this.onListOfRotationOfImages,
//       this.listOfDeletedImagesRecord,
//       this.onListOfDeletedImagesRecord,
//       this.decorationImageListForReorder,
//       this.onDecorationImageListForReorder,
//       this.reorderedList,
//       this.onReorderedList,
//       this.controllerValueList,
//       this.onControllerValueList});
// }
//
// //Note: things are not getting replaced on drag and drop they are all somewhat getting rearranging

import 'package:file_picker/file_picker.dart';
import 'package:files_tools/ads/ad_state.dart';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class ReorderPDFPagesScaffold extends StatefulWidget {
  static const String routeName = '/reorderPDFPagesScaffold';

  const ReorderPDFPagesScaffold({Key? key, this.arguments}) : super(key: key);

  final ReorderPDFPagesScaffoldArguments? arguments;

  @override
  _ReorderPDFPagesScaffoldState createState() =>
      _ReorderPDFPagesScaffoldState();
}

class _ReorderPDFPagesScaffoldState extends State<ReorderPDFPagesScaffold>
    with TickerProviderStateMixin {
  //late AnimationController controller;
  late List<bool> selectedImages;
  late List tmpImagesList;
  late List<RotatedBox> tmp2ImagesList;
  late List<int> tmpReorderedList;
  late List<int> tmpListOfRotationOfImages;
  late List<bool> tmpListOfDeletedImagesRecord;
  late List<double> tmpControllerValueList;

  List<int>? data;

  int? pos;
  @override
  void initState() {
    data = List<int>.generate(
        widget.arguments!.pdfPagesImages!.length, (index) => index);

    tmpImagesList = [...?widget.arguments!.pdfPagesImages];
    tmp2ImagesList = [...?widget.arguments!.decorationImageListForReorder];

    tmpListOfRotationOfImages =
        List.from(widget.arguments!.listOfRotationOfImages!);
    tmpListOfDeletedImagesRecord =
        List.from(widget.arguments!.listOfDeletedImagesRecord!);

    tmpReorderedList = List.from(widget.arguments!.reorderedList!);

    tmpControllerValueList = List.from(widget.arguments!.controllerValueList!);

    selectedImages =
        List.filled(widget.arguments!.pdfPagesImages!.length, false);

    // controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 5),
    // )..addListener(() {
    //     setState(() {});
    //   });
    // controller.repeat(reverse: true);

    appBarIconLeft = Icons.arrow_back;
    appBarIconLeftToolTip = 'Back';
    appBarIconLeftAction = () {
      return Navigator.of(context).pop();
    };

    appBarIconRight = Icons.check;
    appBarIconRightToolTip = 'Done';
    appBarIconRightAction = () async {
      widget.arguments!.onPDFPagesImages?.call(tmpImagesList);
      widget.arguments!.onListOfRotationOfImages
          ?.call(tmpListOfRotationOfImages);
      widget.arguments!.onListOfDeletedImagesRecord
          ?.call(tmpListOfDeletedImagesRecord);
      widget.arguments!.onDecorationImageListForReorder?.call(tmp2ImagesList);
      widget.arguments!.onReorderedList?.call(tmpReorderedList);
      widget.arguments!.onControllerValueList?.call(tmpControllerValueList);
      return Navigator.of(context).pop();
      // shouldWePopScaffold = false;
      // shouldDataBeProcessed = true;
      // setState(() {
      //   selectedDataProcessed = true;
      // });
      //
      // PdfDocument? document;
      // Future.delayed(const Duration(milliseconds: 500), () async {
      //   document = await processSelectedDataFromUser(
      //       selectedData: selectedImages,
      //       processType: 'Remove PDF Data',
      //       filePath: widget.arguments!.pdfFile.path!,
      //       shouldDataBeProcessed: shouldDataBeProcessed);
      //
      //   Map map = Map();
      //   map['_pdfFileName'] = widget.arguments!.pdfFile.name;
      //   map['_document'] = document;
      //
      //   // final result = await compute(creatingAndSavingFileTemporarily, map);
      //   // return result;
      //   //todo: setup isolates to decrease the jitter in circular progress bar a little bit
      //   //todo: to do this first find the culprit and then find a solution if possible
      //   //the main delay is getting the processed document so try to optimise its loop using isolate
      //
      //   return Future.delayed(const Duration(milliseconds: 500), () async {
      //     return document != null
      //         ? await creatingAndSavingFileTemporarily(map)
      //         : null;
      //   });
      // }).then((value) {
      //   // //Get the document security.
      //   // PdfSecurity security = document!.security;
      //   //
      //   // //Get the permissions
      //   // PdfPermissions permissions = security.permissions;
      //   //
      //   // permissions.clear();
      //   // print('permissions : ${permissions.count}');
      //
      //   Future.delayed(const Duration(milliseconds: 500), () async {
      //     if (document != null && shouldDataBeProcessed == true) {
      //       Navigator.pushNamed(
      //         context,
      //         PageRoutes.resultPDFScaffold,
      //         arguments: ResultPDFScaffoldArguments(
      //           document: document!,
      //           pdfPagesSelectedImages: selectedImages,
      //           pdfFilePath: value!,
      //           pdfFile: widget.arguments!.pdfFile,
      //         ),
      //       );
      //     }
      //   }).whenComplete(() {
      //     // setState(() {
      //     selectedDataProcessed = false;
      //     shouldWePopScaffold = true;
      //     // });
      //   });
      // });
    };
    super.initState();
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

  Future<bool> _directPop() async {
    return true;
  }

  bool proceedButton() {
    return true;
  }

  Widget buildItem(int index) {
    print('itemBuilder ran');
    RotatedBox rotatedBoxImage =
        widget.arguments!.decorationImageListForReorder![index];
    return Opacity(
      key: ValueKey(index),
      opacity: pos != null
          ? pos == index
              ? 0 //0.6
              : 1
          : 1,
      child: Column(
        children: <Widget>[
          Container(
            height: 270,
            width: 165,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1, //selectedImages[index] == true ? 2 : 1,
                color:
                    selectedImages[index] == true ? Colors.blue : Colors.grey,
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
                        ? Colors.lightBlue[100]
                        : Colors.transparent,
                  ),
                  child: Stack(
                    children: [
                      rotatedBoxImage,
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
      ),
    );
  }

  Widget dragWidget(int index, Widget child) {
    print('itemBuilder ran');
    RotatedBox rotatedBoxImage =
        widget.arguments!.decorationImageListForReorder![index];
    return Opacity(
      opacity: pos != null
          ? pos == index
              ? 0.6
              : 1
          : 1,
      child: Column(
        children: <Widget>[
          Container(
            height: 270,
            width: 165,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1, //selectedImages[index] == true ? 2 : 1,
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 234,
                maxWidth: 165,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                child: Container(
                    height: 234,
                    width: 165,
                    decoration: BoxDecoration(
                      color: selectedImages[index] == true
                          ? Colors.lightBlue[100]
                          : Colors.transparent,
                    ),
                    child: rotatedBoxImage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double scrollSpeedVariable = 5;

  var bannerAdSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    print('tmpListOfDeletedImagesRecord: $tmpListOfDeletedImagesRecord');
    print('reorderedList: $tmpReorderedList');
    print('setState Ran');
    return WillPopScope(
      onWillPop: shouldWePopScaffold == true ? _directPop : _onWillPop,
      child: Stack(
        children: [
          Scaffold(
            appBar: ReusableSilverAppBar(
              title: widget.arguments!.appBarTitle ?? 'Reorder Pages',
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
                        child: ReorderableGridView.count(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 0,
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          children:
                              this.data!.map((e) => buildItem(e)).toList(),
                          dragWidgetBuilder: dragWidget,
                          scrollSpeedController: (int timeInMilliSecond,
                              double overSize, double itemSize) {
                            print(
                                "timeInMilliSecond: $timeInMilliSecond, overSize: $overSize, itemSize $itemSize");
                            if (timeInMilliSecond > 1500) {
                              scrollSpeedVariable = 15;
                            } else {
                              scrollSpeedVariable = 5;
                            }
                            return scrollSpeedVariable;
                          },
                          onReorder: (oldIndex, newIndex) {
                            print("reorder: $oldIndex -> $newIndex");
                            HapticFeedback.lightImpact();

                            widget.arguments!.pdfPagesImages = [
                              ...tmpImagesList
                            ];
                            int indexOfFirstItem =
                                widget.arguments!.pdfPagesImages!.indexOf(widget
                                    .arguments!.pdfPagesImages![oldIndex]);
                            int indexOfSecondItem =
                                widget.arguments!.pdfPagesImages!.indexOf(widget
                                    .arguments!.pdfPagesImages![newIndex]);

                            if (indexOfFirstItem > indexOfSecondItem) {
                              for (int i = widget.arguments!.pdfPagesImages!
                                      .indexOf(widget.arguments!
                                          .pdfPagesImages![oldIndex]);
                                  i >
                                      widget.arguments!.pdfPagesImages!.indexOf(
                                          widget.arguments!
                                              .pdfPagesImages![newIndex]);
                                  i--) {
                                var tmp =
                                    widget.arguments!.pdfPagesImages![i - 1];
                                widget.arguments!.pdfPagesImages![i - 1] =
                                    widget.arguments!.pdfPagesImages![i];
                                widget.arguments!.pdfPagesImages![i] = tmp;
                              }
                            } else {
                              for (int i = widget.arguments!.pdfPagesImages!
                                      .indexOf(widget.arguments!
                                          .pdfPagesImages![oldIndex]);
                                  i <
                                      widget.arguments!.pdfPagesImages!.indexOf(
                                          widget.arguments!
                                              .pdfPagesImages![newIndex]);
                                  i++) {
                                var tmp =
                                    widget.arguments!.pdfPagesImages![i + 1];
                                widget.arguments!.pdfPagesImages![i + 1] =
                                    widget.arguments!.pdfPagesImages![i];
                                widget.arguments!.pdfPagesImages![i] = tmp;
                              }
                            }
                            tmpImagesList = [
                              ...widget.arguments!.pdfPagesImages!
                            ];

                            //For decoration of image
                            widget.arguments!.decorationImageListForReorder = [
                              ...tmp2ImagesList
                            ];
                            int indexOfFirstItem2 = widget
                                .arguments!.decorationImageListForReorder!
                                .indexOf(widget.arguments!
                                    .decorationImageListForReorder![oldIndex]);
                            int indexOfSecondItem2 = widget
                                .arguments!.decorationImageListForReorder!
                                .indexOf(widget.arguments!
                                    .decorationImageListForReorder![newIndex]);

                            if (indexOfFirstItem2 > indexOfSecondItem2) {
                              for (int i = widget
                                      .arguments!.decorationImageListForReorder!
                                      .indexOf(widget.arguments!
                                              .decorationImageListForReorder![
                                          oldIndex]);
                                  i >
                                      widget.arguments!
                                          .decorationImageListForReorder!
                                          .indexOf(widget.arguments!
                                                  .decorationImageListForReorder![
                                              newIndex]);
                                  i--) {
                                var tmp = widget.arguments!
                                    .decorationImageListForReorder![i - 1];
                                widget.arguments!
                                        .decorationImageListForReorder![i - 1] =
                                    widget.arguments!
                                        .decorationImageListForReorder![i];
                                widget.arguments!
                                    .decorationImageListForReorder![i] = tmp;

                                //for recording reorder of images as list. Not to be misunderstood as reordered list of images. Real images reordered is tmpImagesList
                                int tmp1 = tmpReorderedList[i - 1];
                                tmpReorderedList[i - 1] = tmpReorderedList[i];
                                tmpReorderedList[i] = tmp1;

                                //for recording reorder of RotationOfImages images as list. Which would be passed back to carousel list for display
                                int tmp2 = tmpListOfRotationOfImages[i - 1];
                                tmpListOfRotationOfImages[i - 1] =
                                    tmpListOfRotationOfImages[i];
                                tmpListOfRotationOfImages[i] = tmp2;

                                //for recording reorder of deletedImages as list.  Which would be passed back to carousel list for display
                                bool tmp3 = tmpListOfDeletedImagesRecord[i - 1];
                                tmpListOfDeletedImagesRecord[i - 1] =
                                    tmpListOfDeletedImagesRecord[i];
                                tmpListOfDeletedImagesRecord[i] = tmp3;

                                //for recording reorder of controllerValueList as list.  Which would be passed back to carousel list for changes in controllerValue due to reorder
                                double tmp4 = tmpControllerValueList[i - 1];
                                tmpControllerValueList[i - 1] =
                                    tmpControllerValueList[i];
                                tmpControllerValueList[i] = tmp4;
                              }
                            } else {
                              for (int i = widget
                                      .arguments!.decorationImageListForReorder!
                                      .indexOf(widget.arguments!
                                              .decorationImageListForReorder![
                                          oldIndex]);
                                  i <
                                      widget.arguments!
                                          .decorationImageListForReorder!
                                          .indexOf(widget.arguments!
                                                  .decorationImageListForReorder![
                                              newIndex]);
                                  i++) {
                                var tmp = widget.arguments!
                                    .decorationImageListForReorder![i + 1];
                                widget.arguments!
                                        .decorationImageListForReorder![i + 1] =
                                    widget.arguments!
                                        .decorationImageListForReorder![i];
                                widget.arguments!
                                    .decorationImageListForReorder![i] = tmp;

                                //for recording reorder of images as list. Not to be misunderstood as reordered list of images. Real images reordered is tmpImagesList
                                int tmp1 = tmpReorderedList[i + 1];
                                tmpReorderedList[i + 1] = tmpReorderedList[i];
                                tmpReorderedList[i] = tmp1;

                                //for recording reorder of RotationOfImages images as list. Which would be passed back to carousel list for display
                                int tmp2 = tmpListOfRotationOfImages[i + 1];
                                tmpListOfRotationOfImages[i + 1] =
                                    tmpListOfRotationOfImages[i];
                                tmpListOfRotationOfImages[i] = tmp2;

                                //for recording reorder of deletedImages as list.  Which would be passed back to carousel list for display
                                bool tmp3 = tmpListOfDeletedImagesRecord[i + 1];
                                tmpListOfDeletedImagesRecord[i + 1] =
                                    tmpListOfDeletedImagesRecord[i];
                                tmpListOfDeletedImagesRecord[i] = tmp3;

                                //for recording reorder of controllerValueList as list.  Which would be passed back to carousel list for changes in controllerValue due to reorder
                                double tmp4 = tmpControllerValueList[i + 1];
                                tmpControllerValueList[i + 1] =
                                    tmpControllerValueList[i];
                                tmpControllerValueList[i] = tmp4;
                              }
                            }
                            tmp2ImagesList = [
                              ...widget
                                  .arguments!.decorationImageListForReorder!
                            ];

                            setState(
                              () {
                                pos = null;
                                print(pos);
                              },
                            );
                          },
                        ),
                      ),
                      Provider.of<AdState>(context).bannerAdUnitId != null
                          ? SizedBox(
                              height: bannerAdSize.height.toDouble(),
                            )
                          : Container(),
                    ],
                  ),
                  // DragAndDropGridView(
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 2,
                  //     childAspectRatio: 0.69, //childAspectRatio: 3 / 4.5,
                  //   ),
                  //   itemBuilder: (BuildContext context, int index) {
                  //     print('itemBuilder ran');
                  //
                  //     RotatedBox rotatedBoxImage =
                  //         widget.arguments!.decorationImageListForReorder![index];
                  //     return Opacity(
                  //       opacity: pos != null
                  //           ? pos == index
                  //               ? 0 //0.6
                  //               : 1
                  //           : 1,
                  //       child: Column(
                  //         children: <Widget>[
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               border: Border.all(
                  //                 width: 1, //selectedImages[index] == true ? 2 : 1,
                  //                 color: selectedImages[index] == true
                  //                     ? Colors.blue
                  //                     : Colors.grey,
                  //               ),
                  //             ),
                  //             child: ConstrainedBox(
                  //               constraints: BoxConstraints(
                  //                 maxHeight: 234,
                  //                 maxWidth: 165,
                  //               ),
                  //               child: ClipRRect(
                  //                 child: Container(
                  //                   height: 234,
                  //                   width: 165,
                  //                   decoration: BoxDecoration(
                  //                     color: selectedImages[index] == true
                  //                         ? Colors.lightBlue[100]
                  //                         : Colors.transparent,
                  //                   ),
                  //                   child: Stack(
                  //                     children: [
                  //                       rotatedBoxImage,
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           Text('${index + 1}'),
                  //           SizedBox(
                  //             height: 5,
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  //   isCustomChildWhenDragging: false,
                  //   childWhenDragging: (pos) => Container(),
                  //   isCustomFeedback: true,
                  //   feedback: (index) {
                  //     RotatedBox rotatedBoxImage =
                  //         widget.arguments!.decorationImageListForReorder![index];
                  //     return Opacity(
                  //       opacity: pos != null
                  //           ? pos == index
                  //               ? 0.6
                  //               : 1
                  //           : 1,
                  //       child: Column(
                  //         children: <Widget>[
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               border: Border.all(
                  //                 width: 1, //selectedImages[index] == true ? 2 : 1,
                  //                 color: Colors.blue,
                  //               ),
                  //               borderRadius: BorderRadius.only(
                  //                 topLeft: Radius.circular(10),
                  //                 topRight: Radius.circular(10),
                  //                 bottomLeft: Radius.circular(10),
                  //                 bottomRight: Radius.circular(10),
                  //               ),
                  //             ),
                  //             child: ConstrainedBox(
                  //               constraints: BoxConstraints(
                  //                 maxHeight: 234,
                  //                 maxWidth: 165,
                  //               ),
                  //               child: ClipRRect(
                  //                 borderRadius: BorderRadius.only(
                  //                   topLeft: Radius.circular(10.0),
                  //                   topRight: Radius.circular(10.0),
                  //                   bottomLeft: Radius.circular(10.0),
                  //                   bottomRight: Radius.circular(10.0),
                  //                 ),
                  //                 child: Container(
                  //                     height: 234,
                  //                     width: 165,
                  //                     decoration: BoxDecoration(
                  //                       color: selectedImages[index] == true
                  //                           ? Colors.lightBlue[100]
                  //                           : Colors.transparent,
                  //                     ),
                  //                     child: rotatedBoxImage),
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  //   onWillAccept: (oldIndex, newIndex) {
                  //     print('onWillAccept ran');
                  //     widget.arguments!.pdfPagesImages = [...tmpImagesList];
                  //     int indexOfFirstItem = widget.arguments!.pdfPagesImages!
                  //         .indexOf(widget.arguments!.pdfPagesImages![oldIndex]);
                  //     int indexOfSecondItem = widget.arguments!.pdfPagesImages!
                  //         .indexOf(widget.arguments!.pdfPagesImages![newIndex]);
                  //
                  //     if (indexOfFirstItem > indexOfSecondItem) {
                  //       for (int i = widget.arguments!.pdfPagesImages!.indexOf(
                  //               widget.arguments!.pdfPagesImages![oldIndex]);
                  //           i >
                  //               widget.arguments!.pdfPagesImages!.indexOf(
                  //                   widget.arguments!.pdfPagesImages![newIndex]);
                  //           i--) {
                  //         var tmp = widget.arguments!.pdfPagesImages![i - 1];
                  //         widget.arguments!.pdfPagesImages![i - 1] =
                  //             widget.arguments!.pdfPagesImages![i];
                  //         widget.arguments!.pdfPagesImages![i] = tmp;
                  //       }
                  //     } else {
                  //       for (int i = widget.arguments!.pdfPagesImages!.indexOf(
                  //               widget.arguments!.pdfPagesImages![oldIndex]);
                  //           i <
                  //               widget.arguments!.pdfPagesImages!.indexOf(
                  //                   widget.arguments!.pdfPagesImages![newIndex]);
                  //           i++) {
                  //         var tmp = widget.arguments!.pdfPagesImages![i + 1];
                  //         widget.arguments!.pdfPagesImages![i + 1] =
                  //             widget.arguments!.pdfPagesImages![i];
                  //         widget.arguments!.pdfPagesImages![i] = tmp;
                  //       }
                  //     }
                  //
                  //     //
                  //     widget.arguments!.decorationImageListForReorder = [
                  //       ...tmp2ImagesList
                  //     ];
                  //     int indexOfFirstItem2 = widget
                  //         .arguments!.decorationImageListForReorder!
                  //         .indexOf(widget
                  //             .arguments!.decorationImageListForReorder![oldIndex]);
                  //     int indexOfSecondItem2 = widget
                  //         .arguments!.decorationImageListForReorder!
                  //         .indexOf(widget
                  //             .arguments!.decorationImageListForReorder![newIndex]);
                  //
                  //     if (indexOfFirstItem2 > indexOfSecondItem2) {
                  //       for (int i = widget
                  //               .arguments!.decorationImageListForReorder!
                  //               .indexOf(widget.arguments!
                  //                   .decorationImageListForReorder![oldIndex]);
                  //           i >
                  //               widget.arguments!.decorationImageListForReorder!
                  //                   .indexOf(widget.arguments!
                  //                       .decorationImageListForReorder![newIndex]);
                  //           i--) {
                  //         var tmp = widget
                  //             .arguments!.decorationImageListForReorder![i - 1];
                  //         widget.arguments!.decorationImageListForReorder![i - 1] =
                  //             widget.arguments!.decorationImageListForReorder![i];
                  //         widget.arguments!.decorationImageListForReorder![i] = tmp;
                  //       }
                  //     } else {
                  //       for (int i = widget
                  //               .arguments!.decorationImageListForReorder!
                  //               .indexOf(widget.arguments!
                  //                   .decorationImageListForReorder![oldIndex]);
                  //           i <
                  //               widget.arguments!.decorationImageListForReorder!
                  //                   .indexOf(widget.arguments!
                  //                       .decorationImageListForReorder![newIndex]);
                  //           i++) {
                  //         var tmp = widget
                  //             .arguments!.decorationImageListForReorder![i + 1];
                  //         widget.arguments!.decorationImageListForReorder![i + 1] =
                  //             widget.arguments!.decorationImageListForReorder![i];
                  //         widget.arguments!.decorationImageListForReorder![i] = tmp;
                  //       }
                  //     }
                  //
                  //     setState(
                  //       () {
                  //         pos = newIndex;
                  //         print(pos);
                  //       },
                  //     );
                  //     return true;
                  //   },
                  //   onReorder: (oldIndex, newIndex) {
                  //     HapticFeedback.lightImpact();
                  //
                  //     widget.arguments!.pdfPagesImages = [...tmpImagesList];
                  //     int indexOfFirstItem = widget.arguments!.pdfPagesImages!
                  //         .indexOf(widget.arguments!.pdfPagesImages![oldIndex]);
                  //     int indexOfSecondItem = widget.arguments!.pdfPagesImages!
                  //         .indexOf(widget.arguments!.pdfPagesImages![newIndex]);
                  //
                  //     if (indexOfFirstItem > indexOfSecondItem) {
                  //       for (int i = widget.arguments!.pdfPagesImages!.indexOf(
                  //               widget.arguments!.pdfPagesImages![oldIndex]);
                  //           i >
                  //               widget.arguments!.pdfPagesImages!.indexOf(
                  //                   widget.arguments!.pdfPagesImages![newIndex]);
                  //           i--) {
                  //         var tmp = widget.arguments!.pdfPagesImages![i - 1];
                  //         widget.arguments!.pdfPagesImages![i - 1] =
                  //             widget.arguments!.pdfPagesImages![i];
                  //         widget.arguments!.pdfPagesImages![i] = tmp;
                  //       }
                  //     } else {
                  //       for (int i = widget.arguments!.pdfPagesImages!.indexOf(
                  //               widget.arguments!.pdfPagesImages![oldIndex]);
                  //           i <
                  //               widget.arguments!.pdfPagesImages!.indexOf(
                  //                   widget.arguments!.pdfPagesImages![newIndex]);
                  //           i++) {
                  //         var tmp = widget.arguments!.pdfPagesImages![i + 1];
                  //         widget.arguments!.pdfPagesImages![i + 1] =
                  //             widget.arguments!.pdfPagesImages![i];
                  //         widget.arguments!.pdfPagesImages![i] = tmp;
                  //       }
                  //     }
                  //     tmpImagesList = [...widget.arguments!.pdfPagesImages!];
                  //
                  //     //For decoration of image
                  //     widget.arguments!.decorationImageListForReorder = [
                  //       ...tmp2ImagesList
                  //     ];
                  //     int indexOfFirstItem2 = widget
                  //         .arguments!.decorationImageListForReorder!
                  //         .indexOf(widget
                  //             .arguments!.decorationImageListForReorder![oldIndex]);
                  //     int indexOfSecondItem2 = widget
                  //         .arguments!.decorationImageListForReorder!
                  //         .indexOf(widget
                  //             .arguments!.decorationImageListForReorder![newIndex]);
                  //
                  //     if (indexOfFirstItem2 > indexOfSecondItem2) {
                  //       for (int i = widget
                  //               .arguments!.decorationImageListForReorder!
                  //               .indexOf(widget.arguments!
                  //                   .decorationImageListForReorder![oldIndex]);
                  //           i >
                  //               widget.arguments!.decorationImageListForReorder!
                  //                   .indexOf(widget.arguments!
                  //                       .decorationImageListForReorder![newIndex]);
                  //           i--) {
                  //         var tmp = widget
                  //             .arguments!.decorationImageListForReorder![i - 1];
                  //         widget.arguments!.decorationImageListForReorder![i - 1] =
                  //             widget.arguments!.decorationImageListForReorder![i];
                  //         widget.arguments!.decorationImageListForReorder![i] = tmp;
                  //
                  //         //for recording reorder of images as list. Not to be misunderstood as reordered list of images. Real images reordered is tmpImagesList
                  //         int tmp1 = tmpReorderedList[i - 1];
                  //         tmpReorderedList[i - 1] = tmpReorderedList[i];
                  //         tmpReorderedList[i] = tmp1;
                  //
                  //         //for recording reorder of RotationOfImages images as list. Which would be passed back to carousel list for display
                  //         int tmp2 = tmpListOfRotationOfImages[i - 1];
                  //         tmpListOfRotationOfImages[i - 1] =
                  //             tmpListOfRotationOfImages[i];
                  //         tmpListOfRotationOfImages[i] = tmp2;
                  //
                  //         //for recording reorder of deletedImages as list.  Which would be passed back to carousel list for display
                  //         bool tmp3 = tmpListOfDeletedImagesRecord[i - 1];
                  //         tmpListOfDeletedImagesRecord[i - 1] =
                  //             tmpListOfDeletedImagesRecord[i];
                  //         tmpListOfDeletedImagesRecord[i] = tmp3;
                  //
                  //         //for recording reorder of controllerValueList as list.  Which would be passed back to carousel list for changes in controllerValue due to reorder
                  //         double tmp4 = tmpControllerValueList[i - 1];
                  //         tmpControllerValueList[i - 1] = tmpControllerValueList[i];
                  //         tmpControllerValueList[i] = tmp4;
                  //       }
                  //     } else {
                  //       for (int i = widget
                  //               .arguments!.decorationImageListForReorder!
                  //               .indexOf(widget.arguments!
                  //                   .decorationImageListForReorder![oldIndex]);
                  //           i <
                  //               widget.arguments!.decorationImageListForReorder!
                  //                   .indexOf(widget.arguments!
                  //                       .decorationImageListForReorder![newIndex]);
                  //           i++) {
                  //         var tmp = widget
                  //             .arguments!.decorationImageListForReorder![i + 1];
                  //         widget.arguments!.decorationImageListForReorder![i + 1] =
                  //             widget.arguments!.decorationImageListForReorder![i];
                  //         widget.arguments!.decorationImageListForReorder![i] = tmp;
                  //
                  //         //for recording reorder of images as list. Not to be misunderstood as reordered list of images. Real images reordered is tmpImagesList
                  //         int tmp1 = tmpReorderedList[i + 1];
                  //         tmpReorderedList[i + 1] = tmpReorderedList[i];
                  //         tmpReorderedList[i] = tmp1;
                  //
                  //         //for recording reorder of RotationOfImages images as list. Which would be passed back to carousel list for display
                  //         int tmp2 = tmpListOfRotationOfImages[i + 1];
                  //         tmpListOfRotationOfImages[i + 1] =
                  //             tmpListOfRotationOfImages[i];
                  //         tmpListOfRotationOfImages[i] = tmp2;
                  //
                  //         //for recording reorder of deletedImages as list.  Which would be passed back to carousel list for display
                  //         bool tmp3 = tmpListOfDeletedImagesRecord[i + 1];
                  //         tmpListOfDeletedImagesRecord[i + 1] =
                  //             tmpListOfDeletedImagesRecord[i];
                  //         tmpListOfDeletedImagesRecord[i] = tmp3;
                  //
                  //         //for recording reorder of controllerValueList as list.  Which would be passed back to carousel list for changes in controllerValue due to reorder
                  //         double tmp4 = tmpControllerValueList[i + 1];
                  //         tmpControllerValueList[i + 1] = tmpControllerValueList[i];
                  //         tmpControllerValueList[i] = tmp4;
                  //       }
                  //     }
                  //     tmp2ImagesList = [
                  //       ...widget.arguments!.decorationImageListForReorder!
                  //     ];
                  //
                  //     setState(
                  //       () {
                  //         pos = null;
                  //         print(pos);
                  //       },
                  //     );
                  //   },
                  //   itemCount: widget.arguments!.pdfPagesImages!.length,
                  // ),
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
          selectedDataProcessed == true
              ? SafeArea(
                  child: Scaffold(
                    backgroundColor: Colors.grey.withOpacity(0.5),
                    body: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          color: Colors.white,
                        ),
                        height: 200,
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Processing Data'),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class ReorderPDFPagesScaffoldArguments {
  List? pdfPagesImages;
  PlatformFile? pdfFile;
  ValueChanged<List>? onPDFPagesImages;
  List<int>? listOfRotationOfImages;
  ValueChanged<List<int>>? onListOfRotationOfImages;
  List<bool>? listOfDeletedImagesRecord;
  ValueChanged<List<bool>>? onListOfDeletedImagesRecord;
  List? decorationImageListForReorder;
  ValueChanged<List<RotatedBox>>? onDecorationImageListForReorder;
  List<int>? reorderedList;
  ValueChanged<List<int>>? onReorderedList;
  List<double>? controllerValueList;
  ValueChanged<List<double>>? onControllerValueList;
  String? appBarTitle;

  ReorderPDFPagesScaffoldArguments(
      {this.pdfPagesImages,
      this.pdfFile,
      this.onPDFPagesImages,
      this.listOfRotationOfImages,
      this.onListOfRotationOfImages,
      this.listOfDeletedImagesRecord,
      this.onListOfDeletedImagesRecord,
      this.decorationImageListForReorder,
      this.onDecorationImageListForReorder,
      this.reorderedList,
      this.onReorderedList,
      this.controllerValueList,
      this.onControllerValueList,
      required this.appBarTitle});
}

//Note: things are not getting replaced on drag and drop they are all somewhat getting rearranging
