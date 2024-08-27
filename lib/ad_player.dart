import 'package:flutter/services.dart';

abstract class AdPlayer {
  static const _channel = MethodChannel("AdPlayer");

  static Future<String> getVersion() async {
    return await _channel.invokeMethod<String>("getVersion") ?? "unknown";
  }

  static Future<void> initialize({String? iosStoreUrl}) async {
    await _channel.invokeMethod("initialize", {
      "iosStoreUrl": iosStoreUrl,
    });
  }

  static Future<void> initializePublisher({
    required String publisherId,
    required String tagId,
  }) async {
    await _channel.invokeMethod("initializePublisher", {
      "publisherId": publisherId,
      "tagId": tagId,
    });
  }

  static Future<String> getTagWhenReady({required String tagId}) async {
    return await _channel.invokeMethod("getTagWhenReady", {
      "tagId": tagId,
    });
  }
}
