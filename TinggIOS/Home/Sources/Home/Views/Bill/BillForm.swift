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
    @EnvironmentObject var navUtils: NavigationUtils
    @Binding var billDetails: BillDetails
    @StateObject var homeViewModel = HomeDI.createHomeViewModel()
    @State private var accountNumber: String = ""
    @State private var invoice: Invoice = .init()
    @State private var navigateBillDetailsView = false
    var accountNumberList: [String] {
        billDetails.info.map { info in
            info.accountNumber
        }.filter { !$0.isEmpty }
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
                    IconImageCardView(imageUrl: billDetails.service.serviceLogo)
                        .scaleEffect(1.2)
                }
                Text(billDetails.service.serviceName)
                    .padding(20)
                    .font(.system(size: PrimaryTheme.mediumTextSize).bold())
                    .foregroundColor(.black)
                
                DropDownView(
                    selectedText: $accountNumber,
                    dropDownList: .constant(accountNumberList),
                    label: "Enter your \(billDetails.service.referenceLabel)",
                    placeHoder: billDetails.service.referenceLabel
                ).padding()
                Spacer()
                button(
                    backgroundColor: PrimaryTheme.getColor(.primaryColor),
                    buttonLabel: "Get bill"
                ) {
                    homeViewModel.getSingleDueBill(
                        accountNumber: accountNumber,
                        serviceId: billDetails.service.hubServiceID
                    )
                 
                }.handleViewStates(uiModel: $homeViewModel.uiModel, showAlert: $homeViewModel.showAlert)
            }
        }.onAppear {
            homeViewModel.observeUIModel(model: homeViewModel.$uiModel, subscriptions: &homeViewModel.subscriptions) { content in
                let invoice = content.data as! Invoice
                invoice.enrollment = billDetails.info.first(where: { e in
                    e.accountNumber == self.accountNumber
                })
                self.invoice = invoice
                Observer<Invoice>().saveEntity(obj: invoice)
                navUtils.navigationStack = [
                    .billFormView(billDetails),
                    .billDetailsView(invoice, billDetails.service)
                ]
            } onError: { err in
                print("BILLFORM: \(err)")
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





