//
//  CountriesService.swift
//  iOS Swiss Army Knife
//
//  Created by Vinícius Egidio on 2020-04-25.
//  Copyright © 2020 vinicius.io - All rights reserved.
//

import Combine
import Foundation
import RxSwift
import SAKNetwork

private let baseUrl = "https://restcountries.eu/rest/v2"

// MARK: - Combine

internal class CountriesCombineService: RestFactory<CombineResponse> {
    func getCountryBy(countryCode: String) -> AnyPublisher<Country, Error> {
        let url = "\(baseUrl)/alpha/\(countryCode)"
        return sendRequest(.get, url)
    }
}

// MARK: - RxSwift

internal class CountriesRxSwiftService: RestFactory<RxSwiftResponse> {
    func getCountryBy(countryCode: String) -> Single<Country> {
        let url = "\(baseUrl)/alpha/\(countryCode)"
        return sendRequest(.get, url)
    }
}
