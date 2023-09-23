//
//  DeveloperListFactory.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

final class DeveloperListFactory {
    func createController(handlers: DeveloperListResources.Handlers) -> UIViewController {
        let viewModel = DeveloperListViewModel(handlers: handlers)
        let viewController = DeveloperListViewController()

        viewController.configure(viewModel: viewModel)

        return viewController
    }
}
