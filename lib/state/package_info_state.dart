import 'package:package_info_plus/package_info_plus.dart';

/// App [PackageInfo] Instance.
late final PackageInfo packageInfo;

/// App [PackageInfo] state class.
class AppPackageInfo {
  /// [PackageInfo] Instance initializer.
  static Future<void> initPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }
}
