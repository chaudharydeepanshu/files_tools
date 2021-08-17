import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// ignore: implementation_imports
import 'package:google_mobile_ads/src/ad_instance_manager.dart';

/// Displays an [Ad] as a Flutter widget.
///
/// This widget takes ads inheriting from [AdWithView]
/// (e.g. [BannerAd] and [NativeAd]) and allows them to be added to the Flutter
/// widget tree.
///
/// Must call `load()` first before showing the widget. Otherwise, a
/// [PlatformException] will be thrown.
class CustomAdWidget extends StatefulWidget {
  /// Default constructor for [CustomAdWidget].
  ///
  /// [ad] must be loaded before this is added to the widget tree.
  const CustomAdWidget({Key? key, required this.ad}) : super(key: key);

  /// Ad to be displayed as a widget.
  final AdWithView ad;

  @override
  _CustomAdWidgetState createState() => _CustomAdWidgetState();
}

class _CustomAdWidgetState extends State<CustomAdWidget> {
  bool _adIdAlreadyMounted = false;
  bool _adLoadNotCalled = false;

  @override
  void initState() {
    super.initState();
    final int? adId = instanceManager.adIdFor(widget.ad);
    if (adId != null) {
      if (instanceManager.isWidgetAdIdMounted(adId)) {
        _adIdAlreadyMounted = true;
      }
      instanceManager.mountWidgetAdId(adId);
    } else {
      _adLoadNotCalled = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    final int? adId = instanceManager.adIdFor(widget.ad);
    if (adId != null) {
      instanceManager.unmountWidgetAdId(adId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_adIdAlreadyMounted) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('This AdWidget is already in the Widget tree'),
        ErrorHint(
            'If you placed this AdWidget in a list, make sure you create a new instance '
            'in the builder function with a unique ad object.'),
        ErrorHint(
            'Make sure you are not using the same ad object in more than one AdWidget.'),
      ]);
    }
    if (_adLoadNotCalled) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
            'AdWidget requires Ad.load to be called before AdWidget is inserted into the tree'),
        ErrorHint(
            'Parameter ad is not loaded. Call Ad.load before AdWidget is inserted into the tree.'),
      ]);
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: '${instanceManager.channel.name}/ad_widget',
        creationParams: instanceManager.adIdFor(widget.ad),
        creationParamsCodec: StandardMessageCodec(),
      );
      // return PlatformViewLink(
      //   viewType: '${instanceManager.channel.name}/ad_widget',
      //   surfaceFactory:
      //       (BuildContext context, PlatformViewController controller) {
      //     return AndroidViewSurface(
      //       controller: controller as AndroidViewController,
      //       gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
      //       hitTestBehavior: PlatformViewHitTestBehavior.opaque,
      //     );
      //   },
      //   onCreatePlatformView: (PlatformViewCreationParams params) {
      //     return PlatformViewsService.initSurfaceAndroidView(
      //       id: params.id,
      //       viewType: '${instanceManager.channel.name}/ad_widget',
      //       layoutDirection: TextDirection.ltr,
      //       creationParams: instanceManager.adIdFor(widget.ad),
      //       creationParamsCodec: StandardMessageCodec(),
      //     )
      //       ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
      //       ..create();
      //   },
      // );
    }

    return UiKitView(
      viewType: '${instanceManager.channel.name}/ad_widget',
      creationParams: instanceManager.adIdFor(widget.ad),
      creationParamsCodec: StandardMessageCodec(),
    );
  }
}
