//
//  RestService.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2020-04-28.
//  Copyright © 2020 vinicius.io - All rights reserved.
//

import Foundation

public enum RestError: Error
{
    case invalidUrl, unknown(Error)
}

open class RestService<R>
{
    internal var rest: RestFactory!
    
    public required init(factory: RestFactory)
    {
        self.rest = factory
    }
}
