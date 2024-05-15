//
//  TranslateViewModel.swift
//  TravelUS
//
//  Created by Hugues Fils on 05/03/2024.
//

import Foundation
import Combine

class TranslateViewModel: ObservableObject {
    @Published var frenchText: String = ""
    @Published var englishText: String = ""
    @Published var isFrenchFirst = true
    @Published var isRotated = false
    
    private var cancellables = Set<AnyCancellable>()
    private let fetchTranslationUseCase: FetchTranslationUseCase
    
    init(fetchTranslationUseCase: FetchTranslationUseCase) {
        self.fetchTranslationUseCase = fetchTranslationUseCase
    }
    
    func viewDidLoad() {
        setupTranslationBindings()
    }
    
    private func setupTranslationBindings() {
        $frenchText
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let self = self, !newValue.isEmpty, self.isFrenchFirst else { return }
                print("Translating from French to English: \(newValue)")
                self.translate(text: newValue, from: .french, to: .english)
            }
            .store(in: &cancellables)
        
        $englishText
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let self = self, !newValue.isEmpty, !self.isFrenchFirst else { return }
                print("Translating from English to French: \(newValue)")
                self.translate(text: newValue, from: .english, to: .french)
            }
            .store(in: &cancellables)
    }
    
    private func translate(text: String, from sourceLang: Language, to targetLang: Language) {
        Task {
            print("Starting translation task: \(text) from \(sourceLang.rawValue) to \(targetLang.rawValue)")
            let result = await fetchTranslationUseCase.execute(text: text, from: sourceLang, to: targetLang)
            switch result {
            case .success(let translatedText):
                print("Translation success: \(translatedText)")
                DispatchQueue.main.async {
                    if sourceLang == .french {
                        self.englishText = translatedText
                    } else {
                        self.frenchText = translatedText
                    }
                }
            case .failure(let error):
                print("Translation error: \(error)")
            }
        }
    }
}
