//
//  ServiceFactory.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import Foundation

final class ServiceFactory {
    static func createNetworkManager() -> NetworkManagerProtocol {
        let urlSession = URLSession(configuration: .default)
        return NetworkManager(session: urlSession)
    }

    static func createImageManager() -> ImageManagerProtocol {
        let networkManager = createNetworkManager()
        return ImageManager(networkManager: networkManager)
    }
}
