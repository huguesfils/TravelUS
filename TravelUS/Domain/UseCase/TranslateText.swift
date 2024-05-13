//
//  TranslateText.swift
//  TravelUS
//
//  Created by Hugues Fils on 10/05/2024.
//

struct TranslateText {
    private let translationService: TranslationService

    init(translationService: TranslationService) {
        self.translationService = translationService
    }

    func execute(text: String, from sourceLang: Language, to targetLang: Language, completion: @escaping (String?, Bool) -> Void) {
        guard !text.isEmpty else {
            completion(nil, true)
            return
        }
        translationService.getTranslation(text: text, from: sourceLang.rawValue, to: targetLang.rawValue) { response, error in
            if let translatedText = response?.data?.translations.first?.translatedText, error == nil {
                completion(translatedText, false)
            } else {
                completion(nil, true)
            }
        }
    }
}
