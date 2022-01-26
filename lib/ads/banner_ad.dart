import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'ad_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// import 'custom_ad_widget.dart';

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
//         ? Container(
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
  //not required as google_mobile_ads version 0.13.6 supports AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize() to support getting an AnchoredAdaptiveBannerAdSize in the current orientation.
  // return await AdSize.getAnchoredAdaptiveBannerAdSize(
  //   MediaQuery.of(context).orientation == Orientation.portrait
  //       ? Orientation.portrait
  //       : Orientation.landscape,
  //   MediaQuery.of(context).size.width.toInt(),
  // );
  return await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.toInt());
}

class BannerAD extends StatefulWidget {
  const BannerAD({Key? key}) : super(key: key);

  @override
  _BannerADState createState() => _BannerADState();
}

class _BannerADState extends State<BannerAD> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  BannerAd? banner;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  AnchoredAdaptiveBannerAdSize? size;

  String? now;
  Timer? everySecond;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    // sets first value
    now = DateTime.now().second.toString();

    // defines a timer to update ad ui according to latest adStatus value from AdState class
    // this timer is set to setState every 5 seconds
    // we are using it to hide ad loading status if ad fails to load due to any case other than internet
    everySecond = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      if (mounted) {
        setState(() {
          now = DateTime.now().second.toString();
        });
      }
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
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

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _connectionStatus = result;
      if (banner != null) {
        banner!.load();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((value) async {
      size = await createAnchoredBanner(context);
      setState(() {
        if (adState.bannerAdUnitId != null) {
          banner = BannerAd(
            listener: adState.adListener,
            adUnitId: adState.bannerAdUnitId!,
            request: const AdRequest(),
            size: size!,
            // AdSize.banner,
          )..load();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Connection Status: ${_connectionStatus.toString()}');
    return banner == null
        ? const SizedBox()
        : _connectionStatus == ConnectivityResult.none
            ? Container(
                height: size!.height.toDouble(),
                width: size!.width.toDouble(),
                color: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Expanded(
                          child: Text(
                            'To support the app please connect to internet.',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Container(
                color: AdState.adStatus ? Colors.grey : Colors.transparent,
                width: AdState.adStatus ? size!.width.toDouble() : 0,
                height: AdState.adStatus ? size!.height.toDouble() : 0,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AdState.adStatus
                                ? const Expanded(
                                    child: Text(
                                      'Ad loading...\nThanks for your support',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                    AdState.adStatus
                        ? AdWidget(
                            ad: banner!,
                          )
                        // ? CustomAdWidget(
                        //     ad: banner!,
                        //   )
                        : Container(),
                    // AdWidget(
                    //   ad: banner!,
                    // ),
                  ],
                ),
              );
  }
}
