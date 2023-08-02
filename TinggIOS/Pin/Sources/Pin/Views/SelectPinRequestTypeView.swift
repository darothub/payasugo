//
//  SelectPinRequestTypeView.swift
//
//
//  Created by Abdulrasaq on 02/08/2023.
//
import CoreUI
import SwiftUI

public struct SelectPinRequestTypeView: View {
    @Binding var pinRequestChoice: String
    var onClickContinue: (String) -> Void
    var onClickLater: () -> Void
    private let pinRequestChoice1 = PinConstants.pinRequestChoice1
    private let pinRequestChoice2 = PinConstants.pinRequestChoice2
    
    public init(
        pinRequestChoice: Binding<String> = .constant(""),
        onClickContinue: @escaping (String) -> Void,
        onClickLater: @escaping () -> Void ) {
        self._pinRequestChoice = pinRequestChoice
        self.onClickContinue = onClickContinue
        self.onClickLater = onClickLater
    }
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Select option")
                .frame(maxWidth: .infinity, alignment: .center)
            Text("There are two pin options .Select the one you prefer.")
                .font(.caption)
            HRadioButtonAndText(selected: $pinRequestChoice, name: pinRequestChoice1)
                .font(.caption)
            HRadioButtonAndText(selected: $pinRequestChoice, name: pinRequestChoice2)
                .font(.caption)
            HStack {
                Button {
                    onClickLater()
                } label: {
                    Text("Later")
                        .font(.caption)
                }
                Spacer()
                Button {
                   onClickContinue(pinRequestChoice)
                } label: {
                    Text("Continue")
                        .font(.caption)
                }
            }.padding(.top)
        }
        .padding(40)
    }
}

#Preview {
    SelectPinRequestTypeView(
        onClickContinue: {str in
    },
    onClickLater: {
        
    })
}
