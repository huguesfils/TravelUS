//
//  HideKeybordViewExtension.swift
//  TravelUS
//
//  Created by Hugues Fils on 11/03/2024.
//

import SwiftUI

// Extension on the SwiftUI View type.
extension View {
    // Adds a new method called hideKeyboard to all Views.
    func hideKeyboard() {
        // Uses the UIApplication shared instance to send an action.
        // The action sent is to resign the first responder status.
        // resignFirstResponder causes the keyboard to be dismissed if the current view was the one that brought up the keyboard.
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
