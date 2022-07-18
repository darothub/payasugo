//
//  AddNewBillCardView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//

import SwiftUI

struct AddNewBillCardView: View {
    @EnvironmentObject var themeUtils: EnvironmentUtils
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "camera.fill")
                    .resizable()
                    .frame(width: 50, height: 40)
                Text("Pay for bills, food, and enjoy cashless shopping with TinggPay wallet")
                    .font(.system(size: themeUtils.primaryTheme.smallTextSize))
            }.padding(20)
            Divider()
            Text("Add a new bill")
                .foregroundColor(themeUtils.primaryTheme.cellulantRed)
                .font(.system(size: themeUtils.primaryTheme.smallTextSize))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.white)
                .padding(.horizontal, themeUtils.primaryTheme.largePadding)
                .shadow(radius: 10, x: 0, y: 5)
        )
    }
}

struct AddNewBillCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewBillCardView()
            .environmentObject(EnvironmentUtils())
    }
}
