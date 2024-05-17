//
//  CurrencyInjector.swift
//  TravelUS
//
//  Created by Hugues Fils on 13/05/2024.
//

import Foundation

struct CurrencyInjector {
  static func fetchCurrencyUseCase() -> FetchCurrencyUseCase {
    let baseUrl = "https://openexchangerates.org/api/latest.json"

    let httpClient = DefaultHTTPClient()

    let repository = DefaultCurrencyRepository(httpClient: httpClient, baseUrl: baseUrl)

    return DefaultFetchCurrencyUseCase(repository: repository)
  }
}
