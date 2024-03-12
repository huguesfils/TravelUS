//
//  TipView.swift
//  TravelUS
//
//  Created by Hugues Fils on 27/02/2024.
//

import SwiftUI

struct TipView: View {
    @StateObject var viewModel = TipViewModel()
    
    private let tipPercentages = [10, 15, 18, 20]

    var body: some View {
        NavigationStack {
            ZStack {
                Color("SunYellow").ignoresSafeArea()
                VStack {
                    VStack {
                        TextFieldSectionView(label: "Montant de la facture", placeholder: "Saisir montant", text: $viewModel.billAmount, clearAction: {
                            viewModel.billAmount = ""
                        })
                        .keyboardType(.numberPad)
                        
                        Picker("Pourcentage du pourboire", selection: $viewModel.tipPercentage) {
                            ForEach(tipPercentages, id: \.self) { percentage in
                                Text("\(percentage)%")
                            }
                        }
                        .pickerStyle(.segmented)
                        .colorMultiply(.terracotta)
                        .padding()

                        HStack {
                            Text("Pourboire: ") .fontWeight(.semibold)
                            Spacer()
                            Text(String(format: "$%.2f", viewModel.tipValue)) .fontWeight(.bold)
                               
                        }
                        .padding()

                        HStack {
                            Text("Total avec pourboire: ") .fontWeight(.semibold)
                            Spacer()
                            Text(String(format: "$%.2f", viewModel.totalWithTip)) .fontWeight(.bold)
                        }
                        .padding()
                        
                    }
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle("Calcul du pourboire")
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

#Preview {
    TipView()
}
