//
//  NetworkManager.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void)
    func fetchData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask?
    func postData<T: Decodable>(request: URLRequest, body: Data, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask?
}

enum NetworkError: Error {
    case invalidUrl
    case invalidData
    case invalidJSONData
}

struct NetworkManager: NetworkManagerProtocol {
    
    internal var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = url else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NetworkError.invalidData))
                }
                return
            }
            
            do {
                let _ = try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                print("Received invalid JSON data for \(url)")
                completion(.failure(NetworkError.invalidJSONData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(expecting, from: data)
                completion(.success(result))
            } catch {
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Error \(error.localizedDescription) for url: \(url) with data: \(dataString)")
                }
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
        guard let url = url else {
            completion(.failure(NetworkError.invalidUrl))
            return nil
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NetworkError.invalidData))
                }
                return
            }
            
            completion(.success(data))
        }
        task.resume()
        return task
    }
    
    func postData<T: Decodable>(request: URLRequest, body: Data, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? {
        var request = request
        request.httpBody = body
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }
        
        task.resume()
        return task
    }
    
}
