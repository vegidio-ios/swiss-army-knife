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

public protocol Initializable {
    init()
}

open class RestFactory<R> {
    internal var cache: Storage<String, Data>?
    public var headers = HTTPHeaders()
    public var cacheConfig: CacheConfig?
    public var encoder = JSONEncoder()
    public var decoder = JSONDecoder()

    public init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601Complete
    }

    public func apply(closure: (RestFactory) -> Void) -> Self {
        closure(self)
        return self
    }

    public func create<T: Initializable>(clazz _: T.Type) -> T {
        // Setting the cache
        if let (size, time, unit) = cacheConfig {
            let seconds = TimeInterval(time * unit.rawValue)
            let disk = DiskConfig(name: "RestFactory", expiry: .seconds(seconds), maxSize: size)
            let memory = MemoryConfig(expiry: .seconds(seconds))
            cache = try? Storage(diskConfig: disk, memoryConfig: memory, transformer: TransformerFactory.forData())
        }

        // Setting the default headers
        defaultHeaders()

        return T()
    }

    // MARK: - Private Functions

    private func defaultHeaders() {
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
