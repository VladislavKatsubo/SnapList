//
//  MainFlow.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

final class MainFlow {
    private(set) var navigator: MainFlowNavigatorProtocol
    private var developerListFlow: DeveloperListFlow?

    init(navigator: MainFlowNavigatorProtocol) {
        self.navigator = navigator
    }

    // MARK: - Public methods
    func makeStartFlow(window: UIWindow?) -> Bool {
        guard let window = window else { return false }

        window.rootViewController = makeDeveloperListFlow()
        window.makeKeyAndVisible()

        return true
    }
}

extension MainFlow {
    func makeDeveloperListFlow() -> UIViewController {
        developerListFlow = DeveloperListFlow(navigator: DeveloperListFlowNavigator())
        guard let vc = developerListFlow?.makeDeveloperListFlow() else {
            return .init()
        }

        return vc
    }
}
