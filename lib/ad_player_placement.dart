import 'dart:math';

import 'package:adplayer_flutter_plugin/ad_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AdPlayerPlacementWidget extends StatefulWidget {
  final String tagId;

  AdPlayerPlacementWidget({required this.tagId}) : super(key: ValueKey(tagId));

  @override
  State createState() {
    return _AdPlayerPlacementWidgetState();
  }
}

class _AdPlayerPlacementWidgetState extends State<AdPlayerPlacementWidget> {
  static const nativeViewType = "AdPlayerPlacementView";
  static var placementIdCounter = 0;

  late final channelName = "$nativeViewType/$placementId";
  late final channel = MethodChannel(channelName)..setMethodCallHandler(onChannelMessage);
  late final placementId = ++placementIdCounter;
  late final viewCreationArgs = {
    "tagId": widget.tagId,
    "placementId": placementId,
  };

  var placementHeight = 1.0;

  @override
  void initState() {
    super.initState();
    dummyInitialize();
  }

  @override
  void dispose() {
    channel.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.tagId}-$placementId"),
      onVisibilityChanged: (info) => AdPlayer.reportLayoutChange(),
      child: SizedBox(
        height: placementHeight,
        child: buildPlatformWidget(context),
      ),
    );
  }

  Widget buildPlatformWidget(BuildContext context) {
    final platform = defaultTargetPlatform;
    switch (platform) {
      case TargetPlatform.android:
        return buildAndroidWidget(context);
      case TargetPlatform.iOS:
        return buildIOsWidget(context);
      default:
        return Text("Platform $platform not supported");
    }
  }

  Widget buildAndroidWidget(BuildContext context) {
    return PlatformViewLink(
      viewType: nativeViewType,
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const {},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: nativeViewType,
          layoutDirection: TextDirection.ltr,
          creationParams: viewCreationArgs,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }

  Widget buildIOsWidget(BuildContext context) {
    return UiKitView(
      viewType: nativeViewType,
      layoutDirection: TextDirection.ltr,
      creationParams: viewCreationArgs,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  Future<dynamic> onChannelMessage(MethodCall call) async {
    switch (call.method) {
      case "onHeightChanged":
        final height = max(1, call.arguments as double);
        final scaling = MediaQuery.of(context).devicePixelRatio;
        setState(() => placementHeight = height / scaling);
        break;
    }
  }

  Future<void> dummyInitialize() async {
    try {
      await channel.invokeMethod("initialize");
    } catch (e) {
      // ignore
    }
  }
}
