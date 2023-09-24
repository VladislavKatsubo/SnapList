//
//  DeveloperListViewController.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

final class DeveloperListViewController: UIViewController {

    typealias Constants = DeveloperListResources.Constants.UI

    private let tableView = DeveloperListTableView()
    
    private var viewModel: DeveloperListViewModelProtocol?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupItems()
        setupViewModel()
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
            case .onInitialTableViewSetup(let models, let imageManager):
                self.tableView.configure(with: models, imageManager: imageManager)
            case .onLoadMoreElements(let models):
                self.tableView.addMoreElements(with: models)
            case .onSnap:
                print("Snapped")
            }
        }
        viewModel?.launch()
    }

    func setupItems() {
        view.backgroundColor = .systemBackground
        self.title = Constants.title
        
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.onTap = { [weak self] cellModel in
            self?.viewModel?.takeSnapshot(with: cellModel)
        }
        
        tableView.onLoadMoreElements = { [weak self] in
            self?.viewModel?.loadMoreElements()
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
