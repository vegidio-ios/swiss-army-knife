//
//  RestFactory.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2020-04-25.
//  Copyright © 2020 vinicius.io - All rights reserved.
//

import Alamofire
import Cache
import Foundation
import SAKUtil

public typealias CacheConfig = (UInt, Int, TimeUnit)

public class RestFactory
{
    public var headers = HTTPHeaders()
    public var cacheConfig: CacheConfig?
    internal var cache: Storage<String, Data>?

    public init() {}

    public func apply(closure: (RestFactory) -> Void) -> Self
    {
        closure(self)
        return self
    }

    public func create<R, T: RestService<R>>(clazz: T.Type) -> T
    {
        // Setting the cache
        if let (size, time, unit) = cacheConfig {
            let seconds = TimeInterval(time * unit.rawValue)
            let disk = DiskConfig(name: "RestFactory", expiry: .seconds(seconds), maxSize: size)
            let memory = MemoryConfig(expiry: .seconds(seconds))
            cache = try? Storage(diskConfig: disk, memoryConfig: memory, transformer: TransformerFactory.forData())
        }

        // Setting the default headers
        defaultHeaders()

        return T(factory: self)
    }

    // MARK: - Private Functions

    private func defaultHeaders()
    {
        headers["Content-Type"] = "application/json"
    }

    // MARK: - Internal Functions

    internal func createRequest(_ method: HTTPMethod, _ url: String, _ parameters: Parameters?) -> (DataRequest, String)
    {
        let key = "\(method)-\(url)-\(parameters?.description ?? "")"
        let request = AF.request(url, method: method, parameters: parameters, headers: headers)
        return (request, key.sha256())
    }
}