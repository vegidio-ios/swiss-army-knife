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

internal class CountriesCombineService: RestService<CombineResponse>
{
    func getCountryBy(countryCode: String) -> AnyPublisher<Country, RestError>
    {
        let url = "\(baseUrl)/alpha/\(countryCode)"
        return sendRequest(.get, url)
    }
}

internal class CountriesRxSwiftService: RestService<RxSwiftResponse>
{
    func getCountryBy(countryCode: String) -> Single<Country>
    {
        let url = "\(baseUrl)/alpha/\(countryCode)"
        return sendRequest(.get, url)
    }
}