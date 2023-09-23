//
//  UINavigationController+Animated.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

extension UINavigationController {
    func popViewController(withAnimation animation: Bool, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animation)
        CATransaction.commit()
        if !animation {
            completion()
        }
    }

    func pushViewController(viewController: UIViewController, withAnimation animation: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animation)
        CATransaction.commit()

        if !animation {
            completion?()
        }
    }
}
