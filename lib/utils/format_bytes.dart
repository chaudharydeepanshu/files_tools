import 'dart:math';

// ignore: constant_identifier_names
enum BytesFormatType { auto, B, KB, MB, GB, TB, PB, EB, ZB, YB }

// This is for MB etc not MiB etc as they use 1024 instead of 1000.
String formatBytes({
  required int bytes,
  required int decimals,
  BytesFormatType? formatType,
}) {
  if (BytesFormatType.B == formatType) {
    if (bytes <= 0) return "0";
    return (bytes).toStringAsFixed(decimals);
  } else if (BytesFormatType.KB == formatType) {
    if (bytes <= 0) return "0";
    var i = (bytes / 1000);
    return (i).toStringAsFixed(decimals);
  } else if (BytesFormatType.MB == formatType) {
    if (bytes <= 0) return "0";
    var i = (bytes / pow(1000, 2));
    return (i).toStringAsFixed(decimals);
  } else if (BytesFormatType.GB == formatType) {
    if (bytes <= 0) return "0";
    var i = (bytes / pow(1000, 3));
    return (i).toStringAsFixed(decimals);
  } else if (BytesFormatType.TB == formatType) {
    if (bytes <= 0) return "0";
    var i = (bytes / pow(1000, 4));
    return (i).toStringAsFixed(decimals);
  } else if (BytesFormatType.PB == formatType) {
    if (bytes <= 0) return "0";
    var i = (bytes / pow(1000, 5));
    return (i).toStringAsFixed(decimals);
  } else if (BytesFormatType.EB == formatType) {
    if (bytes <= 0) return "0";
    var i = (bytes / pow(1000, 6));
    return (i).toStringAsFixed(decimals);
  } else if (BytesFormatType.ZB == formatType) {
    if (bytes <= 0) return "0";
    var i = (bytes / pow(1000, 7));
    return (i).toStringAsFixed(decimals);
  } else if (BytesFormatType.YB == formatType) {
    if (bytes <= 0) return "0";
    var i = (bytes / pow(1000, 8));
    return (i).toStringAsFixed(decimals);
  } else {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1000)).floor();
    return '${(bytes / pow(1000, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
