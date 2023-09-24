//
//  Data+AppendMultipart.swift
//  SnapList
//
//  Created by Vlad Katsubo on 24.09.23.
//

import Foundation

extension Data {
    mutating func append(multipart name: String, value: String, boundary: String) {
        if let data = "--\(boundary)\r\n".data(using: .utf8) { self.append(data) }
        if let data = "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8) { self.append(data) }
        if let data = "\(value)\r\n".data(using: .utf8) { self.append(data) }
    }
    
    mutating func append(multipart name: String, filename: String, type: String, data: Data, boundary: String) {
        if let data = "--\(boundary)\r\n".data(using: .utf8) { self.append(data) }
        if let data = "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8) { self.append(data) }
        if let data = "Content-Type: \(type)\r\n\r\n".data(using: .utf8) { self.append(data) }
        self.append(data)
        if let data = "\r\n".data(using: .utf8) { self.append(data) }
    }
}
