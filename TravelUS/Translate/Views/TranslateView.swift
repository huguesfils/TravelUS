//
//  TranslateView.swift
//  TravelUS
//
//  Created by Hugues Fils on 27/02/2024.
//

import SwiftUI

struct TranslateView: View {
  @ObservedObject var viewModel: TranslateViewModel

  var body: some View {
    NavigationStack {
      ZStack {
        Color("SkyBlue").ignoresSafeArea()
        VStack(alignment: .leading) {
          VStack {
            textFieldSectionView(
              translation: viewModel.initialText, isDisabled: false,
              value: $viewModel.initialTextValue
            )

            DividerWithButtonView(
              color: .skyBlue, isRotated: $viewModel.isRotated,
              action: {
                withAnimation {
                  viewModel.rotated()
                }
              })

            textFieldSectionView(
              translation: viewModel.translatedText, isDisabled: true,
              value: $viewModel.translatedTextValue
            )
          }
          .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.white))
          .padding(.horizontal)
          .padding(.top, 20)

          Spacer()
        }
      }
      .navigationTitle("Traduire")
    }
    .onTapGesture {
      hideKeyboard()
    }
    .task {
      viewModel.viewDidLoad()
    }
  }
  @ViewBuilder
  private func textFieldSectionView(
    translation: TranslationDisplay, isDisabled: Bool, value: Binding<String>
  ) -> some View {
    TextFieldSectionView(
      label: translation.label, placeholder: isDisabled ? "" : translation.placeholder, text: value,
      clearAction: {
        viewModel.clearTextFields()
      }, isDisabled: isDisabled
    )
  }
}

#Preview {
  TranslateView(
    viewModel: .init(fetchTranslationUseCase: TranslationInjector.fetchTranslationUseCase()))
}
