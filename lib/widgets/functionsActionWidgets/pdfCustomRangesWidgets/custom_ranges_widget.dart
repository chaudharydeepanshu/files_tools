import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RangeWidget extends StatefulWidget {
  const RangeWidget({
    required Key key,
    required this.index,
    required this.listTextEditingControllerPairs,
    required this.listOfQuartetsOfButtonsOfRanges,
    required this.pdfPageCount,
    required this.onListTextEditingControllerPairs,
    required this.onListOfQuartetsOfButtonsOfRanges,
    this.onDeleteRange,
    required this.rangeNumber,
    required this.color,
  }) : super(key: key);

  final int index;
  final List<List<TextEditingController>> listTextEditingControllerPairs;
  final ValueChanged<List<List<TextEditingController>>>?
      onListTextEditingControllerPairs;
  final List<List<bool>> listOfQuartetsOfButtonsOfRanges;
  final ValueChanged<List<List<bool>>>? onListOfQuartetsOfButtonsOfRanges;
  final int pdfPageCount;
  final ValueChanged<int>? onDeleteRange;
  final int rangeNumber;
  final Color color;

  @override
  _RangeWidgetState createState() => _RangeWidgetState();
}

class _RangeWidgetState extends State<RangeWidget> {
  Color? oddItemColor;
  Color? evenItemColor;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  List<TextEditingController> listOfTextEditingController = [];

