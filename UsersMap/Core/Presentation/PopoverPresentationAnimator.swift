//
//  PopoverPresentationAnimator.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/24/21.
//

import UIKit

final class PopoverPresentationAnimator: NSObject {

    private let isPresentation: Bool

    init(isPresentation: Bool) {
        self.isPresentation = isPresentation
        super.init()
    }
}

extension PopoverPresentationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        guard let controller = transitionContext.viewController(forKey: key) else { return }

        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }

        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        dismissedFrame.origin.y = transitionContext.containerView.frame.size.height

        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame

        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame

        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: {
                controller.view.frame = finalFrame
            }) { finished in
                transitionContext.completeTransition(finished)
        }
    }
}

