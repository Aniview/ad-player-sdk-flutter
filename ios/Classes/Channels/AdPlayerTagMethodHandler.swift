//
//  AdPlayerTagMethodHandler.swift
//  adplayer_flutter_plugin
//
//  Created by Pavel Yevtukhov on 11.01.2024.
//

import Flutter
import AdPlayerSDK

final class AdPlayerTagMethodHandler {
    func registerChannel(_ registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "AdPlayerTag", binaryMessenger: registrar.messenger())
        channel.setMethodCallHandler { [weak self] call, result in
            self?.handle(call, result: result)
        }
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "preloadVideo":
            handlePreload(arguments: call.arguments, result: result)
        default:
            #if DEBUG
            fatalError("Not implemented: \(call.method)")
            #else
            result(FlutterError.notImplemented(name: call.method))
            #endif
        }
    }

    private func handlePreload(arguments: Any?, result: @escaping FlutterResult) {
        guard let params = arguments as? [String: String],
              let tagId = params["tagId"]
        else {
            result(FlutterError.missingArguments())
            return
        }

        AdPlayer.getTagWhenReady(tagId: tagId) { [weak self] sdkResult in
            guard let self = self else { return }
            switch sdkResult {
            case .success(let tag):
                preload(tag: tag, result: result)
            case .failure(let error):
                result(FlutterError.sdkError(message: error.localizedDescription))
            }
        }
    }

    private func preload(tag: AdPlayerTag, result: @escaping FlutterResult) {
        tag.preload { error in
            guard let error = error else {
                result(true)
                return
            }
            result(FlutterError.sdkError(message: error.localizedDescription))
        }
    }
}

extension FlutterError {
    static func notImplemented(name: String) -> FlutterError {
        FlutterError(code: "0", message: "\(name) method is not implemented", details: nil)
    }

    static func missingArguments() -> FlutterError {
        FlutterError(code: "1", message: "Arguments are missing", details: nil)
    }

    static func sdkError(message: String) -> FlutterError {
        FlutterError(code: "2", message: message, details: nil)
    }
}
