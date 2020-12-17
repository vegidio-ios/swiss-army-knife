//
//  Resolver.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2020-12-17.
//  Copyright © 2020 vinicius.io - All rights reserved.
//

import Foundation

public protocol Resolver {
    func resolve<T>(_ type: T.Type, name: String?) -> T?
}