//
//  TargetType.swift
//  imink
//
//  Created by Jone Wang on 2020/9/5.
//

import Foundation

enum APIMethod: String {
    case post = "POST"
    case get = "GET"
    case update = "UPDATE"
    case delete = "DELETE"
    // TODO: Need more
}

enum MediaType {
    case jsonData(_ data: Encodable)
    case form(_ form: [(String, String)])
    // TODO: Need more
}

protocol APITargetType {

    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: APIMethod { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    
    var querys: [(String, String?)]? { get }
    
    var data: MediaType? { get }
}

extension APITargetType {
    var urlLRequest: URLRequest? {
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)

        if let querys = self.querys {
            urlComponents?.queryItems = querys.map { URLQueryItem(name: $0, value: $1) }
        }

        guard let url = urlComponents?.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }

        // 添加请求体
        if let data = self.data {
            request.addValue(data.contentType, forHTTPHeaderField: "Content-Type")
            switch data {
            case .jsonData(let data):
                request.httpBody = data.toJSONData()
            case .form(let form):
                let formString = form.map { "\($0)=\($1)" }.joined(separator: "&")
                request.httpBody = formString.data(using: .utf8)
            }
        }

        return request
    }
}
