//
//  ConvertCurrency.swift
//  TravelUS
//
//  Created by Hugues Fils on 13/05/2024.
//

import Foundation

protocol CurrencyConverting {
  func convert(amount: Double, fromCurrency: String, toCurrency: String, rates: [String: Double])
    -> Double
}

struct CurrencyConversionUseCase: CurrencyConverting {
  func convert(amount: Double, fromCurrency: String, toCurrency: String, rates: [String: Double])
    -> Double
  {
    guard let fromRate = rates[fromCurrency], let toRate = rates[toCurrency], fromRate != 0 else {
      return 0
    }
    return (amount / fromRate) * toRate
  }
}
