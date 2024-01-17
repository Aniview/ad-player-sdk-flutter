import Flutter
import UIKit
import AdPlayerSDK

public final class SwiftAdPlayerFlutterPlugin: NSObject {
    private static var instance = SwiftAdPlayerFlutterPlugin()

    private lazy var playerMethodHandler = AdPlayerMethodHandler()
    private lazy var tagMethodHandler = AdPlayerTagMethodHandler()
}

extension SwiftAdPlayerFlutterPlugin: FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        instance.playerMethodHandler.registerChannel(registrar)
        instance.tagMethodHandler.registerChannel(registrar)

        let viewFactory = FLNativeViewFactory(registrar: registrar)
        registrar.register(viewFactory, withId: "AdPlayerPlacementView")
    }
}
