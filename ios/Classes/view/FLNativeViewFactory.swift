//
//  FLNativeViewFactory.swift
//  adplayer_flutter_plugin
//
//  Created by Pavel Yevtukhov on 11.01.2024.
//

import Flutter

final class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private let registrar: FlutterPluginRegistrar

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {

        return AdPlayerPlacementView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: registrar.messenger()
        )
    }
}
