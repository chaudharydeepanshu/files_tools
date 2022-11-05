import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/ui/theme/app_theme_data.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:files_tools/route/route.dart' as route;

import 'firebase_options.dart';

final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
final FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await initSharedPreferences();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterNativeSplash.remove();

    FlutterError.onError = crashlytics.recordFlutterFatalError;

    runApp(const ProviderScope(child: MyApp()));
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            ref
                .read(appThemeStateProvider)
                .init(lightDynamic: lightDynamic, darkDynamic: darkDynamic);
            ThemeMode themeMode = ref.watch(
                appThemeStateProvider.select((value) => value.themeMode));
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Files Tools',
              theme: AppThemeData.lightThemeData(lightDynamic),
              darkTheme: AppThemeData.darkThemeData(darkDynamic),
              themeMode: themeMode,
              onGenerateRoute: route.controller,
              initialRoute: route.homePage,
              navigatorKey: navigatorKey,
              navigatorObservers: [observer],
              scaffoldMessengerKey: rootScaffoldMessengerKey,
            );
          },
        );
      },
    );
  }
}

// Todo: Add extraction of pages from selection and splitting on the basis of ranges.
// Todo: Use the same widget for showing loading and error messages everywhere.
// Todo: Use image mode instead of file mode for images selection in application such as images to pdf function. To do that improve the pick or save plugin.
// Todo: Check on watermarking is failing for some large pdfs.
// Todo: Show error messages or stacktrace for errors everywhere.
