//
//  TranslateRepository.swift
//  TravelUS
//
//  Created by Hugues Fils on 15/05/2024.
//

import Foundation

protocol TranslationRepository {
    func translate(text: String, from sourceLang: Language, to targetLang: Language) async -> Result<TranslationResponse, DomainError>
}

struct DefaultTranslationRepository: TranslationRepository {
    
    let httpClient: HTTPClient
    let baseUrl: String
    
    func translate(text: String, from sourceLang: Language, to targetLang: Language) async -> Result<TranslationResponse, DomainError> {
        let pathType = TranslationHttpPathType(baseUrl: baseUrl, text: text, sourceLang: sourceLang.rawValue, targetLang: targetLang.rawValue)
        return await httpClient.request(TranslationResponse.self, pathType: pathType).mapError { $0.toDomain() }
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
    
    var bodyParameters: [String : Any]? {
        let params = ["q": text, "target": targetLang, "format": "text", "source": sourceLang, "key": APIKeys.translationApiKey]
        print("Request body parameters: \(params)")
        return params
    }
    
    var urlParameters: [String : Any]? {
        return nil
    }
}
