//
//  RequestBuilder.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 20/12/2024.
//

import Foundation

protocol RequestBuilder {
    func build(for endpoint: Endpoint) throws -> URLRequest
}

final class RequestBuilderImplementation: RequestBuilder {
    func build(for endpoint: Endpoint) throws -> URLRequest {
        guard let url = URL(string: endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        
        if let parameters = endpoint.parameters {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        if let headers = endpoint.headers {
            headers.forEach { key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return urlRequest
    }
}
