import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

String currentDateTimeInString() {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String string = dateFormat.format(DateTime.now());
  debugPrint(string);
  return string;
}
