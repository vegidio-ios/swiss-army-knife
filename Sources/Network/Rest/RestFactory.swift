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
    internal var cache: Storage<Data>?
    
    public init() {}
    
    public func apply(closure: (RestFactory) -> ()) -> Self
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
        
        return T.init(factory: self)
    }

    // MARK: - Private Functions
    private func defaultHeaders()
    {
        headers["Content-Type"] = "application/json"
    }
    
    // MARK: - Internal Functions
    internal func createRequest(_ method: HTTPMethod, _ url: URL, _ parameters: Any? = nil) -> (URLRequest, String)
    {
        var request = URLRequest(url: url)
        var key = "\(method)-\(url)"

        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers.dictionary

        if let params = parameters as? [String: AnyObject] {
            key = "\(key)-\(params.description)"
            request = (method == .get) ? try! URLEncoding.default.encode(request, with: params) :
                try! JSONEncoding.default.encode(request, with: params)

        } else if let params = parameters as? [[String: AnyObject]] {
            key = "\(key)-\(params.description)"
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        }

        return (request, key.sha256())
    }
}
