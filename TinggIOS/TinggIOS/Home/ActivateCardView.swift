//
//  ActivateCardView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 14/07/2022.
//

import SwiftUI
import Theme

struct ActivateCardView: View {
    var theme: PrimaryTheme
    var parentSize: GeometryProxy
    var activateAction: () -> Void
    var body: some View {
        HStack {
            Image(systemName: "camera.fill")
                .resizable()
                .frame(width: parentSize.size.height * 0.05, height: parentSize.size.height * 0.04 )
                .padding(.leading, theme.largePadding)
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
                    .font(.system(size: theme.mediumTextSize))
                    .padding(10)
                    .foregroundColor(.red)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 0.5)
                    )
                    .padding(.trailing, theme.largePadding)
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
            ActivateCardView(theme: PrimaryTheme(), parentSize: geo) {}
        }
    }
}
