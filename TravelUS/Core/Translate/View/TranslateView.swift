//
//  TranslateView.swift
//  TravelUS
//
//  Created by Hugues Fils on 27/02/2024.
//

import SwiftUI

struct TranslateView: View {
    @ObservedObject var viewModel = TranslateViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("SkyBlue").ignoresSafeArea()
                VStack(alignment: .leading) {
                    VStack{
                        if viewModel.isFrenchFirst {
                            TextFieldSectionView(label: "Français", placeholder: "Saisissez votre texte",text: $viewModel.frenchText, clearAction: {
                                viewModel.frenchText = ""
                                viewModel.englishText = ""
                            })
                            
                        } else {
                            TextFieldSectionView(label: "English", placeholder: "Enter text",text: $viewModel.englishText, clearAction: {
                                viewModel.englishText = ""
                                viewModel.frenchText = ""
                            })
                        }
                        
                        DividerWithButtonView(color: .skyBlue, isRotated: $viewModel.isRotated, action: {
                            viewModel.isFrenchFirst.toggle()
                        })
                        
                        if viewModel.isFrenchFirst {
                            TextFieldSectionView(label: "English", placeholder: "Enter text", text: $viewModel.englishText, clearAction: {
                                viewModel.englishText = ""
                                viewModel.frenchText = ""
                            })
                            .padding(.bottom)
                        } else {
                            TextFieldSectionView(label: "Français", placeholder: "Saisissez votre texte", text: $viewModel.frenchText, clearAction: {
                                viewModel.frenchText = ""
                                viewModel.englishText = ""
                            })
                            .padding(.bottom)
                        }
                    }
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
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
    }
}

#Preview {
    TranslateView()
}

