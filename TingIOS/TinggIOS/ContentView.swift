//
//  ContentView.swift
//  TingIOS
//
//  Created by Abdulrasaq on 25/05/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
        }
        .background(PrimaryTheme().primaryBgGradient)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
