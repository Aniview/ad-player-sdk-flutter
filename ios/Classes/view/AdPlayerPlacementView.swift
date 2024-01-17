//
//  AdPlayerPlacementView.swift
//  adplayer_flutter_plugin
//
//  Created by Pavel Yevtukhov on 11.01.2024.
//

import Flutter
import UIKit
import AdPlayerSDK

final class AdPlayerPlacementView: NSObject, FlutterPlatformView {
    private let frame: CGRect
    private let tagId: String
    private let channel: FlutterMethodChannel

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        self.frame = frame
        tagId = (args as? [String: String])?["tagId"] ?? ""
        channel = FlutterMethodChannel(
            name: "AdPlayerPlacementView/\(viewId)",
            binaryMessenger: messenger!
        )
        super.init()
    }

    func view() -> UIView {
        let view = PlayerWrapperView(tagId: tagId, frame: .zero)
        view.playerVC.layoutDelegate = self
        return view
    }
}

extension AdPlayerPlacementView: AdPlacementLayoutDelegate {
    func adPlacementContentDidAdd() {
    }

    func adPlacementHeightWillChange(to newValue: CGFloat) {
        channel.invokeMethod("onHeightChanged", arguments: newValue)
    }
}

final class PlayerWrapperView: UIView {
    let tagId: String
    let playerVC: AdPlayerPlacementViewController

    init(tagId: String, frame: CGRect) {
        self.tagId = tagId
        playerVC = AdPlayerPlacementViewController(tagId: tagId)
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        if let parent = findViewController() {
            parent.addChild(playerVC)
            playerVC.view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(playerVC.view)
            NSLayoutConstraint.activate([
                playerVC.view.topAnchor.constraint(equalTo: topAnchor),
                playerVC.view.bottomAnchor.constraint(equalTo: bottomAnchor),
                playerVC.view.leadingAnchor.constraint(equalTo: leadingAnchor),
                playerVC.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
            playerVC.didMove(toParent: parent)
        } else {
            playerVC.willMove(toParent: nil)
            playerVC.removeFromParent()
        }
    }
}

private extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
