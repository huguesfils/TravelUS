//
//  TranslateRepository.swift
//  TravelUS
//
//  Created by Hugues Fils on 15/05/2024.
//

import Foundation

protocol TranslationRepository {
  func translate(text: String, from sourceLang: Language, to targetLang: Language) async -> Result<
    TranslationResponse, DomainError
  >
}

struct DefaultTranslationRepository: TranslationRepository {

  let httpClient: HTTPClient
  let baseUrl: String

  func translate(text: String, from sourceLang: Language, to targetLang: Language) async -> Result<
    TranslationResponse, DomainError
  > {
    let pathType = TranslationHttpPathType(
      baseUrl: baseUrl, text: text, sourceLang: sourceLang.rawValue, targetLang: targetLang.rawValue
    )
    print("Making network request with path: \(pathType.path)")
    return await httpClient.request(TranslationResponse.self, pathType: pathType).mapError {
      $0.toDomain()
    }
  }
}

struct TranslationHttpPathType: HTTPPathType {
  let baseUrl: String
  let text: String
  let sourceLang: String
  let targetLang: String

  var path: String {
    return baseUrl
  }

  var method: HTTPUrlMethod {
    return .post
  }

  var bodyParameters: [String: Any]? {
    return nil
  }

  var urlParameters: [String: Any]? {
    let params = [
      "q": text, "source": sourceLang, "target": targetLang, "format": "text",
      "key": APIKeys.translationApiKey,
    ]
    print("Request body parameters: \(params)")
    return params
  }

  var headers: [String: String]? {
    return nil
  }
}
