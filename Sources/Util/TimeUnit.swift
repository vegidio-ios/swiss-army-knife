//
//  String+Crypto.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2020-04-26.
//  Copyright © 2020 vinicius.io - All rights reserved.
//

import Foundation

public enum TimeUnit: Int
{
    case second = 1, minute = 60, hour = 3_600, day = 86_400, week = 604_800, month = 2_592_000, year = 31_536_000
    
    func toSeconds(value: Int) -> Int {
        self.rawValue * value
    }
}
