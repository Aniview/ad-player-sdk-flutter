//
//  AdPlayerChannel.swift
//  adplayer_flutter_plugin
//
//  Created by Pavel Yevtukhov on 11.01.2024.
//

import Flutter
import AdPlayerSDK

final class AdPlayerMethodHandler {
    func registerChannel(_ registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "AdPlayer", binaryMessenger: registrar.messenger())
        channel.setMethodCallHandler { [weak self] call, result in
            self?.handle(call, result: result)
        }
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getVersion":
            result(moduleVersion)
        case "initialize":
            handleInitializeSDK(arguments: call.arguments, result: result)
        case "initializePublisher":
            handleInitializePublisher(arguments: call.arguments, result: result)
        case "reportLayoutChange":  // not needed on iOS
            result(nil)
        case "getTagWhenReady":
            handleGetTagWhenReady(arguments: call.arguments, result: result)
        default:
            #if DEBUG
            fatalError("Not implemented: \(call.method)")
            #else
            result(FlutterError.notImplemented(name: call.method))
            #endif
        }
    }

    private func handleInitializeSDK(arguments: Any?, result: @escaping FlutterResult) {
        guard let params = arguments as? [String: String],
              let storeURLString = params["iosStoreUrl"],
              let storeURL = URL(string: storeURLString)
        else {
            result(FlutterError.missingArguments())
            return
        }
        AdPlayer.initSdk(storeURL: storeURL)
        result(nil)
    }

    private func handleInitializePublisher(arguments: Any?, result: @escaping FlutterResult) {
        guard let params = arguments as? [String: String],
              let publisherId = params["publisherId"],
              let tagId = params["tagId"]
        else {
            result(FlutterError.missingArguments())
            return
        }

        AdPlayer.initializePublisher(publisherId: publisherId, tagId: tagId) { sdkResult in
            switch sdkResult {
            case .success:
                result(tagId)
            case .failure(let error):
                result(FlutterError.sdkError(message: "InitializePublisher: \(error.localizedDescription)"))
            }
        }
    }

    private func handleGetTagWhenReady(arguments: Any?, result: @escaping FlutterResult) {
        guard let params = arguments as? [String: String],
              let tagId = params["tagId"]
        else {
            result(FlutterError.missingArguments())
            return
        }

        AdPlayer.getTagWhenReady(tagId: tagId) { sdkResult in
            switch sdkResult {
            case .success:
                result(tagId)
            case .failure(let error):
                result(FlutterError.sdkError(message: "GetTagWhenReady: \(error.localizedDescription)"))
            }
        }
    }

    private var moduleVersion: String {
        Bundle(for: Self.self).object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
    }
}
