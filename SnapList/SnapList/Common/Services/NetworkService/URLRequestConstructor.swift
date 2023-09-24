//
//  URLRequestConstructor.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import Foundation

struct URLRequestConstructor {
    static let baseURL = "https://junior.balinasoft.com/api/v2"
    
    enum Endpoint {
        case photoType(page: Int)
        
        var path: String {
            switch self {
            case .photoType: return "/photo/type"
            }
        }
        
        var queryItems: [URLQueryItem] {
            switch self {
            case .photoType(let page): return [URLQueryItem(name: "page", value: "\(page)")]
            }
        }
    }
    
    static func url(for endpoint: Endpoint) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path += endpoint.path
        components?.queryItems = endpoint.queryItems
        return components?.url
    }
}
