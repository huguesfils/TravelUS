//
//  FetchTranslationUseCase.swift
//  TravelUS
//
//  Created by Hugues Fils on 15/05/2024.
//

import Foundation

protocol FetchTranslationUseCase {
  func execute(text: String, from sourceLang: Language, to targetLang: Language) async -> Result<
    String, DomainError
  >
}

struct DefaultFetchTranslationUseCase: FetchTranslationUseCase {

  let repository: TranslationRepository

  func execute(text: String, from sourceLang: Language, to targetLang: Language) async -> Result<
    String, DomainError
  > {
    return await repository.translate(text: text, from: sourceLang, to: targetLang).map {
      $0.toDomain()
    }
  }
}
