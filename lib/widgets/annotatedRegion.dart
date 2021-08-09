import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReusableAnnotatedRegion extends StatefulWidget {
  const ReusableAnnotatedRegion({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  @override
  _ReusableAnnotatedRegionState createState() =>
      _ReusableAnnotatedRegionState();
}

class _ReusableAnnotatedRegionState extends State<ReusableAnnotatedRegion>
    with WidgetsBindingObserver {
  bool? darkModeOn;
  String? theme;

  themeCalc() async {
    if (AdaptiveTheme.of(context).mode.isLight) {
      setState(() {
        theme = 'Light';
      });
    } else if (AdaptiveTheme.of(context).mode.isDark) {
      setState(() {
        theme = 'Dark';
      });
    } else if (AdaptiveTheme.of(context).mode.isSystem) {
      setState(() {
        theme = 'System';
      });
    }
  }

  @override
  void didChangePlatformBrightness() {
    var brightness = WidgetsBinding.instance!.window.platformBrightness;
    print(brightness);
    // > should print Brightness.light / Brightness.dark when you switch
    themeCalc();
    setState(() {
      darkModeOn = (theme == 'Dark') ||
          (brightness == Brightness.dark && theme == 'System');
    });
    super.didChangePlatformBrightness();
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this); //most important
    var brightness = WidgetsBinding.instance!.window.platformBrightness;
    print(brightness);
    // > should print Brightness.light / Brightness.dark when you switch
    themeCalc();
    setState(() {
      darkModeOn = (theme == 'Dark') ||
          (brightness == Brightness.dark && theme == 'System');
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        // statusBarColor:
        //     darkModeOn! ? Colors.black : Colors.white, //Colors.transparent,
        // statusBarIconBrightness:
        //     darkModeOn! ? Brightness.light : Brightness.dark,
        // statusBarBrightness: !kIsWeb && Platform.isAndroid && darkModeOn!
        //     ? Brightness.dark
        //     : Brightness.light,
        systemNavigationBarColor: darkModeOn! ? Colors.black : Colors.white,
        // systemNavigationBarDividerColor:
        //     darkModeOn! ? Colors.white10 : Colors.grey,
        systemNavigationBarIconBrightness:
            darkModeOn! ? Brightness.light : Brightness.dark,
      ),
      child: widget.child,
    );
  }
}
