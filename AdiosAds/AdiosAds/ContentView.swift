//
//  ContentView.swift
//  AdiosAds
//
//  Created by Victor Renan Ferreira on 26/03/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "safari")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Abra as configurações do Safari!")
            Button("Abrir") {
                // Get the settings URL and open it
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
