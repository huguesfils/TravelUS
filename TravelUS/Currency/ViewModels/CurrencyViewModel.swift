//
//  CurrencyViewModel.swift
//  TravelUS
//
//  Created by Hugues Fils on 11/03/2024.
//

import Combine
import Foundation
import SwiftUI

enum CurrencyType: String {
  case EUR, USD
}

struct CurrencyDisplay {
  let type: CurrencyType
  let label: String
  let placeholder: String
}

class CurrencyViewModel: ObservableObject {
  @Published var convertCurrency: CurrencyDisplay = .init(
    type: .USD, label: "Dollars", placeholder: "Enter amount")
  @Published var resultCurrency: CurrencyDisplay = .init(
    type: .EUR, label: "Euros", placeholder: "Saisir montant")

  @Published var isRotated = false

  @Published var convertCurrencyValue = ""
  @Published var resultCurrencyValue = ""

  private let fetchCurrencyUseCase: FetchCurrencyUseCase
  private var rates: [String: Double] = [:]
  private let currencyConversionUseCase: CurrencyConverting

  private var cancellables = Set<AnyCancellable>()

  init(
    fetchCurrencyUseCase: FetchCurrencyUseCase,
    currencyConversionUseCase: CurrencyConverting = CurrencyConversionUseCase()
  ) {
    self.fetchCurrencyUseCase = fetchCurrencyUseCase
    self.currencyConversionUseCase = currencyConversionUseCase
  }

  func viewDidLoad() async {
    await fetchCurrencyRates()
    setupCurrencyConversionBindings()
  }

  func rotated() {
    let converted = convertCurrency
    let result = resultCurrency
    convertCurrency = result
    resultCurrency = converted
    convertCurrencyValue = resultCurrencyValue

  }

  func amountChange(_ value: String) {
    convertCurrency(
      from: convertCurrency.type.rawValue, to: resultCurrency.type.rawValue,
      amount: convertCurrencyValue
    ) { [weak self] convertedCurrency in
      self?.resultCurrencyValue = convertedCurrency
    }
  }

  private func setupCurrencyConversionBindings() {
    $convertCurrencyValue
      .dropFirst()
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] newValue in
        guard let self = self else { return }
        self.amountChange(newValue)
      }
      .store(in: &cancellables)
  }

  private func fetchCurrencyRates() async {
    let result = await fetchCurrencyUseCase.execute()

    switch result {
    case .success(let currency):
      self.rates = currency.rates
    case .failure(let failure):
      print(failure)
    }
  }

  private func convertCurrency(
    from sourceCurrency: String, to targetCurrency: String, amount: String,
    completion: @escaping (String) -> Void
  ) {
    guard let amountValue = Double(amount.replacingOccurrences(of: ",", with: ".")) else {
      completion("")
      return
    }
    let convertedAmount = currencyConversionUseCase.convert(
      amount: amountValue, fromCurrency: sourceCurrency, toCurrency: targetCurrency, rates: rates)
    DispatchQueue.main.async {
      completion(self.formatCurrency(convertedAmount))
    }
  }

  func clearAmounts() {
    convertCurrencyValue = ""
    resultCurrencyValue = ""
  }

  private func formatCurrency(_ amount: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2

    return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
  }
}
