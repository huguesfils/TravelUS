//
//  CurrencyView.swift
//  TravelUS
//
//  Created by Hugues Fils on 27/02/2024.
//

import SwiftUI

struct CurrencyView: View {
    @ObservedObject var viewModel = CurrencyViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("NaturalGreen").ignoresSafeArea()
                VStack(alignment: .leading) {
                    VStack {
                        if viewModel.isDollarFirst {
                            TextFieldSectionView(label: "Dollars", placeholder: "Saisir montant", text: $viewModel.amountInDollars, clearAction: {
                                viewModel.clearAmounts()
                            })
                            .keyboardType(.decimalPad)
                            .onChange(of: viewModel.amountInDollars) { _ in
                                            viewModel.formatInput()
                                        }
                        } else {
                            TextFieldSectionView(label: "Euros", placeholder: "Saisir montant", text: $viewModel.amountInEuros, clearAction: {
                                viewModel.clearAmounts()
                            })
                            .keyboardType(.decimalPad)
                            .onChange(of: viewModel.amountInEuros) { _ in
                                            viewModel.formatInput()
                                        }
                        }
                        
                        DividerWithButtonView(color: .naturalGreen, isRotated: $viewModel.isRotated, action: {
                            viewModel.isDollarFirst.toggle()
                        })
                        
                        if viewModel.isDollarFirst {
                            TextFieldSectionView(label: "Euros", placeholder: "Saisir montant", text: $viewModel.amountInEuros, clearAction: {
                                viewModel.clearAmounts()
                            })
                            .keyboardType(.decimalPad)
                            .onChange(of: viewModel.amountInEuros) { _ in
                                            viewModel.formatInput()
                                        }
                            .padding(.bottom)
                        } else {
                            TextFieldSectionView(label: "Dollars", placeholder: "Saisir montant", text: $viewModel.amountInDollars, clearAction: {
                                viewModel.clearAmounts()
                            })
                            .keyboardType(.decimalPad)
                            .onChange(of: viewModel.amountInDollars) { _ in
                                            viewModel.formatInput()
                                        }
                            .padding(.bottom)
                        }
                    }
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle("Convertir")
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}


#Preview {
    CurrencyView()
}
