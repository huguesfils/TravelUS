//
//  TranslateViewModel.swift
//  TravelUS
//
//  Created by Hugues Fils on 05/03/2024.
//

import Foundation
import Combine

class TranslateViewModel: ObservableObject {
    @Published var frenchText = ""
    @Published var englishText = ""
    @Published var isFrenchFirst = true
    @Published var isRotated = false

    private var translateTextUseCase: TranslateText
    private var cancellables = Set<AnyCancellable>()

    init(translateTextUseCase: TranslateText) {
        self.translateTextUseCase = translateTextUseCase
        setupTranslationBindings()
    }

    private func setupTranslationBindings() {
        $isFrenchFirst
            .combineLatest($frenchText, $englishText)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] isFrenchFirst, frenchText, englishText in
                guard let self = self else { return }
                if isFrenchFirst && !frenchText.isEmpty {
                    self.translateTextUseCase.execute(text: frenchText, from: .french, to: .english) { translatedText, _ in
                        DispatchQueue.main.async {
                            self.englishText = translatedText ?? ""
                        }
                    }
                } else if !isFrenchFirst && !englishText.isEmpty {
                    self.translateTextUseCase.execute(text: englishText, from: .english, to: .french) { translatedText, _ in
                        DispatchQueue.main.async {
                            self.frenchText = translatedText ?? ""
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}
