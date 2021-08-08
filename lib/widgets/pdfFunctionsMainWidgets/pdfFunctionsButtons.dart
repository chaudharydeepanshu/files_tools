import 'package:flutter/material.dart';
import 'package:files_tools/app_theme/app_theme.dart';

class PDFFunctions extends StatefulWidget {
  const PDFFunctions(
      {Key? key,
      required this.fileLoadingStatus,
      required this.onTapAction,
      required this.subFunctionDetailMap,
      required this.filePickedStatus})
      : super(key: key);

  final bool? fileLoadingStatus;
  final bool? filePickedStatus;
  final Function()? onTapAction;
  final Map<String, dynamic>? subFunctionDetailMap;

  @override
  _PDFFunctionsState createState() => _PDFFunctionsState();
}

class _PDFFunctionsState extends State<PDFFunctions> {
  double defaultButtonElevation = 3;
  double onTapDownButtonElevation = 0;
  double buttonElevation = 3;
  bool showButtonInfo = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fileLoadingStatus == true) {
      showButtonInfo = false;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            showButtonInfo = true;
          });
        },
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
          color: widget.fileLoadingStatus == true ||
                  (widget.subFunctionDetailMap!['File Loading Required'] ==
                          false &&
                      widget.filePickedStatus == true)
              ? widget.subFunctionDetailMap!['Button Color']
              : Colors.grey.shade300,
          elevation: widget.fileLoadingStatus == false ? 0 : buttonElevation,
          shadowColor: widget.subFunctionDetailMap!['Button Color'],
          type: MaterialType.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: InkWell(
            onTap: widget.fileLoadingStatus == true ||
                    (widget.subFunctionDetailMap!['File Loading Required'] ==
                            false &&
                        widget.filePickedStatus == true)
                ? widget.onTapAction
                : null,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusColor: widget.subFunctionDetailMap!['Button Effects Color'] ??
                Colors.black.withOpacity(0.1),
            highlightColor:
                widget.subFunctionDetailMap!['Button Effects Color'] ??
                    Colors.black.withOpacity(0.1),
            splashColor: widget.subFunctionDetailMap!['Button Effects Color'] ??
                Colors.black.withOpacity(0.1),
            hoverColor: widget.subFunctionDetailMap!['Button Effects Color'] ??
                Colors.black.withOpacity(0.1),
            child: Container(
              //height: widget.fileLoadingStatus == true ? 77 : 92,
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
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.subFunctionDetailMap!['Title'] ??
                                      'Extract select pages',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    letterSpacing: 0.0,
                                    color: widget.fileLoadingStatus == false
                                        ? Colors.black
                                        : widget.subFunctionDetailMap![
                                                'Button Text Color'] ??
                                            AppTheme.darkText,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.subFunctionDetailMap!['Subtitle'] ??
                                      'All selected page will be extracted in 1 PDF',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 0.0,
                                    color: widget.fileLoadingStatus == false
                                        ? Colors.black
                                        : widget.subFunctionDetailMap![
                                                'Button Text Color'] ??
                                            AppTheme.darkText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ),
                  widget.fileLoadingStatus == false && showButtonInfo == true
                      ? widget.filePickedStatus == false
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Colors.grey.shade400,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      'Complete Step - 1 To Unlock',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        letterSpacing: 0.0,
                                        color: widget.subFunctionDetailMap![
                                                'Button Text Color'] ??
                                            AppTheme.darkText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : widget.subFunctionDetailMap![
                                      'File Loading Required'] ==
                                  true
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: Colors.grey.shade400,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          'Unlocked Once Loading Completes',
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            letterSpacing: 0.0,
                                            color: widget.subFunctionDetailMap![
                                                    'Button Text Color'] ??
                                                AppTheme.darkText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container()
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
