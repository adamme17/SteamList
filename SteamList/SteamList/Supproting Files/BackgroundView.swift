//
//  BackgroundView.swift
//  SteamList
//
//  Created by Adam Bokun on 3.12.21.
//

import UIKit

class BackgroundView: UIView {

    init() {
        super.init(frame: .zero)
        setupLayer()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BackgroundView {
    private func setupLayer() {
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = [UIColor(rgb: 0x3d6382).cgColor, UIColor(rgb: 0x1c293a).cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.addSublayer(layer)
    }
}
