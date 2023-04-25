//
//  VirtualCardLinkedStateView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 19/04/2023.
//

import CoreUI
import SwiftUI

struct VirtualCardLinkedStateView: View {
    private let title = "Create your own\nvirtual card"
    private let btnLabel = "Create virtual card"
    @State private var termsAndCondition = "I have read and agreed to [Terms of and conditions](https://cellulant.io)"
    @State private var checkedTermsAndCondition = false
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
              
            Image("virtualcardlinkedstateicon")
            Spacer()
            HStack {
                CheckBoxView(checkboxChecked: $checkedTermsAndCondition)
                Text(.init(termsAndCondition))
                    .font(.subheadline)
            }
            TinggButton(buttonLabel: btnLabel) {
                //
            }
        }.padding()
    }
}

struct VirtualCardLinkedStateView_Previews: PreviewProvider {
    static var previews: some View {
        VirtualCardLinkedStateView()
    }
}
