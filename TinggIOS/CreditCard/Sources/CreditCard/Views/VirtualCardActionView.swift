//
//  VirtualCardActionView.swift
//  
//
//  Created by Abdulrasaq on 04/04/2023.
//

import CoreUI
import Foundation
import SwiftUI

public struct VirtualCardActionView: View {
    var name: String = "John"
    public init(name: String) {
        self.name = name
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Image("actionscreencardbg")
                .resizable()
                .frame(height: 450)
            VStack(alignment: .leading) {
                HStack {
                    Text("Welcome 🎉")
                    Text(name)
                        .bold()
                }.padding(.bottom)
                Text("Would you like to create a virtual card?")
                    .font(.largeTitle)
                    .padding(.trailing, 150)
                Spacer()
            
                TinggButton(backgroundColor: .blue, buttonLabel: "Yes, Please") {
                    //
                }
                TinggOutlineButton(backgroundColor: .black, buttonLabel: "No, Not yet", padding: 0, textColor: .black) {
                    //
                }
            }.padding()
        }
    }
}
