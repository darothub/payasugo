//
//  ActivateCardView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 14/07/2022.
//

import SwiftUI
import Theme

struct ActivateCardView: View {
    var parentSize: GeometryProxy
    var activateAction: () -> Void
    var body: some View {
        HStack {
            PrimaryTheme.getImage(image: .moneyImage)
                .padding(.leading, PrimaryTheme.largePadding)
            Text("Enjoy cashless shopping with Tingg Wallet and earn rewards")
                .font(.system(size: 14))
                .minimumScaleFactor(0.05)
                .lineLimit(3)
                .padding()
            Button {
                activateAction()
            } label: {
                Text("ACTIVATE")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: PrimaryTheme.mediumTextSize))
                    .padding(10)
                    .foregroundColor(.red)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 0.5)
                    )
                    .padding(.trailing, PrimaryTheme.largePadding)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .frame(height: parentSize.size.height * 0.13)
                .foregroundColor(.white)
                .padding()
                .shadow(radius: 3, x: 0, y: 3)
        )
    }
}

struct ActivateCardView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ActivateCardView(parentSize: geo) {}
        }
    }
}
