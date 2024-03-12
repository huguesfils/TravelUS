//
//  CurrencyViewModel.swift
//  TravelUS
//
//  Created by Hugues Fils on 11/03/2024.
//

import Foundation
import Combine

// ViewModel responsible for currency conversion logic
class CurrencyViewModel: ObservableObject {
    // Observable properties to reflect in the UI
    @Published var amountInDollars: String = ""
    @Published var amountInEuros: String = ""
    @Published var isDollarFirst = true // Determines if dollars are entered first
    @Published var isRotated = false // Tracks if the UI should be rotated/changed
    
    private var cancellables = Set<AnyCancellable>() // Holds all Combine subscriptions
    private var currencyService: CurrencyService // Service to fetch currency rates
    private var rates: [String: Double] = [:] // Stores fetched currency rates
    
    // Initializer takes a CurrencyService instance
    init(currencyService: CurrencyService = CurrencyService()) {
        self.currencyService = currencyService
        fetchCurrencyRates() // Fetch rates upon initialization
        setupCurrencyConversionBindings() // Setup data bindings
    }
    
    // Clears the input amounts
    func clearAmounts() {
        amountInDollars = ""
        amountInEuros = ""
    }
    
    // Fetches the latest currency rates
    private func fetchCurrencyRates() {
        currencyService.getCurrency { [weak self] response, error in
            guard let self = self, let response = response, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            DispatchQueue.main.async {
                self.rates = response.rates // Update rates with fetched data
            }
        }
    }
    
    // Sets up bindings to perform conversion when input changes
    private func setupCurrencyConversionBindings() {
        // Observes changes to amountInDollars, debounces, removes duplicates, and performs conversion
        $amountInDollars
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.convertDollarsToEuros(dollars: newValue)
            }
            .store(in: &cancellables)
        
        // Observes changes to amountInEuros, debounces, removes duplicates, and performs conversion
        $amountInEuros
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.convertEurosToDollars(euros: newValue)
            }
            .store(in: &cancellables)
    }
    
    // Converts dollar amount to euros using the fetched rate
    private func convertDollarsToEuros(dollars: String) {
        guard let dollarAmount = Double(dollars), let euroRate = rates["EUR"] else { return }
        let euroAmount = dollarAmount * euroRate
        DispatchQueue.main.async {
            self.amountInEuros = self.formatCurrency(euroAmount)
        }
    }
    
    // Converts euro amount to dollars using the fetched rate
    private func convertEurosToDollars(euros: String) {
        guard let euroAmount = Double(euros), let euroRate = rates["EUR"], euroRate != 0 else { return }
        let dollarAmount = euroAmount / euroRate
        DispatchQueue.main.async {
            self.amountInDollars = self.formatCurrency(dollarAmount)
        }
    }
    
    // Formats a double into a currency string with up to 2 decimal places
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0 // No forced minimum decimal digits
        formatter.maximumFractionDigits = 2 // Up to 2 digits after the decimal point
        
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}
