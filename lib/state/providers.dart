import 'package:files_tools/state/app_theme_state.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/state/tools_screens_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App theme state provider.
final ChangeNotifierProvider<AppThemeState> appThemeStateProvider =
    ChangeNotifierProvider<AppThemeState>(
  (ChangeNotifierProviderRef<AppThemeState> ref) =>
      AppThemeState()..initTheme(),
);

/// App tools screens state provider.
final AutoDisposeChangeNotifierProvider<ToolsScreensState>
    toolsScreensStateProvider = ChangeNotifierProvider.autoDispose(
  (AutoDisposeChangeNotifierProviderRef<ToolsScreensState> ref) =>
      ToolsScreensState(),
);

/// App tools actions screens state provider.
final AutoDisposeChangeNotifierProvider<ToolsActionsState>
    toolsActionsStateProvider = ChangeNotifierProvider.autoDispose(
  (AutoDisposeChangeNotifierProviderRef<ToolsActionsState> ref) =>
      ToolsActionsState(),
);
