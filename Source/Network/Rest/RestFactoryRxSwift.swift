//
//  RestServiceRxSwift.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2020-04-28.
//  Copyright © 2020 vinicius.io - All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

public typealias RxSwiftResponse = Observable<Any>

public extension RestFactory where R == RxSwiftResponse {
    func sendRequest(_ method: HTTPMethod, _ url: String, parameters: Parameters? = nil) -> Completable {
        let (request, _) = createRequest(method, url, parameters)

        return Completable.create { observer in
            let req = request.responseData { res in
                if let error = res.error {
                    observer(.error(error))
                } else {
                    observer(.completed)
                }
            }

            return Disposables.create {
                req.cancel()
            }
        }
    }

    func sendRequest<T: Codable>(_ method: HTTPMethod, _ url: String, parameters: Parameters? = nil) -> Single<T> {
        let (request, key) = createRequest(method, url, parameters)

        return Single<T>.create { observer in

            // First we clear any cached objects that already expired
            try! self.cache?.removeExpiredObjects()

            // Then if we have a cached value for that key, we use it...
            if let data = try? self.cache?.object(forKey: key),
               let value = try? JSONDecoder.decode(data, to: T.self)
            {
                observer(.success(value))
                return Disposables.create()

                // Otherwise we send a new request to the service
            } else {
                let req = request.responseDecodable { (res: DataResponse<T, AFError>) in
                    if let error = res.error {
                        observer(.failure(error))

                    } else if let value = res.value {
                        // Saving the result in the cache
                        if method == .get, let data = try? JSONEncoder().encode(value) {
                            try? self.cache?.setObject(data, forKey: key)
                        }

                        observer(.success(value))
                    }
                }

                return Disposables.create {
                    req.cancel()
                }
            }
        }
    }
}