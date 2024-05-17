//
//  TipViewModel.swift
//  TravelUS
//
//  Created by Hugues Fils on 12/03/2024.
//

import Combine
import Foundation

class TipViewModel: ObservableObject {
  @Published var billAmount: String = ""
  @Published var tipPercentage: Int = 15

  func cleanedBillAmount() -> Double {
    let cleanedString = billAmount.replacingOccurrences(of: ",", with: ".")
    return Double(cleanedString) ?? 0
  }

  var tipValue: Double {
    let billValue = cleanedBillAmount()
    return billValue * Double(tipPercentage) / 100.0
  }

  var totalWithTip: Double {
    let billValue = cleanedBillAmount()
    return billValue + tipValue
  }
}
