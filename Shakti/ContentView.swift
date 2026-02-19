//
//  ContentView.swift
//  Shakti
//
//  Created by Hitesh Kumar on 19/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HelloView()
                .tabItem {
                    Label("Hello", systemImage: "hand.wave.fill")
                }

            BrowserView()
                .tabItem {
                    Label("Browser", systemImage: "safari.fill")
                }
        }
    }
}

// MARK: - Hello tab

struct HelloView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "globe")
                .imageScale(.large)
                .font(.system(size: 60))
                .foregroundStyle(.tint)
            Text("Hello, World!")
                .font(.largeTitle)
                .fontWeight(.semibold)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
