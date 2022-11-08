import 'package:files_tools/state/package_info_state.dart';
import 'package:files_tools/state/select_file_state.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared_preferences/preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme_state.dart';

late final PackageInfo packageInfo;
late final SharedPreferences sharedPreferencesInstance;

Future<void> initPackageInfo() async {
  packageInfo = await PackageInfo.fromPlatform();
}

Future<void> initSharedPreferences() async {
  sharedPreferencesInstance = await SharedPreferences.getInstance();
}

final packageInfoCalcProvider =
    ChangeNotifierProvider((ref) => PackageInfoCalc()..init(packageInfo));

final preferencesProvider = ChangeNotifierProvider(
    (ref) => Preferences(ref)..init(sharedPreferencesInstance));

final appThemeStateProvider =
    ChangeNotifierProvider((ref) => AppThemeState(ref)..init());

final toolScreenStateProvider =
    ChangeNotifierProvider.autoDispose((ref) => ToolScreenState());

final toolsActionsStateProvider =
    ChangeNotifierProvider.autoDispose((ref) => ToolsActionsState());
