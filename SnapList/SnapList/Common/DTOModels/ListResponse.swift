//
//  ListResponse.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

struct ListResponse: Decodable {
    let page: Int?
    let pageSize: Int?
    let totalPages: Int?
    let totalElements: Int?
    let content: [PhotoTypeDtoOut]?
    
    struct PhotoTypeDtoOut: Decodable {
        let id: Int?
        let name: String?
        let image: String?
    }
}
