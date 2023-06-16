//
//  RechargeAndBillView.swift
//  
//
//  Created by Abdulrasaq on 15/08/2022.
//

import SwiftUI
import Theme
import Checkout
import CoreUI
import CoreNavigation
import Core
struct RechargeAndBillView: View {
    @State var rechargeAndBill = [MerchantService]()
    @State var navigateToBillForm = false
    @State var service = MerchantService()
    @State var bills = BillDetails(service: .init(), info: .init())
    @State var gotoAllRechargesView = false
    @State var show = true
    @State var allRecharges = [String: [MerchantService]]()
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var navigation: NavigationUtils
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    let gridColumn = [
        GridItem(.adaptive(minimum: 90))
    ]
    var body: some View {
        Section {
            VStack {
                heading()
                ServicesGridView(services: $rechargeAndBill, showTitle: false) { service in
                    checkoutVm.slm.services = rechargeAndBill
                    checkoutVm.toCheckout(service) { billDetails in
                        if service.isABundleService {
                            homeViewModel.showBundles = true
                            let model = BundleModel(service: service)
                            homeViewModel.bundleModel = model
                            return
                        }
                        if service.isAirtimeService {
                            navigation.navigationStack.append(
                                Screens.buyAirtime(service.serviceName)
                            )
                            return
                        }
                        navigation.navigationStack.append(
                            Screens.billFormView(billDetails)
                        )
                    }
                }
            }
        }
        .padding()
        .showIf($show)
        .onAppear {
            homeViewModel.displayedRechargeAndBill()
        }
        .handleViewStatesMods(uiState: homeViewModel.$rechargeAndBillUIModel) { content in
            let data = content.data
            if data is [MerchantService] {
                withAnimation {
                    rechargeAndBill = data as! [MerchantService]
                }
                show = rechargeAndBill.isNotEmpty()
            } else if data is [String: [MerchantService]]{
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
    @ViewBuilder
    fileprivate func heading() -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Recharge & Bill payment")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .bold()
                Text("Recharge or pay for")
                    .font(.caption2)
                    .foregroundColor(.black)
                Spacer()
            }
            Spacer()
            Group {
                Text("See all")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .bold()
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
            }.onTapGesture(perform: onClickSeeAll)
        }
    }
    private func onClickSeeAll() {
        homeViewModel.allRecharge()
    }
}

struct ServicesGridView: View {
    @Binding var services:[MerchantService]
    @State var showTitle = false
    @State var gridColumn = [
        GridItem(.adaptive(minimum: 90))
    ]
    @State var onclick: (MerchantService) -> Void = {_ in
        //TODO
    }
    var body: some View {
        LazyVGrid(columns: gridColumn, spacing: 0){
            ForEach(services, id: \.id) { service in
                VStack {
                    IconImageCardView(imageUrl: service.serviceLogo, bgShape: .rectangular)
                        .padding(.vertical)
                        .onTapGesture {
                            onclick(service)
                        }
                    Text(service.serviceName)
                        .font(.caption)
                        .showIf($showTitle)
                }
            }
        }.onAppear {
            Log.d(message: "Services \(services)")
        }
    }
}

struct RechargeAndBillView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RechargeAndBillView(rechargeAndBill: [MerchantService]())
                .environmentObject(HomeDI.createHomeViewModel())
        }
    }
}
