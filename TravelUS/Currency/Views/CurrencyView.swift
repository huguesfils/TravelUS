//
//  CurrencyView.swift
//  TravelUS
//
//  Created by Hugues Fils on 27/02/2024.
//

import SwiftUI

struct CurrencyView: View {
  @ObservedObject var viewModel: CurrencyViewModel

  var body: some View {
    NavigationStack {
      ZStack {
        Color("NaturalGreen").ignoresSafeArea()
        VStack(alignment: .leading) {
          VStack {

            textFieldSectionView(
              currency: viewModel.convertCurrency, isDisabled: false,
              value: $viewModel.convertCurrencyValue)

            DividerWithButtonView(
              color: .naturalGreen, isRotated: $viewModel.isRotated,
              action: {
                withAnimation {
                  viewModel.rotated()
                }
              })

            textFieldSectionView(
              currency: viewModel.resultCurrency, isDisabled: true,
              value: $viewModel.resultCurrencyValue
            )
            .padding(.bottom)

          }
          .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
          .padding(.horizontal)
          .padding(.top, 20)

          Spacer()
        }
      }
      .navigationTitle("Convertir")
    }
    .gesture(
      DragGesture().onChanged { _ in
        UIApplication.shared.sendAction(
          #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
    )
    .onTapGesture {
      hideKeyboard()
    }
    .task {
      await viewModel.viewDidLoad()
    }
  }

  @ViewBuilder
  private func textFieldSectionView(
    currency: CurrencyDisplay, isDisabled: Bool, value: Binding<String>
  ) -> some View {
    TextFieldSectionView(
      label: currency.label, placeholder: isDisabled ? "" : currency.placeholder, text: value,
      clearAction: {
        viewModel.clearAmounts()
      }, isDisabled: isDisabled
    )
    .keyboardType(.decimalPad)
  }
}

#Preview {
  CurrencyView(viewModel: .init(fetchCurrencyUseCase: CurrencyInjector.fetchCurrencyUseCase()))
}
