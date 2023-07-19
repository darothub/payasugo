//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 05/09/2022.
//

import SwiftUI
import CoreUI
import CoreNavigation
import Theme
import Core
public struct BillFormView: View {
    @EnvironmentObject var navUtils: NavigationManager
    @Binding var billDetails: BillDetails
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var accountNumber: String = ""
    @State private var invoice: Invoice = .init()
    @State private var navigateBillDetailsView = false
    @State private var showDropDown = false
    @State var accountNumberList: [String] = []
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
                    IconImageCardView(imageUrl: billDetails.service.serviceLogo)
                        .scaleEffect(1.2)
                }
                Text(billDetails.service.serviceName)
                    .padding(20)
                    .font(.system(size: PrimaryTheme.mediumTextSize).bold())
                    .foregroundColor(.black)
                
                DropDownView(
                    selectedText: $accountNumber,
                    dropDownList: $accountNumberList,
                    showDropDown: $showDropDown,
                    label: "Enter your \(billDetails.service.referenceLabel)",
                    placeHoder: billDetails.service.referenceLabel,
                    maxHeight: .infinity
                ).padding()
                Spacer()
                TinggButton(
                    backgroundColor: PrimaryTheme.getColor(.primaryColor),
                    buttonLabel: "Get bill"
                ) {
                    let request: RequestMap = RequestMap.Builder()
                        .add(value: "FB", for: .SERVICE)
                        .add(value: accountNumber, for: .ACCOUNT_NUMBER)
                        .add(value: 1, for: "IS_MULTIPLE")
                        .add(value: billDetails.service.hubServiceID, for: .SERVICE_ID)
                        .build()
           
                    homeViewModel.getSingleDueBill(
                        request: request
                    )
                }
                .padding()
            }
            .background(.white)
            .onAppear {
               let list = billDetails.info.map { info in
                    info.accountNumber
                }.filter { !$0.isEmpty }
                accountNumberList = list
            }
        }
        .handleViewStatesMods(uiState: homeViewModel.$singleBillUIModel) { content in
            let invoice = content.data as!  Invoice
            invoice.enrollment = billDetails.info.first(where: { e in
                e.accountNumber == self.accountNumber
            })
            self.invoice = invoice
            Observer<Invoice>().saveEntity(obj: invoice)
//            navUtils.navigateTo(
//                screen: HomeScreen.billDetailsView(invoice, billDetails.service)
//            )
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
            .environmentObject(HomeDI.createHomeViewModel())
    }
}


struct TopBackground: View {
    @State var color = Color.gray.opacity(0.3)
    var body: some View {
        Rectangle()
            .foregroundColor(color)
            .edgesIgnoringSafeArea(.all)
    }
}





