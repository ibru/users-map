//
//  UIView+dropShaddow.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/26/21.
//

import UIKit

extension UIView {
    func makeRoundedAndShadowed(cornerRadius: CGFloat = 10) {
        let shadowLayer = CAShapeLayer()

        self.layer.cornerRadius = cornerRadius
        shadowLayer.path = UIBezierPath(
            roundedRect: self.bounds,
            cornerRadius: self.layer.cornerRadius
        ).cgPath
        shadowLayer.fillColor = self.backgroundColor?.cgColor
        shadowLayer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 1)
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 4

        self.layer.insertSublayer(shadowLayer, at: 0)
    }
}
