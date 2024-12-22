//
//  NetworkService.swift
//  ShipsApp
//
//  Created by Dzmitry Kopats on 20/12/2024.
//

import Foundation
import RxSwift

protocol NetworkService {
    func request<T: Decodable>(endpoint: Endpoint) -> Observable<T>
}

final class AppNetworkManager: NetworkService {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let requestBuilder: RequestBuilder
    
    init(
        timeout: TimeInterval = 5,
        decoder: JSONDecoder = JSONDecoder(),
        requestBuilder: RequestBuilder = RequestBuilderImplementation()
    ) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        self.session = URLSession(configuration: configuration)
        self.decoder = decoder
        self.requestBuilder = requestBuilder
    }
    
    func request<T: Decodable>(endpoint: Endpoint) -> Observable<T> {
        do {
            let urlRequest = try requestBuilder.build(for: endpoint)
            
            return session.rx.data(request: urlRequest)
                .map { data in
                    do {
                        let decodedData = try self.decoder.decode(T.self, from: data)
                        return decodedData
                    } catch {
                        throw NetworkError.decodingError
                    }
                }
                .catch { error in
                    return Observable.error(error)
                }
        } catch {
            return Observable.error(error)
        }
    }
}
