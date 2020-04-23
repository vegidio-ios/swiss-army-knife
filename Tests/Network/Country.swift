//
//  File.swift
//  
//
//  Created by vegidio on 2020-04-28.
//

import Foundation

class Country: Codable
{
    var name: String?
    var alpha2Code: String?
    var capital: String?
    
    enum CodingKeys: String, CodingKey
    {
        case name
        case alpha2Code
        case capital
    }

    required init(from decoder: Decoder) throws
    {
        let fields = try decoder.container(keyedBy: CodingKeys.self)

        name = try fields.decode(String.self, forKey: .name)
        alpha2Code = try fields.decode(String.self, forKey: .alpha2Code)
        capital = try fields.decode(String.self, forKey: .capital)
    }
}
