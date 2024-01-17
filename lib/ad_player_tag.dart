import 'package:flutter/services.dart';

abstract class AdPlayerTag {
  static const _channel = MethodChannel("AdPlayerTag");

  static Future<void> preloadVideo(String tagId) async {
    await _channel.invokeMethod("preloadVideo", {
      "tagId": tagId,
    });
  }
}
