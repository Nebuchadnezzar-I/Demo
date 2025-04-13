//
//  MainButton.swift
//  Demo
//
//  Created by Michal Ukropec on 13/04/2025.
//

import SwiftUI

struct MainButton: View {
    @State private var isPressed = false
    var iconName: String
    var width: CGFloat
    var action: () -> Void

    var body: some View {
        VStack {
            Image(systemName: iconName)
        }
        .padding()
        .frame(width: width)
        .background {
            ZStack {
                Color.clear
                    .background(.ultraThinMaterial)
                    .opacity(isPressed ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: isPressed)
            }
        }
        .cornerRadius(12)
        .scaleEffect(isPressed ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        UIImpactFeedbackGenerator(style: .medium)
                            .impactOccurred()
                    }
                }
                .onEnded { _ in
                    action()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            isPressed = false
                        }
                    }
                }
        )
    }
}

#Preview {
    MainButton(iconName: "plus", width: 48, action: {})
}
