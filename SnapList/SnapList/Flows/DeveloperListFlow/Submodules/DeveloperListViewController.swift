//
//  DeveloperListViewController.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

final class DeveloperListViewController: UIViewController {

    typealias Constants = DeveloperListResources.Constants.UI

    private var viewModel: DeveloperListViewModelProtocol?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupItems()
        setupViewModel()
        
        self.view.backgroundColor = .red
    }

    // MARK: - Configure
    func configure(viewModel: DeveloperListViewModelProtocol) {
        self.viewModel = viewModel
    }
}

private extension DeveloperListViewController {
    // MARK: - Private methods
    func setupViewModel() {
        viewModel?.onStateChange = { [weak self] state in
            guard let self = self else { return }

            switch state {

            }
        }
        viewModel?.launch()
    }

    func setupItems() {
        view.backgroundColor = .systemBackground

    }
}
