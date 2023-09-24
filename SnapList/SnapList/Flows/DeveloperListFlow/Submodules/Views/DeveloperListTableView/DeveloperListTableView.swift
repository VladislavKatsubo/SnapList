//
//  DeveloperListTableView.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

final class DeveloperListTableView: SLView {

    private enum Constants {
        static let rowHeight: CGFloat = 92.0
        static let preLoadingThreshold: CGFloat = 100.0
    }
    
    private let tableView = SLTableView(style: .plain)
    private var imageManager: ImageManagerProtocol?

    var models: [DeveloperListTableViewCell.Model] = []
    
    private var isLoading = false
    var onLoadMoreElements: (() -> Void)?
    var onTap: ((DeveloperListTableViewCell.Model) -> Void)?

    // MARK: - Lifecycle
    override func didLoad() {
        setupItems()
    }

    // MARK: - Configure
    func configure(with models: [DeveloperListTableViewCell.Model], imageManager: ImageManagerProtocol) {
        self.models = models
        self.imageManager = imageManager
        self.tableView.reloadData()
    }
    
    // MARK: - Public methods
    func addMoreElements(with models: [DeveloperListTableViewCell.Model]) {
        isLoading = false
        
        self.models = models
        
        self.tableView.reloadData()
    }
}

private extension DeveloperListTableView {
    // MARK: - Private methods
    func setupItems() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerCells([DeveloperListTableViewCell.self])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = .systemGroupedBackground


        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension DeveloperListTableView: UITableViewDataSource, UITableViewDelegate {
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DeveloperListTableViewCell.reuseID,
                for: indexPath
            ) as? DeveloperListTableViewCell,
            let imageManager = imageManager else {
            
            return .init()
        }
        
        let model = self.models[indexPath.row]
        let viewModel = DeveloperListTableViewCellViewModel(
            model: model,
            imageManager: imageManager
        )

        cell.configure(with: viewModel)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = models[indexPath.row]
        onTap?(cellModel)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }
}

extension DeveloperListTableView {
    // MARK: - Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        
        guard contentHeight > scrollViewHeight else { return }
        
        let isCloseToBottom = offset > (contentHeight - scrollViewHeight - Constants.preLoadingThreshold)
        
        if !isLoading && isCloseToBottom {
            isLoading = true
            onLoadMoreElements?()
        }
    }
}
