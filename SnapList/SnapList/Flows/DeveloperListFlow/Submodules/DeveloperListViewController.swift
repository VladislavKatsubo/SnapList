//
//  DeveloperListViewController.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

final class DeveloperListViewController: UIViewController {
    
    typealias Constants = DeveloperListResources.Constants.UI
    
    private let loadingView = LoadingIndicatorView()
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
                self.loadingView.isHidden = true
                self.loadingView.removeFromSuperview()
            case .onLoadMoreElements(let models):
                self.tableView.addMoreElements(with: models)
            case .onSnap:
                self.showCamera()
            case .onShowUploadCompletionAlert(let message):
                self.showUploadCompletionAlert(with: message)
            }
        }
        viewModel?.launch()
    }
    
    func setupItems() {
        view.backgroundColor = .systemBackground
        self.title = Constants.title
        
        setupTableView()
        setupLoadingView()
    }
    
    func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
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
    
    func showCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func showUploadCompletionAlert(with message: String) {
        let alert = UIAlertController(title: Constants.alertTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.okActionTitle, style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension DeveloperListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        viewModel?.sendDataToServer(with: image)
        
        dismiss(animated: true)
    }
}
