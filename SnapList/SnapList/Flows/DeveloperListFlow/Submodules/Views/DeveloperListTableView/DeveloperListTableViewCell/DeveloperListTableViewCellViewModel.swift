//
//  DeveloperListTableViewCellViewModel.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import Foundation

protocol DeveloperListTableViewCellViewModelProtocol {
    var onImageData: ((Data?) -> Void)? { get set }
    var onModelData: ((DeveloperListTableViewCell.Model) -> Void)? { get set }

    func launch()
    func cancelImageDownload()
}

class DeveloperListTableViewCellViewModel: DeveloperListTableViewCellViewModelProtocol {

    private var imageManager: ImageManagerProtocol?
    private var model: DeveloperListTableViewCell.Model?

    var onImageData: ((Data?) -> Void)?
    var onModelData: ((DeveloperListTableViewCell.Model) -> Void)?

    private var dataTask: URLSessionDataTask?

    // MARK: - Configure
    init(model: DeveloperListTableViewCell.Model, imageManager: ImageManagerProtocol) {
        self.model = model
        self.imageManager = imageManager
    }

    // MARK: - Public methods
    func launch() {
        guard let model = model else { return }
        
        self.setupUserInfo(with: model)
        
        guard let imageUrlAddress = model.imageUrlAddress,
              let imageURL = URL(string: imageUrlAddress) else {
            onImageData?(nil)
            return
        }
        
        self.dataTask = fetchImage(for: imageURL)
    }

    func cancelImageDownload() {
        if let task = dataTask {
            imageManager?.cancelDataTask(task)
        }
    }
}

private extension DeveloperListTableViewCellViewModel {
    // MARK: - Private methods
    func fetchImage(for url: URL?) -> URLSessionDataTask? {
        guard let url = url else { return nil }

        let dataTask = imageManager?.fetchImageData(url: url, completion: { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.onImageData?(data)
                }
            case .failure(let failure):
                if (failure as NSError).code == NSURLErrorCancelled {
                    // Prevented the wrong image from being shown by cancelling the URLSessionDataTask
                } else {
                    print("Image fetching failure", failure)
                }
            }
        })
        return dataTask
    }

    func setupUserInfo(with model: DeveloperListTableViewCell.Model) {
        onModelData?(model)
    }
}
