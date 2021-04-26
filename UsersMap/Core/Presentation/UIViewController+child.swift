//
//  UIViewController+child.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/26/21.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController, to view: UIView) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else { return }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
