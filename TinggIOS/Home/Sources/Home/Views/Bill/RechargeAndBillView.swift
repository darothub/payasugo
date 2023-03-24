//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 15/08/2022.
//

import SwiftUI
import Theme
import CoreUI
import Core
struct RechargeAndBillView: View {
    @State var rechargeAndBill = [MerchantService]()
    @State var navigateToBillForm = false
    @State var service = MerchantService()
    @State var bills = BillDetails(service: .init(), info: .init())
    @State var gotoAllRechargesView = false
    @EnvironmentObject var hvm: HomeViewModel
    @EnvironmentObject var navigation: NavigationUtils
    
    let gridColumn = [
        GridItem(.adaptive(minimum: 90))
    ]
    var body: some View {
        Section {
            VStack {
                heading()
                viewBody()
            }
        }.padding()
    }
    @ViewBuilder
    fileprivate func heading() -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Recharge & Bill payment")
                    .font(.system(size: PrimaryTheme.mediumTextSize))
                    .foregroundColor(.black)
                Text("Recharge or pay for")
                    .font(.system(size: PrimaryTheme.smallTextSize))
                    .foregroundColor(.black)
                Spacer()
            }
            Spacer()
            Group {
                Text("See all")
                    .font(.system(size: PrimaryTheme.smallTextSize))
                    .foregroundColor(.black)
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
            }.onTapGesture(perform: onClickSeeAll)
        }
    }
    private func onClickSeeAll() {
        let selectedBiller = hvm.categoryNameAndServices
        let categoryNameAndServices = hvm.categoryNameAndServices.keys
            .sorted(by: <)
            .map{TitleAndListItem(title: $0, services: selectedBiller[$0]!)}
        withAnimation {
            navigation.navigationStack = [.home, .categoriesAndServices(categoryNameAndServices)]
        }
    }
    @ViewBuilder
    fileprivate func viewBody() -> some View {
        ServicesGridView(services: rechargeAndBill, showTitle: false) { service in
            if let bills = hvm.handleServiceAndNominationFilter(service: service, nomination: hvm.nominationInfo.getEntities()) {
                withAnimation {
                    navigation.navigationStack = [.home, .billFormView(bills)]
                }
            } else {
                hvm.rechargeAndBillUIModel = UIModel.error("Service not available")
            }
        }
    }
}

struct ServicesGridView: View {
    @State var services:[MerchantService] = .init()
    @State var showTitle = false
    @State var gridColumn = [
        GridItem(.adaptive(minimum: 90))
    ]
    @State var onclick: (MerchantService) -> Void = {_ in }
    var body: some View {
        LazyVGrid(columns: gridColumn, spacing: 0){
            ForEach(services, id: \.id) { service in
                VStack {
                    IconImageCardView(imageUrl: service.serviceLogo)
                        .padding(.vertical)
                        .onTapGesture {
                            print("Inner service")
                            onclick(service)
                        }
                    Text(service.serviceName)
                        .font(.caption)
                        .showIf($showTitle)
                }
            }
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
