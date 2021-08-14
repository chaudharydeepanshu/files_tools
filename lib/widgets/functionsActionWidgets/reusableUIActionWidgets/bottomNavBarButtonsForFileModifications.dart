import 'package:flutter/material.dart';

Widget bottomNavBarButtonsForFileModifications(
    {buttonIcon,
    required Widget buttonLabel,
    onTapAction,
    mapOfSubFunctionDetails}) {
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: Container(
      height: 48,
      width: 90,
      child: Material(
        color: onTapAction != null
            ? mapOfSubFunctionDetails!['Button Color'] ?? Colors.amber
            : Colors.grey,
        shape: StadiumBorder(),
        child: InkWell(
          onTap: onTapAction ?? () {},
          customBorder: StadiumBorder(),
          focusColor: onTapAction != null
              ? mapOfSubFunctionDetails!['Button Effects Color'] ??
                  Colors.black.withOpacity(0.1)
              : Colors.grey,
          highlightColor: onTapAction != null
              ? mapOfSubFunctionDetails!['Button Effects Color'] ??
                  Colors.black.withOpacity(0.1)
              : Colors.grey,
          splashColor: onTapAction != null
              ? mapOfSubFunctionDetails!['Button Effects Color'] ??
                  Colors.black.withOpacity(0.1)
              : Colors.grey,
          hoverColor: onTapAction != null
              ? mapOfSubFunctionDetails!['Button Effects Color'] ??
                  Colors.black.withOpacity(0.1)
              : Colors.grey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(
                  color: Colors.black,
                  size: 24,
                ),
                child: buttonIcon ?? Icon(Icons.android),
              ),
              ClipRect(
                child: SizedBox(
                  //height: 20,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: mapOfSubFunctionDetails!['Button Text Color'] ??
                          Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                    child: buttonLabel,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
