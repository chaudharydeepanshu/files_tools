import 'dart:async';
import 'package:files_tools/basicFunctionalityFunctions/lifecycleEventHandler.dart'
    as lifecycleEventHandler;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'ad_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// class BannerAD extends StatefulWidget {
//   const BannerAD({Key? key}) : super(key: key);
//
//   @override
//   _BannerADState createState() => _BannerADState();
// }
//
// class _BannerADState extends State<BannerAD> {
//   BannerAd? banner;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final adState = Provider.of<AdState>(context);
//     adState.initialization.then((value) {
//       setState(() {
//         banner = BannerAd(
//           listener: adState.adListener,
//           adUnitId: adState.bannerAdUnitId,
//           request: AdRequest(),
//           size: AdSize.banner,
//         )..load();
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return banner == null
//         ? SizedBox(
//             height: AdSize.banner.height.toDouble(),
//           )
//         : Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 height: AdSize.banner.height.toDouble(),
//                 child: AdWidget(
//                   ad: banner!,
//                 ),
//               ),
//             ],
//           );
//   }
// }

Future<AnchoredAdaptiveBannerAdSize?> createAnchoredBanner(
    BuildContext context) async {
  return await AdSize.getAnchoredAdaptiveBannerAdSize(
    MediaQuery.of(context).orientation == Orientation.portrait
        ? Orientation.portrait
        : Orientation.landscape,
    MediaQuery.of(context).size.width.toInt(),
  );
}

class BannerAD extends StatefulWidget {
  const BannerAD({Key? key}) : super(key: key);

  @override
  _BannerADState createState() => _BannerADState();
}

class _BannerADState extends State<BannerAD> with WidgetsBindingObserver {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  BannerAd? banner;

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _connectivitySubscription.cancel();
    super.dispose();
  }

  AnchoredAdaptiveBannerAdSize? size;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // WidgetsBinding.instance!.addObserver(
    //     lifecycleEventHandler.LifecycleEventHandler(resumeCallBack: () async {
    //   print('resumeCallBack');
    // }));
    WidgetsBinding.instance!.addObserver(this);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      if (banner != null) {
        banner!.load();
      }
    });
  }

  tempFunction() async {
    await createAnchoredBanner(context).then((value) {
      setState(() {
        size = value;
      });
    });
  }

  @override
  void didChangeMetrics() {
    tempFunction();
    print('orientation changed');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    // size = AnchoredAdaptiveBannerAdSize(Orientation.portrait,height: 50, width: 150);
    adState.initialization.then((value) async {
      if (size == null) {
        size = await createAnchoredBanner(context);
      }
      setState(() {
        banner = BannerAd(
          listener: adState.adListener,
          adUnitId: adState.bannerAdUnitId,
          request: AdRequest(),
          size: //size!,
              AdSize.banner,
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Connection Status: ${_connectionStatus.toString()}');
    return banner == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: AdSize.banner.height.toDouble() + 10,
              ),
            ],
          )
        : _connectionStatus == ConnectivityResult.none
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: AdSize.banner.height.toDouble() + 10,
                    width: size!.width.toDouble(),
                    color: Colors.grey.shade300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Please connect to internet.\nTo support the app',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    color: Colors.grey.shade300,
                    width: size!.width.toDouble(),
                    height: size!.height.toDouble(),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Thanks for supporting\nAd loading...',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                        AdWidget(
                          ad: banner!,
                        ),
                      ],
                    ),
                  ),
                ],
              );
  }
}
