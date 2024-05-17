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
      TranslateView(
        viewModel: .init(fetchTranslationUseCase: TranslationInjector.fetchTranslationUseCase())
      )
      .tabItem {
        Label("Traduire", systemImage: "captions.bubble")
      }
      CurrencyView(viewModel: .init(fetchCurrencyUseCase: CurrencyInjector.fetchCurrencyUseCase()))
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
