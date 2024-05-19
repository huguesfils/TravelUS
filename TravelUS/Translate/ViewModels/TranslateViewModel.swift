//
//  TranslateViewModel.swift
//  TravelUS
//
//  Created by Hugues Fils on 05/03/2024.
//

import Combine
import Foundation

struct TranslationDisplay {
  let label: String
  let placeholder: String
  let language: Language
}

class TranslateViewModel: ObservableObject {
  @Published var initialText: TranslationDisplay = .init(
    label: "Français", placeholder: "Saisissez votre texte", language: .french)
  @Published var translatedText: TranslationDisplay = .init(
    label: "English", placeholder: "Enter text", language: .english)

  @Published var initialTextValue = ""
  @Published var translatedTextValue = ""

  @Published var isRotated = false

  private var cancellables = Set<AnyCancellable>()
  private let fetchTranslationUseCase: FetchTranslationUseCase

  init(fetchTranslationUseCase: FetchTranslationUseCase) {
    self.fetchTranslationUseCase = fetchTranslationUseCase
  }

  func viewDidLoad() {
    setupTranslationBindings()
  }

  func rotated() {
    let initial = initialText
    let translated = translatedText
    initialText = translated
    translatedText = initial
    initialTextValue = translatedTextValue
  }

  func clearTextFields() {
    initialTextValue = ""
    translatedTextValue = ""
  }

  private func setupTranslationBindings() {
    $initialTextValue
      .dropFirst()
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] newValue in
        guard let self = self else { return }
        self.translate(
          text: newValue, from: self.initialText.language, to: self.translatedText.language)
      }
      .store(in: &cancellables)
  }

  private func translate(text: String, from sourceLang: Language, to targetLang: Language) {
    Task {
      let result = await fetchTranslationUseCase.execute(
        text: text, from: sourceLang, to: targetLang)
      switch result {
      case .success(let translatedText):
        DispatchQueue.main.async {
          self.translatedTextValue = translatedText
        }
      case .failure(let error):
        print("Translation error: \(error)")
      }
    }
  }
}
