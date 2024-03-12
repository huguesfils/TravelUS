//
//  DividerWithButtonView.swift
//  AnAmericanDream
//
//  Created by Hugues Fils on 27/02/2024.
//

import SwiftUI

struct DividerWithButtonView: View {
    @Binding var isRotated: Bool  // Utiliser Binding pour l'état de rotation
    let color: Color
    var action: () -> Void
    
    init(color: Color = .skyBlue, isRotated: Binding<Bool>, action: @escaping () -> Void) {
        self.color = color
        self._isRotated = isRotated  // Notez l'utilisation de _ pour le binding
        self.action = action
    }
    
    var body: some View {
        HStack {
            line
            
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(color)
                .overlay(
                    Image(systemName: "arrow.triangle.swap")
                        .foregroundColor(.terracotta)
                        .rotation3DEffect(
                            .degrees(isRotated ? 180 : 0),
                            axis: (x: 1.0, y: 0.0, z: 0.0)
                        )
                )
                .onTapGesture {
                    withAnimation {
                        isRotated.toggle()
                        action()
                    }
                }
                .padding(.horizontal, -10)
            
            line
        }
    }
    
    var line: some View {
        VStack { Divider().background(color) }
    }
}

