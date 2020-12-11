//
//  String+Crypto.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2020-04-26.
//  Copyright © 2020 vinicius.io - All rights reserved.
//

import Foundation

public enum TimeUnit: Int {
    case second = 1
    case minute = 60
    case hour = 3_600
    case day = 86_400
    case week = 604_800
    case month = 2_592_000
    case year = 31_536_000

    func toSeconds(value: Int) -> Int {
        rawValue * value
    }
}