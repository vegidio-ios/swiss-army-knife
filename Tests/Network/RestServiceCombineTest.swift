//
//  RestServiceCombineTest.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2020-04-25.
//  Copyright © 2020 vinicius.io - All rights reserved.
//

import Combine
import CombineExpectations
import SAKNetwork
import XCTest

internal final class RestFactoryCombineTest: XCTestCase {
    private let service = CountriesCombineService().apply {
        let size10Mb: UInt = 10 * 1_024 * 1_024
        $0.cacheConfig = CacheConfig(size10Mb, 1, .day)
    }

    func testOKResponse() {
        let recorder = service.getCountryBy(countryCode: "BR").record()
        let country = try! wait(for: recorder.next(), timeout: TimeInterval(5), description: "")
        XCTAssertEqual(country.name, "Brazil")
    }
}