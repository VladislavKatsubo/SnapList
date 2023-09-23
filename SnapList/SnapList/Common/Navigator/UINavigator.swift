//
//  UINavigator.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

protocol UINavigatorProtocol {
    func push(_ vc: UIViewController, animated: Bool, completion: (() -> Void)?)
    func pop(animated: Bool, completion: (() -> Void)?)
    func present(_ viewController: UIViewController, insideNavigation: Bool, style: UIModalPresentationStyle, animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

class UINavigator: UINavigatorProtocol {
    private var topViewController: UIViewController? {
        var topController: UIViewController? = AppDelegate.shared.window?.rootViewController

        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }

        return topController
    }

    private var navigationController: UINavigationController? {
        return topViewController as? UINavigationController
    }

    func push(_ vc: UIViewController, animated: Bool, completion: (() -> Void)?) {
        navigationController?.pushViewController(viewController: vc, withAnimation: animated, completion: completion ?? {})
    }

    func pop(animated: Bool, completion: (() -> Void)?) {
        navigationController?.popViewController(withAnimation: animated, completion: completion ?? {})
    }

    func present(_ viewController: UIViewController, insideNavigation: Bool, style: UIModalPresentationStyle, animated: Bool) {
        let presentedViewController: UIViewController

        if !insideNavigation || viewController is UINavigationController {
            presentedViewController = viewController
        } else {
            presentedViewController = UINavigationController(rootViewController: viewController)
        }

        presentedViewController.modalPresentationStyle = style
        navigationController?.present(presentedViewController, animated: animated, completion: nil)
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        navigationController?.presentingViewController?.dismiss(animated: animated, completion: completion ?? {})
    }
}
