import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../app_theme/fitness_app_theme.dart';

class PdfFunctionsAppBar extends StatefulWidget with PreferredSizeWidget {
  const PdfFunctionsAppBar(
      {Key? key,
      this.onNotifyBodyPoppingSplitPDFFunctionScaffold,
      this.notifyAppbarFileStatus,
      this.mapOfFunctionDetails})
      : super(key: key);

  final ValueChanged<bool>? onNotifyBodyPoppingSplitPDFFunctionScaffold;
  final bool? notifyAppbarFileStatus;
  final Map<String, dynamic>? mapOfFunctionDetails;

  @override
  _PdfFunctionsAppBarState createState() => _PdfFunctionsAppBarState();

  @override
  // Size get preferredSize => Size.fromHeight(kToolbarHeight);
  Size get preferredSize => Size.fromHeight(180);
}

class _PdfFunctionsAppBarState extends State<PdfFunctionsAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Container(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 220,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 5, top: 8, bottom: 8),
                        child: SizedBox(
                          width: 51,
                          height: 40,
                          child: Material(
                            color: Colors.transparent,
                            shape: StadiumBorder(),
                            child: Tooltip(
                              message: "Back",
                              child: InkWell(
                                onTap: () {
                                  if (widget.notifyAppbarFileStatus == false) {
                                    Navigator.of(context).pop();
                                  } else if (widget.notifyAppbarFileStatus ==
                                      true) {
                                    Future<bool> _onWillPop() async {
                                      bool dialogAction;
                                      dialogAction = await showDialog<bool>(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Alert'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                      'Going back would cancel loading the file.'),
                                                  Text(
                                                      'Do you still want to go back?'),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Yes'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                              ),
                                              TextButton(
                                                child: Text('No'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      ) as bool;

                                      return dialogAction;
                                    }

                                    _onWillPop().then((value) {
                                      if (value == true) {
                                        widget
                                            .onNotifyBodyPoppingSplitPDFFunctionScaffold
                                            ?.call(true);

                                        Navigator.of(context).pop();
                                      }
                                    });
                                  }
                                },
                                customBorder: StadiumBorder(),
                                focusColor: Colors.black.withOpacity(0.1),
                                highlightColor: Colors.black.withOpacity(0.1),
                                splashColor: Colors.black.withOpacity(0.1),
                                hoverColor: Colors.black.withOpacity(0.1),
                                child: Icon(
                                  Icons.arrow_back_outlined,
                                  size: 24,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          widget.mapOfFunctionDetails!['Title'] ?? 'Split PDF',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              letterSpacing: -0.1,
                              color: FitnessAppTheme.darkText),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          widget.mapOfFunctionDetails!['Subtitle'] ??
                              'Easily extract pages from PDF file',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: FitnessAppTheme.grey.withOpacity(1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 10),
                  child: SvgPicture.asset(
                      widget.mapOfFunctionDetails!['Icon Asset'] ??
                          'assets/images/tools_icons/pdf_tools_icon.svg',
                      fit: BoxFit.fitHeight,
                      height: 120,
                      color:
                          widget.mapOfFunctionDetails!['Icon And Text Color'] ??
                              null,
                      alignment: Alignment.center,
                      semanticsLabel: 'A red up arrow'),
                  // Image.asset(
                  //   widget.mapOfFunctionDetails!['Icon Asset'] ??
                  //       'assets/images/pdf_icon.png',
                  //   fit: BoxFit.fitHeight,
                  //   height: 150,
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
