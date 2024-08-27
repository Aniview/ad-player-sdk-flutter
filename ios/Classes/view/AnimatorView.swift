//
//  AnimatorView.swift
//  adplayer_flutter_plugin
//
//  Created by Pavel Yevtukhov on 12.01.2024.
//

import UIKit

// this class is needed due to issues during the native view animation on Flutter side
final class AnimatorView: UIView {
    var displayLink: CADisplayLink?
    var heightContr: NSLayoutConstraint!
    var prevValue: CGFloat?
    let onValueChange: (CGFloat) -> Void

    init(frame: CGRect, onValueChange: @escaping (CGFloat) -> Void) {
        self.onValueChange = onValueChange
        super.init(frame: frame)

        heightContr = heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            heightContr,
            widthAnchor.constraint(equalToConstant: 1)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animate(value: CGFloat) {
        guard prevValue != value else { return }

        startUpdates()
        heightContr.constant = value
        prevValue = value
        setNeedsLayout()
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        } completion: { complete in
            self.onValueChange(value)
            self.displayLink?.invalidate()
        }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        if window == nil {
            displayLink?.invalidate()
        }
    }

    private func startUpdates() {
        let displayLink = CADisplayLink(target: self, selector: #selector(onUpdate))
        displayLink.add(to: .current, forMode: .common)
        self.displayLink?.invalidate()
        self.displayLink = displayLink
    }

    @objc
    private func onUpdate() {
        guard let value = layer.presentation()?.bounds.height else {
            return
        }
        onValueChange(value)
    }

    deinit {
        displayLink?.invalidate()
    }
}

