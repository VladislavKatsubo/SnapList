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
}

final class DeveloperListViewModel: DeveloperListViewModelProtocol {

    typealias Constants = DeveloperListResources.Constants.Mocks

    private let handlers: DeveloperListResources.Handlers

    var onStateChange: ((DeveloperListResources.State) -> Void)?

    // MARK: - Init
    init(handlers: DeveloperListResources.Handlers) {
        self.handlers = handlers
    }

    // MARK: - Public methods
    func launch() {
        setupModels()
    }
}

private extension DeveloperListViewModel {
    // MARK: - Private methods
    func setupModels() {

    }
}
