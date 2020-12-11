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

public extension RestService where R == CombineResponse {
    func sendRequest(_ method: HTTPMethod, _ url: String,
                     parameters: Parameters? = nil) -> AnyPublisher<Void, RestError>
    {
        let (request, _) = rest.createRequest(method, url, parameters)

        return Future<Void, RestError> { promise in
            request.responseData { res in
                if let error = res.error {
                    promise(.failure(.unknown(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }

    func sendRequest<T: Codable>(_ method: HTTPMethod, _ url: String, parameters: Parameters? = nil)
        -> AnyPublisher<T, RestError>
    {
        let (request, key) = rest.createRequest(method, url, parameters)

        return Future<T, RestError> { promise in

            // First we clear any cached objects that already expired
            try! self.rest.cache?.removeExpiredObjects()

            if let data = try? self.rest.cache?.object(forKey: key),
               let value = try? JSONDecoder.decode(data, to: T.self)
            {
                // Then if we have a cached value for that key, we use it...
                promise(.success(value))

            } else {
                // Otherwise we send a new request to the service
                request.responseDecodable { (res: DataResponse<T, AFError>) in
                    if let error = res.error {
                        promise(.failure(.unknown(error)))

                    } else if let value = res.value {
                        // Saving the result in the cache
                        if method == .get, let data = try? JSONEncoder().encode(value) {
                            try? self.rest.cache?.setObject(data, forKey: key)
                        }

                        promise(.success(value))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}