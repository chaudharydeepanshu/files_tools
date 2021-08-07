import 'package:flutter/material.dart';

class ResultPageButtons extends StatefulWidget {
  const ResultPageButtons(
      {Key? key,
      required this.buttonTitle,
      required this.buttonIcon,
      required this.onTapAction,
      required this.mapOfSubFunctionDetails})
      : super(key: key);

  final String buttonTitle;
  final IconData buttonIcon;
  final Function() onTapAction;
  final Map<String, dynamic>? mapOfSubFunctionDetails;

  @override
  _ResultPageButtonsState createState() => _ResultPageButtonsState();
}

class _ResultPageButtonsState extends State<ResultPageButtons> {
  double defaultButtonElevation = 3;
  double onTapDownButtonElevation = 0;
  double buttonElevation = 3;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 8, bottom: 8),
        child: SizedBox(
          width: 200,
          height: 50,
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
              color: widget.mapOfSubFunctionDetails!['Button Color'] ??
                  Color(0xffE4EAF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: InkWell(
                onTap: widget.onTapAction,
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                focusColor:
                    widget.mapOfSubFunctionDetails!['Button Effects Color'] ??
                        Colors.black.withOpacity(0.1),
                highlightColor:
                    widget.mapOfSubFunctionDetails!['Button Effects Color'] ??
                        Colors.black.withOpacity(0.1),
                splashColor:
                    widget.mapOfSubFunctionDetails!['Button Effects Color'] ??
                        Colors.black.withOpacity(0.1),
                hoverColor:
                    widget.mapOfSubFunctionDetails!['Button Effects Color'] ??
                        Colors.black.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      widget.buttonIcon,
                      size: 24,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.buttonTitle,
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
