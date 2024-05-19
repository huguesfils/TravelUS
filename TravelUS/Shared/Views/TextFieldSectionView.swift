//
//  TextFieldSectionView.swift
//  TravelUS
//
//  Created by Hugues Fils on 06/03/2024.
//

import SwiftUI

struct TextFieldSectionView: View {
  var label: String
  var placeholder: String
  @Binding var text: String
  var clearAction: () -> Void
  var isDisabled: Bool = false

  var body: some View {
    VStack(alignment: .leading) {
      Text(label)
        .foregroundStyle(Color.accentColor)
        .padding([.horizontal, .top])
        .font(.subheadline)
      TextField(placeholder, text: $text, axis: .vertical)
        .lineLimit(5)
        .padding()
        .padding(.bottom, 30)
        .font(.title2)
        .fontWeight(.bold)
        .disabled(isDisabled)
        .overlay(
          Group {
            if !text.isEmpty {
              Button(action: clearAction) {
                Image(systemName: "multiply.circle.fill")
                  .foregroundStyle(Color.gray)
                  .padding(.bottom, 25)
                  .padding(.leading, 10)
                  .padding(.trailing, 8)
              }
              .transition(.scale)
            }
          }, alignment: .trailing
        )
    }
  }
}