  bool normalButton = true;
  bool reverseButton = false;
  bool oddButton = false;
  bool evenButton = false;
  List<bool> listOfRangeButtonStatus = [];
  List<TextInputFormatter>? listTextInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(
        18), //as 9999...19 times throws following exception "Positive input exceeds the limit of integer 9999999999999999999"
  ];

  @override
  void initState() {
    oddItemColor = widget.color.withOpacity(0.05);
    evenItemColor = widget.color.withOpacity(0.15);

    listOfTextEditingController.add(controller1);
    listOfTextEditingController.add(controller2);
    widget.listTextEditingControllerPairs.add(listOfTextEditingController);
    // widget.listTextEditingControllerPairs[widget.index][0].addListener(() {
    //   setState(() {});
    // });
    // widget.listTextEditingControllerPairs[widget.index][1].addListener(() {
    //   setState(() {});
    // });
    widget.listTextEditingControllerPairs[widget.rangeNumber][0]
        .addListener(() {
      setState(() {});
    });
    widget.listTextEditingControllerPairs[widget.rangeNumber][1]
        .addListener(() {
      setState(() {});
    });

    listOfRangeButtonStatus.add(normalButton);
    listOfRangeButtonStatus.add(reverseButton);
    listOfRangeButtonStatus.add(oddButton);
    listOfRangeButtonStatus.add(evenButton);
    widget.listOfQuartetsOfButtonsOfRanges.add(listOfRangeButtonStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // key: Key('${widget.index}'),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Range ${widget.rangeNumber + 1}'),
                Padding(
                  padding: const EdgeInsets.only(left: 5, top: 8, bottom: 8),
                  child: SizedBox(
                    width: 51,
                    height: 40,
                    child: Material(
                      color: Colors.transparent,
                      shape: const StadiumBorder(),
                      child: Tooltip(
                        message: "Delete",
                        child: InkWell(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            widget.onDeleteRange?.call(widget.rangeNumber + 1);
                          },
                          customBorder: const StadiumBorder(),
                          focusColor: Colors.red.withOpacity(0.1),
                          highlightColor: Colors.red.withOpacity(0.1),
                          splashColor: Colors.red.withOpacity(0.1),
                          hoverColor: Colors.red.withOpacity(0.1),
                          child: const Icon(
                            Icons.delete_forever,
                            size: 24,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                RangeTextForField(
                  index: widget.rangeNumber,
                  listTextEditingControllerPairs:
                      widget.listTextEditingControllerPairs,
                  pdfPageCount: widget.pdfPageCount,
                  onListTextEditingControllerPairs:
                      (List<List<TextEditingController>> value) {
                    widget.onListTextEditingControllerPairs?.call(value);
                  },
                  labelText: "From page",
                  hintText: "Ex: 1",
                  textEditingControllerInt: 0,
                  listTextInputFormatter: listTextInputFormatter,
                ),
                Column(
                  children: const [
                    Icon(
                      Icons.remove,
                      size: 12,
                    ),
                    SizedBox(
                      height: 22,
                    ),
                  ],
                ),
                RangeTextForField(
                  index: widget.rangeNumber,
                  listTextEditingControllerPairs:
                      widget.listTextEditingControllerPairs,
                  pdfPageCount: widget.pdfPageCount,
                  onListTextEditingControllerPairs:
                      (List<List<TextEditingController>> value) {
                    widget.onListTextEditingControllerPairs?.call(value);
                  },
                  labelText: "To page",
                  hintText: "Ex: ${widget.pdfPageCount}",
                  textEditingControllerInt: 1,
                  listTextInputFormatter: listTextInputFormatter,
                ),
                const SizedBox(
                  width: 2,
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ButtonsOfRanges(
                              listOfQuartetsOfButtonsOfRanges:
                                  widget.listOfQuartetsOfButtonsOfRanges,
                              index: widget.rangeNumber,
                              onListOfQuartetsOfButtonsOfRanges:
                                  (List<List<bool>> value) {
                                setState(() {
                                  widget.onListOfQuartetsOfButtonsOfRanges
                                      ?.call(value);
                                });
                              },
                              buttonText: 'Normal',
                              listTextEditingControllerPairs:
                                  widget.listTextEditingControllerPairs,
                            ),
                            ButtonsOfRanges(
                              listOfQuartetsOfButtonsOfRanges:
                                  widget.listOfQuartetsOfButtonsOfRanges,
                              index: widget.rangeNumber,
                              onListOfQuartetsOfButtonsOfRanges:
                                  (List<List<bool>> value) {
                                setState(() {
                                  widget.onListOfQuartetsOfButtonsOfRanges
                                      ?.call(value);
                                });
                              },
                              buttonText: 'Reverse',
                              listTextEditingControllerPairs:
                                  widget.listTextEditingControllerPairs,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            ButtonsOfRanges(
                              listOfQuartetsOfButtonsOfRanges:
                                  widget.listOfQuartetsOfButtonsOfRanges,
                              index: widget.rangeNumber,
                              onListOfQuartetsOfButtonsOfRanges:
                                  (List<List<bool>> value) {
                                setState(() {
                                  widget.onListOfQuartetsOfButtonsOfRanges
                                      ?.call(value);
                                });
                              },
                              buttonText: 'Odd',
                              listTextEditingControllerPairs:
                                  widget.listTextEditingControllerPairs,
                            ),
                            ButtonsOfRanges(
                              listOfQuartetsOfButtonsOfRanges:
                                  widget.listOfQuartetsOfButtonsOfRanges,
                              index: widget.rangeNumber,
                              onListOfQuartetsOfButtonsOfRanges:
                                  (List<List<bool>> value) {
                                setState(() {
                                  widget.onListOfQuartetsOfButtonsOfRanges
                                      ?.call(value);
                                });
                              },
                              buttonText: 'Even',
                              listTextEditingControllerPairs:
                                  widget.listTextEditingControllerPairs,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: widget.index.isOdd ? oddItemColor : evenItemColor,
      ),
    );
  }
}

class RangeTextForField extends StatelessWidget {
  const RangeTextForField(
      {Key? key,
      required this.index,
      required this.listTextEditingControllerPairs,
      required this.onListTextEditingControllerPairs,
      required this.pdfPageCount,
      required this.listTextInputFormatter,
      required this.labelText,
      required this.hintText,
      required this.textEditingControllerInt})
      : super(key: key);

  final int index;
  final List<List<TextEditingController>> listTextEditingControllerPairs;
  final ValueChanged<List<List<TextEditingController>>>?
      onListTextEditingControllerPairs;
  final int pdfPageCount;
  final List<TextInputFormatter>? listTextInputFormatter;
  final String labelText;
  final String hintText;
  final int textEditingControllerInt;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: TextFormField(
        controller: listTextEditingControllerPairs[index]
            [textEditingControllerInt],
        keyboardType: TextInputType.number,
        inputFormatters: listTextInputFormatter,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (int.parse(value.substring(0, 1)) == 0) {
              String newValue =
                  value.substring(0, 0) + '' + value.substring(0 + 1);
              listTextEditingControllerPairs[index][textEditingControllerInt]
                  .value = TextEditingValue(
                text: newValue,
                selection: TextSelection.fromPosition(
                  TextPosition(offset: newValue.length),
                ),
              );
            }
          }
          onListTextEditingControllerPairs
              ?.call(listTextEditingControllerPairs);
        },
        decoration: InputDecoration(
          labelText: labelText,
          helperText: ' ',
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        //autofocus: true,
        showCursor: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Empty Field';
          } else if (int.parse(value) > pdfPageCount)
          //RegExp('[a-zA-Z0-9 \"‘\'‘,-]')
          {
            return 'Out of range';
          }
          return null;
        },
      ),
    );
  }
}

class ButtonsOfRanges extends StatelessWidget {
  const ButtonsOfRanges(
      {Key? key,
      required this.listOfQuartetsOfButtonsOfRanges,
      this.onListOfQuartetsOfButtonsOfRanges,
      required this.index,
      required this.buttonText,
      required this.listTextEditingControllerPairs})
      : super(key: key);

  final List<List<bool>> listOfQuartetsOfButtonsOfRanges;
  final ValueChanged<List<List<bool>>>? onListOfQuartetsOfButtonsOfRanges;
  final List<List<TextEditingController>> listTextEditingControllerPairs;
  final int index;
  final String buttonText;

  int buttonNumber() {
    if (buttonText == 'Normal') {
      return 0;
    } else if (buttonText == 'Reverse') {
      return 1;
    } else if (buttonText == 'Odd') {
      return 2;
    } else if (buttonText == 'Even') {
      return 3;
    }
    return 0;
  }

  bool rangeButtonsStatus() {
    if (listTextEditingControllerPairs[index][0].value.text.isNotEmpty &&
        listTextEditingControllerPairs[index][1].value.text.isNotEmpty &&
        listTextEditingControllerPairs[index][0].value.text !=
            listTextEditingControllerPairs[index][1].value.text) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Material(
          color: listOfQuartetsOfButtonsOfRanges[index][buttonNumber()] == false
              ? rangeButtonsStatus()
                  ? Colors.transparent
                  : Colors.grey
              : rangeButtonsStatus()
                  ? Colors.lightBlueAccent
                  : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(
              color: rangeButtonsStatus() ? Colors.black : Colors.transparent,
            ),
          ),
          child: Tooltip(
            message: buttonText,
            child: InkWell(
              onTap: rangeButtonsStatus()
                  ? () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      listOfQuartetsOfButtonsOfRanges[index][0] =
                          buttonText == 'Normal' ? true : false;
                      listOfQuartetsOfButtonsOfRanges[index][1] =
                          buttonText == 'Reverse' ? true : false;
                      listOfQuartetsOfButtonsOfRanges[index][2] =
                          buttonText == 'Odd' ? true : false;
                      listOfQuartetsOfButtonsOfRanges[index][3] =
                          buttonText == 'Even' ? true : false;

                      onListOfQuartetsOfButtonsOfRanges
                          ?.call(listOfQuartetsOfButtonsOfRanges);
                    }
                  : null,
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              focusColor: listOfQuartetsOfButtonsOfRanges[index]
                          [buttonNumber()] ==
                      false
                  ? rangeButtonsStatus()
                      ? Colors.transparent.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1)
                  : rangeButtonsStatus()
                      ? Colors.blueAccent.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
              highlightColor: listOfQuartetsOfButtonsOfRanges[index]
                          [buttonNumber()] ==
                      false
                  ? rangeButtonsStatus()
                      ? Colors.transparent.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1)
                  : rangeButtonsStatus()
                      ? Colors.blueAccent.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
              splashColor: listOfQuartetsOfButtonsOfRanges[index]
                          [buttonNumber()] ==
                      false
                  ? rangeButtonsStatus()
                      ? Colors.transparent.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1)
                  : rangeButtonsStatus()
                      ? Colors.blueAccent.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
              hoverColor: listOfQuartetsOfButtonsOfRanges[index]
                          [buttonNumber()] ==
                      false
                  ? rangeButtonsStatus()
                      ? Colors.transparent.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1)
                  : rangeButtonsStatus()
                      ? Colors.blueAccent.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
                style: const TextStyle(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
