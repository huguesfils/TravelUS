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
                            
                            if viewModel.isFrenchFirst {
                                TextFieldSectionView(label: "Français", placeholder: "Saisissez votre texte", text: $viewModel.frenchText, clearAction: {
                                    viewModel.frenchText = ""
                                    viewModel.englishText = ""
                                }, isDisabled: false)
                            } else {
                                TextFieldSectionView(label: "English", placeholder: "Enter text", text: $viewModel.englishText, clearAction: {
                                    viewModel.englishText = ""
                                    viewModel.frenchText = ""
                                }, isDisabled: false)
                            }
                            
                            DividerWithButtonView(color: .skyBlue, isRotated: $viewModel.isRotated, action: {
                                withAnimation {
                                    viewModel.isFrenchFirst.toggle()
                                }
                            })
                            
                            if viewModel.isFrenchFirst {
                                TextFieldSectionView(label: "English", placeholder: "", text: $viewModel.englishText, clearAction: {
                                    viewModel.englishText = ""
                                    viewModel.frenchText = ""
                                }, isDisabled: true)
                            } else {
                                TextFieldSectionView(label: "Français", placeholder: "", text: $viewModel.frenchText, clearAction: {
                                    viewModel.frenchText = ""
                                    viewModel.englishText = ""
                                }, isDisabled: true)
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
            .task {
                viewModel.viewDidLoad()
            }
        }
    }

//#Preview {
//    TranslateView()
//}

