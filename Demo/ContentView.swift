//
//  ContentView.swift
//  Demo
//
//  Created by Michal Ukropec on 13/04/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var activeIdx: Int = 0
    
    func scrollTo(page: Int) {
        activeIdx = page
    }

    var body: some View {
        TabView(selection: $activeIdx) {
            NList(scrollTo: scrollTo)
                .tag(0)
            
            Color.red
                .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

#Preview {
    ContentView()
}
