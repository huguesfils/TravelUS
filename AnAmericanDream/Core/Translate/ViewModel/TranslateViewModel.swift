//
//  TranslateViewModel.swift
//  AnAmericanDream
//
//  Created by Hugues Fils on 05/03/2024.
//

import Foundation
import Combine

// Enumeration for supported languages, conforming to Identifiable for use in SwiftUI views
enum Language: String, CaseIterable, Identifiable {
    case french, english
    var id: Self { self } // Required for Identifiable
}

// ViewModel for handling text translation
class TranslateViewModel: ObservableObject {
    // Published properties to trigger UI updates
    @Published var frenchText = ""
    @Published var englishText = ""
    @Published var isFrenchFirst = true // Determines the initial language input
    @Published var isRotated = false // Controls the orientation of language selection
    
    private var cancellables = Set<AnyCancellable>() // Holds any Combine subscriptions
    private let translationService = TranslationService() // The service handling translations
    
    // Flags to prevent translation loop
    private var shouldTranslateFrenchText = true
    private var shouldTranslateEnglishText = true
    
    init() {
        setupTranslationBindings() // Initialize the bindings when the ViewModel is created
    }
    
    // Sets up Combine bindings for automatic translation
    private func setupTranslationBindings() {
        // Observe changes in frenchText, debounce to limit requests, and translate to English
        $frenchText
            .dropFirst() // Ignore the initial value
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main) // Debounce to limit requests
            .sink { [weak self] text in
                guard self?.shouldTranslateFrenchText == true else {
                    self?.shouldTranslateFrenchText = true // Reset the flag for next use
                    return
                }
                self?.translate(text: text, from: "fr", to: "en")
            }
            .store(in: &cancellables) // Store the subscription
        
        // Observe changes in englishText, debounce to limit requests, and translate to French
        $englishText
            .dropFirst() // Ignore the initial value
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main) // Debounce to limit requests
            .sink { [weak self] text in
                guard self?.shouldTranslateEnglishText == true else {
                    self?.shouldTranslateEnglishText = true // Reset the flag for next use
                    return
                }
                self?.translate(text: text, from: "en", to: "fr")
            }
            .store(in: &cancellables) // Store the subscription
    }
    
    // Translates text from one language to another
    func translate(text: String, from sourceLang: String, to targetLang: String) {
        guard !text.isEmpty else { return } // Ensure there is text to translate
        
        // Call the translation service and handle the response
        translationService.getTranslation(text: text, from: sourceLang, to: targetLang) { [weak self] response, error in
            DispatchQueue.main.async {
                guard let translatedText = response?.data?.translations.first?.translatedText else { return }
                
                // Update the relevant text property based on the source language
                if sourceLang == "fr" {
                    self?.shouldTranslateEnglishText = false // Prevent reactive translation
                    self?.englishText = translatedText
                } else {
                    self?.shouldTranslateFrenchText = false // Prevent reactive translation
                    self?.frenchText = translatedText
                }
            }
        }
    }
}
