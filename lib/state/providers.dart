import 'package:files_tools/state/app_theme_state.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/state/tools_screens_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App theme state provider.
final ChangeNotifierProvider<AppThemeState> appThemeStateProvider =
    ChangeNotifierProvider<AppThemeState>(
  (final ChangeNotifierProviderRef<AppThemeState> ref) =>
      AppThemeState()..initTheme(),
);

/// App tools screens state provider.
final AutoDisposeChangeNotifierProvider<ToolsScreensState>
    toolsScreensStateProvider = ChangeNotifierProvider.autoDispose(
  (final AutoDisposeChangeNotifierProviderRef<ToolsScreensState> ref) =>
      ToolsScreensState(),
);

/// App tools actions screens state provider.
final AutoDisposeChangeNotifierProvider<ToolsActionsState>
    toolsActionsStateProvider = ChangeNotifierProvider.autoDispose(
  (final AutoDisposeChangeNotifierProviderRef<ToolsActionsState> ref) =>
      ToolsActionsState(),
);
