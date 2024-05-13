//
//  CurrencyViewModel.swift
//  TravelUS
//
//  Created by Hugues Fils on 11/03/2024.
//

import Foundation
import Combine

class CurrencyViewModel: ObservableObject {
    @Published var amountInDollars: String = ""
    @Published var amountInEuros: String = ""
    @Published var isDollarFirst = true
    @Published var isRotated = false
    
    private var cancellables = Set<AnyCancellable>()
    private let fetchCurrencyUseCase: FetchCurrencyUseCase
    
    private var rates: [String: Double] = [:]
    private let currencyConversionUseCase: CurrencyConverting
    
    init(fetchCurrencyUseCase: FetchCurrencyUseCase, currencyConversionUseCase: CurrencyConverting = CurrencyConversionUseCase()) {
        self.fetchCurrencyUseCase = fetchCurrencyUseCase
        self.currencyConversionUseCase = currencyConversionUseCase
    }
    
    func viewDidLoad() async {
        await fetchCurrencyRates()
    }
    
    private func fetchCurrencyRates() async {
        let result = await fetchCurrencyUseCase.execute()
        
        switch result {
        case .success(let currency):
            self.rates = currency.rates
            self.setupCurrencyConversionBindings()
        case .failure(let failure):
            print(failure)
        }
    }
    
    private func setupCurrencyConversionBindings() {
        $amountInDollars
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let self = self, let dollarAmount = Double(newValue) else { return }
                let euroAmount = self.currencyConversionUseCase.convert(amount: dollarAmount, fromCurrency: "USD", toCurrency: "EUR", rates: self.rates)
                DispatchQueue.main.async {
                    self.amountInEuros = self.formatCurrency(euroAmount)
                }
            }
            .store(in: &cancellables)
        
        $amountInEuros
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let self = self, let euroAmount = Double(newValue) else { return }
                let dollarAmount = self.currencyConversionUseCase.convert(amount: euroAmount, fromCurrency: "EUR", toCurrency: "USD", rates: self.rates)
                DispatchQueue.main.async {
                    self.amountInDollars = self.formatCurrency(dollarAmount)
                }
            }
            .store(in: &cancellables)
    }
    
    func formatInput() {
        amountInDollars = amountInDollars.replacingOccurrences(of: ",", with: ".")
        amountInEuros = amountInEuros.replacingOccurrences(of: ",", with: ".")
    }
    
    func clearAmounts() {
        amountInDollars = ""
        amountInEuros = ""
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}
