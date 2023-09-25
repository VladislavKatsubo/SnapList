//
//  DeveloperListFlow.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

protocol DeveloperListFlowProtocol {
    
}

final class DeveloperListFlow: DeveloperListFlowProtocol {
    
    private let navigator: DeveloperListFlowNavigatorProtocol
        
    // MARK: - Init
    init(navigator: DeveloperListFlowNavigatorProtocol) {
        self.navigator = navigator
    }
    
    // MARK: - Public methods
    func makeDeveloperListFlow() -> UIViewController {
        let handlers = DeveloperListResources.Handlers(
            
        )

        let vc = DeveloperListFactory().createController(handlers: handlers)
        return UINavigationController(rootViewController: vc)
    }
}

private extension DeveloperListFlow {
    // MARK: - Private methods
    
}
