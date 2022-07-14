//
//  ActivateCardView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 14/07/2022.
//

import SwiftUI

struct ActivateCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: .infinity, height: 100)
                .foregroundColor(.white)
                .padding()
                .shadow(radius: 10, x: 0, y: 5)
            HStack {
                Image(systemName: "camera.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.leading, 30)
                Text("Enjoy cashless shopping with Tingg Wallet and earn rewards")
                    .font(.system(size: 14))
                    .minimumScaleFactor(0.05)
                    .lineLimit(3)
                    .padding()
                Button {
                    
                } label: {
                    Text("ACTIVATE")
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 18))
                        .padding(10)
                        .foregroundColor(.red)
                        .border(Color.gray, width: 1)
                        .background(Color(.white))
                        .cornerRadius(10)
                        .padding(.trailing, 30)
                }
            }
        }
    }
}

struct ActivateCardView_Previews: PreviewProvider {
    static var previews: some View {
        ActivateCardView()
    }
}
