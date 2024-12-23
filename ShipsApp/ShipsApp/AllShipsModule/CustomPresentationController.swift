//
//  CustomPresentationController.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 23/12/2024.
//

import UIKit

class CustomPresentationController: UIPresentationController {
    private var dimmingView: UIView?

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }
        let height = containerView.frame.height * 0.93
        return CGRect(x: 0, y: containerView.frame.height - height, width: containerView.frame.width, height: height)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let containerView = containerView else { return }

        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.addSubview(dimmingView)
        dimmingView.alpha = 0
        self.dimmingView = dimmingView
        
        UIView.animate(withDuration: 0.3) {
            dimmingView.alpha = 1
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        guard let dimmingView else { return }
        UIView.animate(withDuration: 0.3) {
            dimmingView.alpha = 0
        }
    }
}
