import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_file/open_file.dart';
import 'package:files_tools/basicFunctionalityFunctions/getSizeFromBytes.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';

class DialogActionBodyOfButtonForSelectedMultipleImages extends StatefulWidget {
  const DialogActionBodyOfButtonForSelectedMultipleImages(
      {Key? key,
      required this.filePath,
      required this.fileName,
      required this.fileByte,
      required this.mapOfFunctionDetails})
      : super(key: key);

  final String filePath;
  final String fileName;
  final int fileByte;
  final Map<String, dynamic>? mapOfFunctionDetails;

  @override
  _DialogActionBodyOfButtonForSelectedMultipleImagesState createState() =>
      _DialogActionBodyOfButtonForSelectedMultipleImagesState();
}

class _DialogActionBodyOfButtonForSelectedMultipleImagesState
    extends State<DialogActionBodyOfButtonForSelectedMultipleImages> {
  var myChildSize;

  double defaultButtonElevation = 3;
  double onTapDownButtonElevation = 0;
  double buttonElevation = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // key: Key('${uuid.v1()}'),//don't use or will cause never ending rebuild as setState in this widget will cause new id and new id cause new build meaning endless loop
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
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
                  color: widget
                          .mapOfFunctionDetails!['Select File Button Color'] ??
                      Color(0xffE4EAF6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      OpenFile.open(widget.filePath);
                    },
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    focusColor: widget.mapOfFunctionDetails![
                            'Select File Button Effects Color'] ??
                        Colors.black.withOpacity(0.1),
                    highlightColor: widget.mapOfFunctionDetails![
                            'Select File Button Effects Color'] ??
                        Colors.black.withOpacity(0.1),
                    splashColor: widget.mapOfFunctionDetails![
                            'Select File Button Effects Color'] ??
                        Colors.black.withOpacity(0.1),
                    hoverColor: widget.mapOfFunctionDetails![
                            'Select File Button Effects Color'] ??
                        Colors.black.withOpacity(0.1),
                    child: Container(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              MeasureSize(
                                onChange: (size) {
                                  setState(() {
                                    myChildSize = size;
                                    print(myChildSize);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 20, bottom: 20),
                                  child: SvgPicture.asset(
                                      widget.mapOfFunctionDetails![
                                              'Select File Icon Asset'] ??
                                          'assets/images/tools_icons/image_tools_icon.svg',
                                      fit: BoxFit.fitHeight,
                                      height: 35,
                                      color: widget.mapOfFunctionDetails![
                                              'Select File Icon Color'] ??
                                          null,
                                      alignment: Alignment.center,
                                      semanticsLabel: 'A red up arrow'),
                                  // Image.asset(
                                  //   'assets/images/pdf_icon.png',
                                  //   fit: BoxFit.fitHeight,
                                  //   height: 35,
                                  // ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.fileName}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${formatBytes(widget.fileByte, 2)}',
                                          style: TextStyle(fontSize: 12),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
