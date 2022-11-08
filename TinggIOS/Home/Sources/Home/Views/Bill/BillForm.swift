//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 05/09/2022.
//

import SwiftUI
import Common
import Theme
import Core
public struct BillFormView: View {
    @State var accountNumber: String = ""
    @Binding var billDetails: BillDetails
    @StateObject var homeViewModel = HomeDI.createHomeViewModel()
    var accountNumberList: [String] {
        billDetails.info.map { info in
            info.accountNumber!
        }
    }
    public init(billDetails: Binding<BillDetails> ) {
        self._billDetails = billDetails
    }
    public var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .top) {
                    TopBackground()
                        .alignmentGuide(.top) { d in d[.bottom] * 0.4 }
                        .frame(height: geo.size.height * 0.1)
                    RemoteImageCard(imageUrl: billDetails.service.serviceLogo)
                        .scaleEffect(1.2)
                }
                Text(billDetails.service.serviceName)
                    .padding(20)
                    .font(.system(size: PrimaryTheme.mediumTextSize).bold())
                    .foregroundColor(.black)
                
                DropDownView(
                    selectedText: $accountNumber,
                    dropDownList: accountNumberList,
                    label: "Enter your \(billDetails.service.referenceLabel)",
                    placeHoder: billDetails.service.referenceLabel
                ).padding()
                Spacer()
                NavigationLink(
                    destination: BillDetailsView(
                        fetchBill: homeViewModel.singleBill,
                        service: billDetails.service)
                    .environmentObject(homeViewModel),
                    isActive: $homeViewModel.navigateBillDetailsView) {
                    button(
                        backgroundColor: PrimaryTheme.getColor(.primaryColor),
                        buttonLabel: "Get bill"
                    ) {
                        homeViewModel.getSingleDueBill(
                            accountNumber: accountNumber,
                            serviceId: billDetails.service.hubServiceID
                        )
                    }.handleViewState(uiModel: $homeViewModel.uiModel)
                }
            }
        }.onAppear {
            print("AccountList \(accountNumberList) Account \(billDetails.info)")
        }
    }
}

struct BillFormView_Previews: PreviewProvider {
    struct BillFormViewHolder: View {
        @State var service: MerchantService = sampleServices[0]
        @State var bills = BillDetails(service: sampleServices[0], info: sampleNominations)
        var body: some View {
            BillFormView(billDetails: $bills)
        }
    }
    static var previews: some View {
        BillFormViewHolder()
    }
}


struct TopBackground: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.gray.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
    }
}


