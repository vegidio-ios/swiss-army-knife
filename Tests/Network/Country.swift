//
//  Country.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2020-04-25.
//  Copyright © 2020 vinicius.io - All rights reserved.
//

import Foundation

internal class Country: Codable {
    var name: String?
    var alpha2Code: String?
    var capital: String?

    enum CodingKeys: String, CodingKey {
        case name
        case alpha2Code
        case capital
    }

    required init(from decoder: Decoder) throws {
        let fields = try decoder.container(keyedBy: CodingKeys.self)

        name = try fields.decodeIfPresent(String.self, forKey: .name)
        alpha2Code = try fields.decodeIfPresent(String.self, forKey: .alpha2Code)
        capital = try fields.decodeIfPresent(String.self, forKey: .capital)
    }
}