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
    @State var navigateBillDetailsView = false
    @State var isNewInput = false
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
                        fetchBill: homeViewModel.singleBillInvoice,
                        service: billDetails.service, isNewInput: $isNewInput
                    )
                    .environmentObject(homeViewModel),
                    isActive: $navigateBillDetailsView) {
                    button(
                        backgroundColor: PrimaryTheme.getColor(.primaryColor),
                        buttonLabel: "Get bill"
                    ) {
                        homeViewModel.getSingleDueBill(
                            accountNumber: accountNumber,
                            serviceId: billDetails.service.hubServiceID
                        )
                        isNewInput = accountNumberList.contains(accountNumber)
                    }.handleViewStates(uiModel: $homeViewModel.uiModel, showAlert: .constant(false))
                }
            }
        }.onAppear {
            homeViewModel.observeUIModel(model: homeViewModel.$uiModel) { content in
                let invoice = content.data as! Invoice
                print("Invoice \(invoice)")
                navigateBillDetailsView.toggle()
            }
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
    @State var color = Color.gray.opacity(0.3)
    var body: some View {
        Rectangle()
            .foregroundColor(color)
            .edgesIgnoringSafeArea(.all)
    }
}


