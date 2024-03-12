//
//  TipViewModel.swift
//  TravelUS
//
//  Created by Hugues Fils on 12/03/2024.
//

import Foundation
import Combine

// ViewModel for handling tip calculations based on a bill amount and a selected tip percentage.
class TipViewModel: ObservableObject {
    // Observable properties to reflect in the UI.
    @Published var billAmount: String = "" // The total bill amount entered by the user.
    @Published var tipPercentage: Int = 15 // The selected tip percentage.
    // Note: 'private let tipPercentages' is defined but not used in this ViewModel.
    // It is intended for use in a Picker in the view layer.

    // Computed property to calculate the tip value based on the bill amount and the tip percentage.
    var tipValue: Double {
        // Attempt to convert the billAmount string to a Double. If conversion fails, default to 0.
        let billValue = Double(billAmount) ?? 0
        // Calculate the tip by multiplying the bill amount by the tip percentage and dividing by 100.
        return billValue * Double(tipPercentage) / 100.0
    }
    
    // Computed property to calculate the total amount to be paid, including the tip.
    var totalWithTip: Double {
        // Attempt to convert the billAmount string to a Double. If conversion fails, default to 0.
        let billValue = Double(billAmount) ?? 0
        // Calculate the total amount by adding the original bill amount to the tip value.
        return billValue + tipValue
    }
}
