//
//  UIViewController+TransitioningDelegate.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/24/21.
//

import UIKit

extension UIViewController {
    class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

        static var `default` = TransitioningDelegate(edgeInsets: UIEdgeInsets(top: 60, left: 24, bottom: 60, right: 24))


        private static var currentTransitioningDelegate: TransitioningDelegate = .init()

        static func modal(from presentingVC: UIViewController, to presentedVC: UIViewController) -> TransitioningDelegate {

            let delegate = TransitioningDelegate(presentedContentSize: presentedVC.preferredContentSize)
            currentTransitioningDelegate = delegate

            return delegate
        }

        static func modal(with insets: UIEdgeInsets) -> TransitioningDelegate {
            return .init(edgeInsets: insets)
        }

        var insets = UIEdgeInsets.zero

        var presentedControllerPreferredSize: CGSize?

        init(edgeInsets: UIEdgeInsets = .zero) {
            self.insets = edgeInsets
        }

        convenience init(presentedContentSize: CGSize) {
            self.init()
            presentedControllerPreferredSize = presentedContentSize
        }

        func presentationController(
            forPresented presented: UIViewController,
            presenting: UIViewController?,
            source: UIViewController
        ) -> UIPresentationController? {
            let presentationController = PopoverPresentationViewController(presentedViewController: presented, presenting: presenting)
            presentationController.shouldTapAnywhereToHide = true

            if let preferredSize = presentedControllerPreferredSize {
                let widthInset = max(0, source.view.bounds.width - preferredSize.width)
                let heightInset = max(0, source.view.bounds.height - preferredSize.height)

                insets = UIEdgeInsets(top: heightInset, left: widthInset/2, bottom: 0, right: widthInset/2)
            }
            presentationController.insets = insets

            return presentationController
        }

        func animationController(
            forPresented presented: UIViewController,
            presenting: UIViewController,
            source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
            return PopoverPresentationAnimator(isPresentation: true)
        }

        func animationController(forDismissed dismissed: UIViewController)
            -> UIViewControllerAnimatedTransitioning? {
                return PopoverPresentationAnimator(isPresentation: false)
        }
    }
}
