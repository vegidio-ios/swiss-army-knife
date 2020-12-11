//
//  RestServiceRxSwiftTest.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2020-04-25.
//  Copyright © 2020 vinicius.io - All rights reserved.
//

import RxBlocking
import RxSwift
import SAKNetwork
import XCTest

internal final class RestServiceRxSwiftTest: XCTestCase {
    private let service: CountriesRxSwiftService = {
        let restFactory = RestFactory().apply {
            let size10Mb: UInt = 10 * 1_024 * 1_024
            $0.cacheConfig = CacheConfig(size10Mb, 1, .day)
        }

        return restFactory.create(clazz: CountriesRxSwiftService.self)
    }()

    func testOKResponse() {
        let observable = service.getCountryBy(countryCode: "BR")
        let country = try! observable.toBlocking(timeout: TimeInterval(5)).single()
        XCTAssertEqual(country.name, "Brazil")
    }
}