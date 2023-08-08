//
//  File.swift
//  
//
//  Created by Abdulrasaq on 15/01/2023.
//

import Foundation
import SwiftUI
public struct HRadioButtonAndText: View {
    @Binding var selected: String
    @State var name = ""
    public init(selected: Binding<String>, name: String) {
        self._selected = selected
        self._name = State(initialValue: name)
    }
    public var body: some View {
        HStack{
            RadioButtonView(selected: $selected, id: name)
            Text(name)
                .font(.caption)
                .foregroundColor(.black)
        }
    }
}
