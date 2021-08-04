import 'package:flutter/material.dart';

class CustomKeyboard extends StatefulWidget {
  CustomKeyboard({
    Key? key,
    required this.onTextInput,
    required this.onBackspace,
  }) : super(key: key);

  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;

  @override
  _CustomKeyboardState createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  void _textInputHandler(String text) => widget.onTextInput.call(text);

  void _backspaceHandler() => widget.onBackspace.call();

  void _capsHandler() {
    setState(() {
      capsStatus = capsStatus == true ? false : true;
    });
  }

  void _capsKeysHandling(String text) =>
      widget.onTextInput.call(text.toUpperCase());

  bool capsStatus = false;
  late double screenWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 250,
      color: Colors.blue,
      child: Column(
        children: [
          buildRowOne(),
          buildRowTwo(),
          buildRowThree(),
          buildRowFour(),
          buildRowFive(),
        ],
      ),
    );
  }

  Expanded buildRowOne() {
    return Expanded(
      child: Row(
        children: [
          TextKey(
            text: '1',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '2',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '3',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '4',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '5',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '6',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '7',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '8',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '9',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '0',
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }

  Expanded buildRowTwo() {
    return Expanded(
      child: Row(
        children: [
          TextKey(
            text: capsStatus == false ? 'q' : 'Q',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'w' : 'W',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'e' : 'E',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'r' : 'R',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 't' : 'T',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'y' : 'Y',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'u' : 'U',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'i' : 'I',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'o' : 'O',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'p' : 'P',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
        ],
      ),
    );
  }

  Expanded buildRowThree() {
    return Expanded(
      child: Row(
        children: [
          Container(
            color: Colors.transparent,
            width: screenWidth / 20,
          ),
          TextKey(
            text: capsStatus == false ? 'a' : 'A',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 's' : 'S',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'd' : 'D',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'f' : 'F',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'g' : 'G',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'h' : 'H',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'j' : 'J',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'k' : 'K',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'l' : 'L',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          Container(
            color: Colors.transparent,
            width: screenWidth / 20,
          ),
        ],
      ),
    );
  }

  Expanded buildRowFour() {
    return Expanded(
      child: Row(
        children: [
          CapsKey(
            onCaps: _capsHandler,
            keyWidth: (3 * (screenWidth / 10)) / 2,
          ),
          TextKey(
            text: capsStatus == false ? 'z' : 'Z',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'x' : 'X',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'c' : 'C',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'v' : 'V',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'b' : 'B',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'n' : 'N',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          TextKey(
            text: capsStatus == false ? 'm' : 'M',
            onTextInput:
                capsStatus == false ? _textInputHandler : _capsKeysHandling,
          ),
          BackspaceKey(
            onBackspace: _backspaceHandler,
            keyWidth: (3 * (screenWidth / 10)) / 2,
          ),
        ],
      ),
    );
  }

  Expanded buildRowFive() {
    return Expanded(
      child: Row(
        children: [
          TextKey(
            text: ',',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '"',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: ' ',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '-',
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }
}

class TextKey extends StatelessWidget {
  const TextKey({
    Key? key,
    required this.text,
    required this.onTextInput,
    this.flex = 1,
  }) : super(key: key);

  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Material(
          color: Colors.blue.shade300,
          child: InkWell(
            onTap: () {
              onTextInput.call(text);
            },
            child: Container(
              child: Center(child: Text(text)),
            ),
          ),
        ),
      ),
    );
  }
}

class BackspaceKey extends StatelessWidget {
  const BackspaceKey({
    Key? key,
    required this.onBackspace,
    this.flex = 1,
    required this.keyWidth,
  }) : super(key: key);

  final VoidCallback onBackspace;
  final int flex;
  final double keyWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: keyWidth,
      //flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Material(
          color: Colors.blue.shade300,
          child: InkWell(
            onTap: () {
              onBackspace.call();
            },
            child: Container(
              child: Center(
                child: Icon(Icons.backspace),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CapsKey extends StatelessWidget {
  const CapsKey({
    Key? key,
    required this.onCaps,
    this.flex = 1,
    required this.keyWidth,
  }) : super(key: key);

  final VoidCallback onCaps;
  final int flex;
  final double keyWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: keyWidth,
      //flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Material(
          color: Colors.blue.shade300,
          child: InkWell(
            onTap: () {
              onCaps.call();
            },
            child: Container(
              child: Center(
                child: Icon(Icons.arrow_upward_rounded),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
