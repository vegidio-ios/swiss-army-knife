//
//  File.swift
//  
//
//  Created by vegidio on 2020-04-28.
//

import Foundation
import RxSwift
import SAKNetwork

class CountriesService: RestService<RxSwiftResponse>
{
    private let baseUrl = "https://restcountries.eu/rest/v2"

    func getCountryBy(countryCode: String) -> Single<Country>
    {
        let url = "\(baseUrl)/alpha/\(countryCode)"
        return sendRequest(.get, url)
    }
}
