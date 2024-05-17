//
//  TranslationInjector.swift
//  TravelUS
//
//  Created by Hugues Fils on 15/05/2024.
//

import Foundation

struct TranslationInjector {
  static func fetchTranslationUseCase() -> FetchTranslationUseCase {
    let baseUrl = "https://translation.googleapis.com/language/translate/v2"

    let httpClient = DefaultHTTPClient()

    let repository = DefaultTranslationRepository(httpClient: httpClient, baseUrl: baseUrl)

    return DefaultFetchTranslationUseCase(repository: repository)
  }
}
