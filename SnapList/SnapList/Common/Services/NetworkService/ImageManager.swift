//
//  ImageManager.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

protocol ImageManagerProtocol {
    func fetchImageData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask?
    func cancelDataTask(_ dataTask: URLSessionDataTask?)
}

final class ImageManager: ImageManagerProtocol {

    private var networkManager: NetworkManagerProtocol
    private var imageCache = NSCache<NSString, NSData>()

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchImageData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
        guard let url = url else {
            completion(.failure(NetworkError.invalidUrl))
            return nil
        }

        if let cachedImageData = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(.success(cachedImageData as Data))
            return nil
        }

        let dataTask = networkManager.fetchData(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.imageCache.setObject(data as NSData, forKey: url.absoluteString as NSString)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return dataTask
    }

    func cancelDataTask(_ dataTask: URLSessionDataTask?) {
        dataTask?.cancel()
    }
}


