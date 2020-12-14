//
//  DecoderTest.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2020-04-25.
//  Copyright © 2020 vinicius.io - All rights reserved.
//

import SAKUtil
import XCTest

internal final class DecoderTest: XCTestCase {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601Complete
        return decoder
    }()

    func testDateWithFraction() {
        let json = """
        {
            "alpha2Code": "BR",
            "name": "Brazil",
            "capital": "Brasília",
            "lastUpdated": "1980-10-06T17:17:00.123Z"
        }
        """

        guard let data = json.data(using: .utf8) else { return }
        let country = try! decoder.decode(Country.self, from: data)
        XCTAssertNotNil(country.lastUpdated)
    }

    func testDateWithoutFraction() {
        let json = """
        {
            "alpha2Code": "BR",
            "name": "Brazil",
            "capital": "Brasília",
            "lastUpdated": "1980-10-06T17:17:00Z"
        }
        """

        guard let data = json.data(using: .utf8) else { return }
        let country = try! decoder.decode(Country.self, from: data)
        XCTAssertNotNil(country.lastUpdated)
    }
}
