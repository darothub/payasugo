//
//  NewTest.swift
//
//
//  Created by Abdulrasaq on 13/07/2023.
//

import SwiftUI

struct NewTest: View {
    @State private var phoneNumber = "12"
    @State private var selectedFlag = "🇺🇸 +1"
    @State private var flags = ["🇺🇸 +1", "🇬🇧 +44", "🇨🇦 +1"]

    var body: some View {
        VStack {
            FlagTextField(phoneNumber: $phoneNumber, flags: $flags, selectedFlag: $selectedFlag) {
                text in text.count >= 6
            }
        }
        .padding()
    }
}

struct NewTest_Previews: PreviewProvider {
    static var previews: some View {
        NewTest()
    }
}





