//
//  String+Crypto.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2019-12-01.
//  Copyright © 2019 vinicius.io - All rights reserved.
//

import CryptoKit
import Foundation

extension String
{
    /// Returns a SHA256 hash of a given string
    public func sha256() -> String
    {
        var hash = ""

        if let data = self.data(using: .utf8) {
            let digest = SHA256.hash(data: data)
            let bytes = Array(digest.makeIterator())
            hash = bytes.map { String(format: "%02X", $0) }.joined()
        }

        return hash
    }
}
