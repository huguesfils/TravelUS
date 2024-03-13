//
//  HideKeybordViewExtension.swift
//  TravelUS
//
//  Created by Hugues Fils on 11/03/2024.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
