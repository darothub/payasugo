//
//  AddNewBillCardView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//

import SwiftUI
import Core
import CoreNavigation
import Theme
struct AddNewBillCardView: View {
    @State var allRecharges = [String: [MerchantService]]()
    @StateObject var hvm: HomeViewModel = HomeDI.createHomeViewModel()
    @EnvironmentObject var navigation: NavigationManager
    var body: some View {
        VStack {
            HStack {
                PrimaryTheme.getImage(image: .addBillImage)
                    .padding(.horizontal, 10)
                Text("Pay for bills, food, and enjoy cashless shopping with TinggPay wallet")
                    .font(.system(size: PrimaryTheme.smallTextSize))
                    .foregroundColor(.black)
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
        .onTapGesture {
            hvm.allRecharge()
        }
        .handleViewStatesMods(uiState: hvm.$rechargeAndBillUIModel) { content in
            let data = content.data
            if data is [String: [MerchantService]]{
                allRecharges = data as! [String : [MerchantService]]
                let categoryNameAndServices = allRecharges.keys
                    .sorted(by: <)
                    .map{TitleAndListItem(title: $0, services: allRecharges[$0] ?? [])}
                withAnimation {
                    navigation.navigationStack.append(
                        HomeScreen.categoriesAndServices(categoryNameAndServices)
                    )
                }
            }
        }
    }
}

struct AddNewBillCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewBillCardView()
    }
}
