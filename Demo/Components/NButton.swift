//
//  NButton.swift
//  Demo
//
//  Created by Michal Ukropec on 13/04/2025.
//

import SwiftUI

struct NButton: View {
    @State private var isPressed = false
    var name: String
    var action: () -> Void

    var body: some View {
        VStack {
            Text(name)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Sub")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background {
            ZStack {
                Color.clear
                    .background(.ultraThinMaterial)
                    .opacity(isPressed ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: isPressed)
            }
        }
        .cornerRadius(12)
        .scaleEffect(isPressed ? 0.98 : 1)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
        .padding(.bottom, 16)
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
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
    NButton(name: "Negotiation xD", action: {})
}
