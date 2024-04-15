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
                        .keyboardType(.decimalPad)
                        
                        Picker("Pourcentage du pourboire", selection: $viewModel.tipPercentage) {
                            ForEach(tipPercentages, id: \.self) { percentage in
                                Text("\(percentage)%")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .colorMultiply(.terracotta)
                        .padding()
                        
                        VStack {
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
//                        .onTapGesture {
//                            hideKeyboard()
//                        }
                    }
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle("Calcul du pourboire")
            .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
        }
    }
}

#Preview {
    TipView()
}
