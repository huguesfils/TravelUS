//
//  TabBarView.swift
//  TravelUS
//
//  Created by Hugues Fils on 27/02/2024.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            TranslateView()
                .tabItem {
                    Label("Traduire", systemImage: "captions.bubble")
                }
            CurrencyView()
                .tabItem {
                    Label("Convertir", systemImage: "dollarsign.arrow.circlepath")
                }
            TipView()
                .tabItem {
                    Label("Pourboire", systemImage: "banknote")
                }
        }
    }
}

#Preview {
    TabBarView()
}
