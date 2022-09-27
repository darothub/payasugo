//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 27/09/2022.
//

import SwiftUI

public struct RadioButtonView: View {
    @Binding var selected: String
    private var id: String = ""
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
