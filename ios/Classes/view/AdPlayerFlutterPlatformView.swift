//
//  AdPlayerPlacementView.swift
//  adplayer_flutter_plugin
//
//  Created by Pavel Yevtukhov on 11.01.2024.
//

import Flutter
import UIKit
import AdPlayerSDK

final class AdPlayerFlutterPlatformView: NSObject, FlutterPlatformView {
    private let frame: CGRect
    private let tagId: String
    private let channel: FlutterMethodChannel

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        guard let dict = args as? [String: Any],
              let tagId = dict["tagId"] as? String,
              let placementId = dict["placementId"] as? Int else {
            fatalError("iOS:AdPlayerPlacementView: missing arguments")
        }

        self.frame = frame
        self.tagId = tagId
        channel = FlutterMethodChannel(
            name: "AdPlayerPlacementView/\(placementId)",
            binaryMessenger: messenger!
        )
        super.init()
    }

    func view() -> UIView {
        let view = PlayerWrapperView(tagId: tagId, frame: .zero, channel: channel)
        return view
    }
}

final class PlayerWrapperView: UIView {
    private weak var adPlacementView: AdPlayerPlacementView?
    private let tagId: String
    private let channel: FlutterMethodChannel
    private var animator: AnimatorView?

    init(tagId: String, frame: CGRect, channel: FlutterMethodChannel) {
        self.tagId = tagId
        self.channel = channel

        super.init(frame: frame)
        clipsToBounds = true
        setupAnimator()
        addPlacement()
    }

    private func setupAnimator() {
        let animator = AnimatorView(frame: .zero) { [weak self] value in
            self?.channel.invokeMethod("onHeightChanged", arguments: value * UIScreen.main.scale)
        }
        addSubview(animator)
        animator.translatesAutoresizingMaskIntoConstraints = false
        animator.isHidden = true
        sendSubviewToBack(animator)
        NSLayoutConstraint.activate([
            animator.leadingAnchor.constraint(equalTo: trailingAnchor, constant: 100),
            animator.topAnchor.constraint(equalTo: bottomAnchor, constant: 100)
        ])
        self.animator = animator
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addPlacement() {
        let placement = AdPlayerPlacementView(tagId: tagId)
        placement.layoutDelegate = self
        placement.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placement)
        NSLayoutConstraint.activate([
            placement.topAnchor.constraint(equalTo: topAnchor),
            placement.bottomAnchor.constraint(equalTo: bottomAnchor),
            placement.leadingAnchor.constraint(equalTo: leadingAnchor),
            placement.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        self.adPlacementView = placement
    }
}

extension PlayerWrapperView: AdPlacementLayoutDelegate {
    func adPlacementHeightWillChange(to newValue: CGFloat) {
        animator?.animate(value: newValue)
    }
}
