//
//  TextFieldSectionView.swift
//  AnAmericanDream
//
//  Created by Hugues Fils on 06/03/2024.
//

import SwiftUI

struct TextFieldSectionView: View {
    var label: String
    var placeholder: String
    @Binding var text: String
    var clearAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .foregroundStyle(Color.accentColor)
                .padding([.horizontal, .top])
                .font(.subheadline)
            TextField(placeholder, text: $text)
                .padding()
                .padding(.bottom, 30)
                .font(.title2)
                .fontWeight(.bold)
                .overlay(
                    Group {
                        if !text.isEmpty {
                            Button(action: clearAction) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(Color.gray)
                                    .padding(.bottom, 25)
                                    .padding(.trailing, 8)
                            }
                            .transition(.scale)
                        }
                    }, alignment: .trailing
                )
        }
    }
}
