//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 27/09/2022.
//

import SwiftUI

/// A custom radio button view
public struct RadioButtonView: View {
    @Binding var selected: String
    private var id: String = ""
    /// ``RadioButtonView``
    /// - Parameters:
    ///   - selected: A flag that inidicate the selected radio button
    ///   - id: Radio button Id
    public init(selected: Binding<String>, id: String) {
        self.id = id
        self._selected = selected
    }
    public var body: some View {
        Image(systemName: selected == id ? "record.circle" : "circle")
            .foregroundColor(
                .black
            )
            .onTapGesture {
                selected = id
            }
    }
}

public struct RadioButtonWithTextView: View {
    private var id: String = ""
    @Binding var selected: String
    @State var label: String = ""
    public init(id: String, selected: Binding<String>, label: String) {
        self.id = id
        self._selected = selected
        self._label = State(initialValue: label)
    }
    public var body: some View {
        HStack {
            RadioButtonView(selected: $selected, id: id)
            Text(label)
            Spacer()
        }
    }
}

struct RadioButtonView_Previews: PreviewProvider {
    struct RadioButtonViewHolder: View {
        @State var checked = false
        @State var selected = ""
        var body: some View {
            VStack {
                RadioButtonView(selected: $selected, id: "Mtn")
                RadioButtonView(selected: $selected, id: "Airtel")
            }
        }
    }
    static var previews: some View {
        RadioButtonViewHolder()
    }
}
