//
//  DeveloperListViewModel.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//


import Foundation

protocol DeveloperListViewModelProtocol {
    var onStateChange: ((DeveloperListResources.State) -> Void)? { get set }
    
    func launch()
    func loadMoreElements()
    func takeSnapshot(with: DeveloperListTableViewCell.Model)
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
    
    func takeSnapshot(with: DeveloperListTableViewCell.Model) {
        onStateChange?(.onSnap)
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
