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

extension RestService where R == RxSwiftResponse
{
    public func sendRequest(_ method: HTTPMethod, _ uri: String, parameters: Any? = nil) -> Completable
    {
        guard let url = URL(string: uri) else {
            return Completable.error(RestError.invalidUrl)
        }

        let (request, _) = rest.createRequest(method, url, parameters)

        return Completable.create { observer in
            let req = AF.request(request).responseData { res in
                if let error = res.error {
                    observer(.error(RestError.unknown(error)))
                } else {
                    observer(.completed)
                }
            }
            
            return Disposables.create {
                req.cancel()
            }
        }
    }
    
    public func sendRequest<T: Codable>(_ method: HTTPMethod, _ uri: String, parameters: Any? = nil) -> Single<T>
    {
        guard let url = URL(string: uri) else {
            return Single.error(RestError.invalidUrl)
        }

        let (request, key) = rest.createRequest(method, url, parameters)

        return Single<T>.create { observer in

            // First we clear any cached objects that already expired
            try! self.rest.cache?.removeExpiredObjects()

            // Then if we have a cached value for that key, we use it...
            if let data = try? self.rest.cache?.object(forKey: key),
                let value = try? JSONDecoder.decode(data, to: T.self)
            {
                observer(.success(value))
                return Disposables.create()

            // Otherwise we send a new request to the service
            } else {
                let req = AF.request(request).responseDecodable { (res: DataResponse<T, AFError>) in
                    if let error = res.error {
                        observer(.error(RestError.unknown(error)))
                        
                    } else if let value = res.value {
                        // Saving the result in the cache
                        if method == .get, let data = try? JSONEncoder().encode(value) {
                            try? self.rest.cache?.setObject(data, forKey: key)
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
