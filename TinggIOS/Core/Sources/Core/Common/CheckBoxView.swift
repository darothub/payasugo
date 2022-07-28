//
//  CheckBoxView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 29/06/2022.
//

import SwiftUI

public struct CheckBoxView: View {
    @Binding var checkboxChecked: Bool
    public init(checkboxChecked: Binding<Bool>) {
        self._checkboxChecked = checkboxChecked
    }
    public var body: some View {
        Image(systemName: checkboxChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(checkboxChecked ? Color(UIColor.systemBlue) : Color.secondary)
                    .onTapGesture {
                        self.checkboxChecked.toggle()
                    }
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    struct CheckBoxViewHolder: View {
        @State var checked = false

        var body: some View {
            CheckBoxView(checkboxChecked: $checked)
        }
    }
    static var previews: some View {
        CheckBoxViewHolder()
    }
}

struct PreviewTester: PreviewProvider {
    static var previews: some View {
        CheckBoxView_Previews.previews
    }
}
