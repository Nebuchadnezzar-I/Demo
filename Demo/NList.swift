//
//  NList.swift
//  Demo
//
//  Created by Michal Ukropec on 13/04/2025.
//

import SwiftUI

struct NList: View {
    @State private var negotiations: [Negotiation] = []
    var scrollTo: (Int) -> Void

    func addNegotiation() {
        negotiations.insert(Negotiation(id: UUID(), name: "New Deal"), at: 0)
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                MainButton(iconName: "plus", width: 48, action: addNegotiation)
            }

            List(negotiations) { item in
                NButton(name: item.name, action: {})
                    .onTapGesture {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(
                                .spring(response: 0.4, dampingFraction: 0.75, blendDuration: 1)
                            ) {
                                scrollTo(1)
                            }
                        }
                    }
            }
            .listStyle(.plain)
//            .onAppear {
//                Database.shared.fetchNegotiations { loaded in
//                    negotiations = loaded
//                }
//            }
        }
        .padding()
    }
}

#Preview {
    NList(scrollTo: { _ in })
}
