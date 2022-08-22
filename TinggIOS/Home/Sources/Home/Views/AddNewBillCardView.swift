//
//  AddNewBillCardView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//

import SwiftUI
import Core
import Theme
struct AddNewBillCardView: View {
    var body: some View {
        VStack {
            HStack {
                PrimaryTheme.getImage(image: .addBillImage)
                    .padding(.horizontal, 10)
                Text("Pay for bills, food, and enjoy cashless shopping with TinggPay wallet")
                    .font(.system(size: PrimaryTheme.smallTextSize))
            }.padding(20)
            Divider()
            Text("Add a new bill")
                .foregroundColor(PrimaryTheme.getColor(.cellulantRed))
                .font(.system(size: PrimaryTheme.smallTextSize))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.white)
                .padding(.horizontal, PrimaryTheme.largePadding)
                .shadow(radius: 3, x: 0, y: 3)
        )
    }
}

struct AddNewBillCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewBillCardView()
    }
}
