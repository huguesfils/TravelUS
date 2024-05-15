//
//  TranslateResponse.swift
//  TravelUS
//
//  Created by Hugues Fils on 15/05/2024.
//

import Foundation

struct TranslationResponse: Decodable {
    var data: TranslationData?
}

struct TranslationData: Decodable {
    var translations: [Translations]
}

struct Translations: Decodable {
    var translatedText: String
}

extension TranslationResponse {
    func toDomain() -> String {
        return data?.translations.first?.translatedText ?? ""
    }
}
