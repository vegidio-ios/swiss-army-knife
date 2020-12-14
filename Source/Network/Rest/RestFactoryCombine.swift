//
//  RestServiceCombine.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2020-04-28.
//  Copyright © 2020 vinicius.io - All rights reserved.
//

import Alamofire
import Combine
import Foundation

public typealias CombineResponse = AnyPublisher<Any, Error>

public extension RestFactory where R == CombineResponse {
    func sendRequest(_ method: HTTPMethod, _ url: String, parameters: Parameters? = nil) -> AnyPublisher<Void, Error> {
        let (request, _) = createRequest(method, url, parameters)

        return Future<Void, Error> { promise in
            request.responseData { res in
                if let error = res.error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }

    func sendRequest<T: Codable>(_ method: HTTPMethod, _ url: String,
                                 parameters: Parameters? = nil) -> AnyPublisher<T, Error>
    {
        let (request, key) = createRequest(method, url, parameters)

        return Future<T, Error> { promise in

            // First we clear any cached objects that already expired
            try! self.cache?.removeExpiredObjects()

            if let data = try? self.cache?.object(forKey: key),
               let value = try? self.decoder.decode(T.self, from: data)
            {
                // Then if we have a cached value for that key, we use it...
                promise(.success(value))

            } else {
                // Otherwise we send a new request to the service
                request.responseDecodable(decoder: self.decoder) { (res: DataResponse<T, AFError>) in
                    if let error = res.error {
                        promise(.failure(error))

                    } else if let value = res.value {
                        // Saving the result in the cache
                        if method == .get, let data = try? self.encoder.encode(value) {
                            try? self.cache?.setObject(data, forKey: key)
                        }

                        promise(.success(value))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}