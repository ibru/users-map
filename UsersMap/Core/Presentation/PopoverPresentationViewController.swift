//
//  PopoverPresentationViewController.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/24/21.
//

import UIKit

class PopoverPresentationViewController: UIPresentationController {

    fileprivate lazy var dimmingView: UIView! = {
        let dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        dimmingView.alpha = 0.0

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)

        return dimmingView
    }()

    var shouldTapAnywhereToHide = true

    var insets: UIEdgeInsets = .zero

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        containerView.insertSubview(dimmingView, at: 0)
        NSLayoutConstraint.activate([
            dimmingView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            dimmingView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        return super.frameOfPresentedViewInContainerView.inset(by: insets)
    }
}

private extension PopoverPresentationViewController {
    @objc dynamic func handleTap(recognizer: UITapGestureRecognizer) {
        if shouldTapAnywhereToHide {
            presentingViewController.dismiss(animated: true)
        }
    }
}

