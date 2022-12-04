import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:files_tools/firebase_options.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/app_theme_state.dart';
import 'package:files_tools/state/package_info_state.dart';
import 'package:files_tools/state/preferences.dart';
import 'package:files_tools/state/providers.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
final FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      await AppPackageInfo.initPackageInfo();
      await Preferences.initSharedPreferences();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      if (kDebugMode) {
        // Disable Crashlytics collection while doing every day development.
        await FirebaseCrashlytics.instance
            .setCrashlyticsCollectionEnabled(false);
        await FirebaseAnalytics.instance.setUserId(id: 'debugModeId');
      }

      FlutterError.onError = crashlytics.recordFlutterFatalError;

      FlutterNativeSplash.remove();

      runApp(const ProviderScope(child: MyApp()));
    },
    (Object error, StackTrace stack) =>
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            AppThemeState appThemeState = ref.read(appThemeStateProvider);
            appThemeState.initTheme(
              lightDynamic: lightDynamic,
              darkDynamic: darkDynamic,
            );
            // This is needed because DynamicColorBuilder doesn't provide
            // dynamic colorScheme if os is yet to respond.
            // So we just update the color scheme once again when we get the
            // new dynamic colorScheme.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              appThemeState.updateTheme();
            });
            return const App();
          },
        );
      },
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        bool isUserOnBoarded = Preferences.isUserOnBoarded;
        ThemeData lightThemeData = ref.watch(
          appThemeStateProvider
              .select((AppThemeState value) => value.appLightThemeData),
        );
        ThemeData darkThemeData = ref.watch(
          appThemeStateProvider
              .select((AppThemeState value) => value.appDarkThemeData),
        );
        ThemeMode themeMode = ref.watch(
          appThemeStateProvider
              .select((AppThemeState value) => value.themeMode),
        );
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Files Tools',
          theme: lightThemeData,
          darkTheme: darkThemeData,
          themeMode: themeMode,
          onGenerateRoute: route.AppRoutes.controller,
          initialRoute: isUserOnBoarded
              ? route.AppRoutes.homePage
              : route.AppRoutes.onBoardingPage,
          navigatorKey: navigatorKey,
          navigatorObservers: <NavigatorObserver>[observer],
          scaffoldMessengerKey: rootScaffoldMessengerKey,
        );
      },
    );
  }
}

// Todo: Improve appbar texts for smaller screens.
// Todo: Use flutter_intro for first use step-by-step users guide for app.
// Todo: Add localization.
// Todo: Add extraction of pages from selection and splitting on the basis of ranges.
// Todo: Use image mode instead of file mode for images selection in application such as images to pdf function. Can't do it due to https://issuetracker.google.com/issues/257642029.
// Todo: Check on watermarking is failing for some large pdfs.
// Todo: Add pdf redaction
