import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:files_tools/firebase_options.dart';
import 'package:files_tools/l10n/generated/app_locale.dart';
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

/// Its true if the application is compiled in debug mode.
///
/// Use it in place of [kDebugMode] through out the app to check for debug mode.
/// Useful in faking production mode in debug mode by setting it to false.
bool isInDebugMode = kDebugMode;

/// Key used when building the Navigator.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Key used when building the ScaffoldMessenger.
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// An instance of FirebaseCrashlytics using the default FirebaseApp.
final FirebaseCrashlytics crashlyticsInstance = FirebaseCrashlytics.instance;

/// An instance of FirebaseAnalytics using the default FirebaseApp.
final FirebaseAnalytics analyticsInstance = FirebaseAnalytics.instance;

/// A NavigatorObserver that sends events to FirebaseAnalytics.
///
/// When a route is pushed or popped, it sends the route name to Firebase.
final FirebaseAnalyticsObserver analyticsObserver =
    FirebaseAnalyticsObserver(analytics: analyticsInstance);

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      // To perform some initialization before calling runApp.
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      // To keep the splash screen.
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      // Initializing app info line name, version, etc.
      await AppPackageInfo.initPackageInfo();
      // Initializing SharedPreferences instance.
      await Preferences.initSharedPreferences();
      // Initializing FirebaseApp instance.
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      if (kDebugMode) {
        // Disable Crashlytics collection while doing every day development.
        await crashlyticsInstance.setCrashlyticsCollectionEnabled(false);
        await analyticsInstance.setAnalyticsCollectionEnabled(false);
        await analyticsInstance.setUserId(id: 'debugModeId');
      } else {
        // Enable Crashlytics collection based on user preference in production.
        await crashlyticsInstance.setCrashlyticsCollectionEnabled(
          Preferences.crashlyticsCollectionStatus,
        );
        await analyticsInstance.setAnalyticsCollectionEnabled(
          Preferences.analyticsCollectionStatus,
        );
        await analyticsInstance.setUserId(id: 'prodModeId');
      }
      // This captures errors reported by the Flutter framework.
      FlutterError.onError = crashlyticsInstance.recordFlutterFatalError;

      // To remove the splash screen once everything is initialized.
      FlutterNativeSplash.remove();

      runApp(const ProviderScope(child: DynamicColorApp()));
    },
    (Object error, StackTrace stack) =>
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  );
}

/// Called before MaterialApp to get Material You color info from device.
///
/// It provides the color schemes based on users device wallpaper.
class DynamicColorApp extends StatelessWidget {
  /// Defining DynamicColorApp constructor.
  const DynamicColorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (
        final ColorScheme? lightDynamic,
        final ColorScheme? darkDynamic,
      ) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            // Initializing dynamic color schemes in [AppThemeState]
            // ChangeNotifier class to access it through out the app.
            AppThemeState appThemeState = ref.read(appThemeStateProvider);
            appThemeState.initTheme(
              lightDynamic: lightDynamic,
              darkDynamic: darkDynamic,
            );
            // PostFrameCallback is necessary because DynamicColorBuilder
            // doesn't provide dynamic colorScheme instantly as its an
            // asynchronous process due to delayed response by OS.
            // So whenever it gets the color scheme or the color scheme
            // gets updated due to wallpaper change it will rebuild the builder
            // and once the builder is built completely it will run
            // updateTheme() in [AppThemeState] to update theme and
            // to notifyListeners about the new dynamic colorScheme.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              appThemeState.updateTheme();
            });
            return const MyApp();
          },
        );
      },
    );
  }
}

/// This widget is the root of our application. It creates a MaterialApp.
class MyApp extends StatelessWidget {
  /// Defining MyApp constructor.
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // throw Exception("This is a test crash!");
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        // Getting ThemeData and ThemeMode from [AppThemeState] ChangeNotifier
        // class to use them through out the app.
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
          initialRoute: Preferences.isUserOnBoarded
              ? route.AppRoutes.homePage
              : route.AppRoutes.onBoardingPage,
          navigatorKey: navigatorKey,
          navigatorObservers: <NavigatorObserver>[analyticsObserver],
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          localizationsDelegates: AppLocale.localizationsDelegates,
          supportedLocales: AppLocale.supportedLocales,
        );
      },
    );
  }
}

// General TODOs
// TODO(chaudharydeepanshu): Improve appbar texts to be informative and smaller.
// TODO(chaudharydeepanshu): Handle low storage scenarios when viewing large
//  high quality PDFs.(Tip: Clear cache for some and then reload if low storage)
// TODO(chaudharydeepanshu): Use flutter_intro to guide users step-by-step.
// TODO(chaudharydeepanshu): Add localization.
// TODO(chaudharydeepanshu): Page splitting on the basis of page ranges. It
//  should take multiple ranges from user to create sets of pdf of those ranges.
// TODO(chaudharydeepanshu): Fix watermarking failing for some large PDFs.
// TODO(chaudharydeepanshu): Fix converting many large size images into single
//  PDF crashing the application. Quick fix would be to create single PDFs and
//  then merge those single PDFs.
// TODO(chaudharydeepanshu): Add PDF redaction.
// TODO(chaudharydeepanshu): Use image mode instead of file mode for images
//  picking for functions like 'convert images to pdf'.
//  Should be done once this issue resolves https://issuetracker.google.com/issues/257642029.
