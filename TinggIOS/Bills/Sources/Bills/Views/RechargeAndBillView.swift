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
public struct RechargeAndBillView: View {
    @State var rechargeAndBill = [MerchantService]()
    @State var navigateToBillForm = false
    @State var service = MerchantService()
    @State var bills = BillDetails(service: .init(), info: .init())
    @State var gotoAllRechargesView = false
    @State var show = true
    @State var allRecharges = [String: [MerchantService]]()
    @State var isLoading = false
    @EnvironmentObject var billViewModel: BillViewModel
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    let gridColumn = [
        GridItem(.adaptive(minimum: 90))
    ]
    var quickTopUpListener: ServicesListener
    public init(quickTopUpListener: ServicesListener) {
        self.quickTopUpListener = quickTopUpListener
    }
    public var body: some View {
        Section {
            VStack {
                heading()
                ServicesGridView(services: $rechargeAndBill, showTitle: false) { service in
                    checkoutVm.toCheckout(service) { billDetails, toCheckout in
                        
                        if service.isABundleService {
                            billViewModel.showBundles = true
                            let model = BundleModel(service: service)
                            billViewModel.bundleModel = model
                            return
                        }
                        if service.isAirtimeService {
                            quickTopUpListener.onQuicktop(serviceName: service.serviceName)
                            return
                        }
                        if toCheckout {
                            checkoutVm.showView = toCheckout
                            return
                        }
                        navigation.navigateTo(
                            screen: BillsScreen.fetchbillView(billDetails)
                        )
                    }
                }
            }
        }
        .padding()
        .showIf($show)
        .handleViewStatesModWithCustomShimmer(
            uiState: billViewModel.$rechargeAndBillUIModel,
            showAlertOnError: false,
            shimmerView: AnyView(HorizontalBoxesShimmerView()),
            isLoading: $isLoading
        ) { content in
            let data = content.data
            if data is [MerchantService] {
                withAnimation {
                    rechargeAndBill = data as! [MerchantService]
                }
                show = rechargeAndBill.isNotEmpty()
            }
            
        } onFailure: { str in
            show = false
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
        let categoryNameAndServices = billViewModel.getTitleAndServicesList()
        withAnimation {
            navigation.navigateTo(screen: BillsScreen.categoriesAndServices(categoryNameAndServices)
            )
        }
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
    struct RechargeAndBillViewHolder: View, ServicesListener {
        func onQuicktop(serviceName: String) {
            //
        }
        
        var body: some View {
            RechargeAndBillView(quickTopUpListener: self)
                .environmentObject(BillsDI.createBillViewModel())
                .environmentObject(NavigationManager.shared)
        }
    }
    static var previews: some View {
        NavigationStack {
            RechargeAndBillViewHolder()
        }
    }
}
