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
                    Label("Traduction", systemImage: "captions.bubble")
                }
            CurrencyView()
                .tabItem {
                    Label("Conversion", systemImage: "dollarsign.arrow.circlepath")
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
