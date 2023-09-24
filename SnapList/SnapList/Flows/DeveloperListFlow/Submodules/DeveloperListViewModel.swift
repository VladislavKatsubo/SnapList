//
//  DeveloperListViewModel.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//


import UIKit

protocol DeveloperListViewModelProtocol {
    var onStateChange: ((DeveloperListResources.State) -> Void)? { get set }
    
    func launch()
    func loadMoreElements()
    func takeSnapshot(with: DeveloperListTableViewCell.Model)
    func sendDataToServer(with image: UIImage)
}

final class DeveloperListViewModel: DeveloperListViewModelProtocol {
    
    typealias Constants = DeveloperListResources.Constants.Mocks
    
    private let networkManager: NetworkManagerProtocol
    private let imageManager: ImageManagerProtocol
    private let handlers: DeveloperListResources.Handlers
    
    var onStateChange: ((DeveloperListResources.State) -> Void)?
    
    private var models: [DeveloperListTableViewCell.Model] = []
    private var currentPage = 0
    private var maxPage = 0
    private var currentModel: DeveloperListTableViewCell.Model?
    
    // MARK: - Init
    init(
        handlers: DeveloperListResources.Handlers,
        networkManager: NetworkManagerProtocol,
        imageManager: ImageManagerProtocol
    ) {
        self.handlers = handlers
        self.networkManager = networkManager
        self.imageManager = imageManager
    }
    
    // MARK: - Public methods
    func launch() {
        setupModels()
    }
    
    func loadMoreElements() {
        self.currentPage += 1
        
        guard currentPage <= maxPage else { return }
        
        let url = URLRequestConstructor.url(for: .photoType(page: self.currentPage))
        
        networkManager.fetchData(url: url, expecting: ListResponse.self) { result in
            switch result {
            case .success(let apiResponse):
                self.convertApiResponseContentToTableViewCellModels(apiResponse)
                DispatchQueue.main.async {
                    self.onStateChange?(.onLoadMoreElements(self.models))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func takeSnapshot(with model: DeveloperListTableViewCell.Model) {
        self.currentModel = model
        
        onStateChange?(.onSnap)
    }
    
    func sendDataToServer(with image: UIImage) {
        var httpBody = Data()
        let boundary = "Boundary-\(UUID().uuidString)"
        
        if let name = currentModel?.name,
           let id = currentModel?.id,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            httpBody.append(multipart: "name", value: name, boundary: boundary)
            httpBody.append(multipart: "typeId", value: "\(id)", boundary: boundary)
            httpBody.append(multipart: "photo", filename: "\(name).jpg", type: "image/jpeg", data: imageData, boundary: boundary)
        }
        
        if let boundaryAsData = "--\(boundary)--\r\n".data(using: .utf8) {
            httpBody.append(boundaryAsData) }
        
        let headers = ["Content-Type": "multipart/form-data; boundary=\(boundary)"]

        guard let request = URLRequestConstructor.request(for: .photo, httpMethod: .post, httpBody: httpBody, headers: headers) else { return }
        
        networkManager.postData(request: request, body: httpBody, expecting: PhotoUploadResponse.self) { result in
            switch result {
            case .success(let data):
                print("Successfully uploaded image: \(data)")
            case .failure(let error):
                print("Error uploading image: \(error)")
            }
        }?.resume()
    }
}

private extension DeveloperListViewModel {
    // MARK: - Private methods
    func setupModels() {
        initialTableViewSetup()
    }
    
    func initialTableViewSetup() {
        let url = URLRequestConstructor.url(for: .photoType(page: .zero))
        
        networkManager.fetchData(url: url, expecting: ListResponse.self) { result in
            switch result {
            case .success(let apiResponse):
                self.convertApiResponseContentToTableViewCellModels(apiResponse)
                self.maxPage = apiResponse.totalPages ?? 0
                DispatchQueue.main.async {
                    self.onStateChange?(.onInitialTableViewSetup(self.models, self.imageManager))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func convertApiResponseContentToTableViewCellModels(_ apiResponse: ListResponse?) {
        guard let tableViewData = apiResponse?.content else { return }
        
        tableViewData.forEach{
            self.models.append(
                .init(
                    id: $0.id,
                    name: $0.name,
                    imageUrlAddress: $0.image
                )
            )
        }
    }
}
