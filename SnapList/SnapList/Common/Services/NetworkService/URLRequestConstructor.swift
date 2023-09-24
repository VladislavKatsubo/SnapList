//
//  URLRequestConstructor.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import Foundation

struct URLRequestConstructor {
    static let baseURL = "https://junior.balinasoft.com/api/v2"
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum Endpoint {
        case photo
        case photoType(page: Int)
        
        var path: String {
            switch self {
            case .photoType: return "/photo/type"
            case .photo: return "/photo"
            }
        }
        
        var queryItems: [URLQueryItem] {
            switch self {
            case .photoType(let page): return [URLQueryItem(name: "page", value: "\(page)")]
            case .photo: return []
            }
        }
    }
    
    static func url(for endpoint: Endpoint) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path += endpoint.path
        components?.queryItems = endpoint.queryItems
        return components?.url
    }
    
    static func request(
        for endpoint: Endpoint,
        httpMethod: HTTPMethod,
        httpBody: Data? = nil,
        headers: [String: String]? = nil
    ) -> URLRequest? {
        guard let url = url(for: endpoint) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody
        
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
}
