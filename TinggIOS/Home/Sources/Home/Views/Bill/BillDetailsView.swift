//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 06/09/2022.
//
import Common
import Theme
import SwiftUI
import Core
public struct BillDetailsView: View {
    @State var fetchBill: Invoice = sampleInvoice
    @State var service: MerchantService = sampleServices[0]
    @State var textFieldText = ""
    @State var amount = ""
    @State var dueDate = ""
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var navUtils: NavigationUtils
    var dueDateComputed: String {
        let date = makeDateFromString(validDateString: fetchBill.estimateExpiryDate)
        return date.formatted(with: "EE, dd MM yyyy")
    }
    var amountComputed: String {
        fetchBill.currency + String(fetchBill.amount)
    }
    var profileInfoComputed: String {
        computeProfileInfo(service: service, accountNumber: fetchBill.billReference)
    }
    @State var isNewAccountNumber = false
    public init(fetchBill: Invoice, service: MerchantService ) {
        self._fetchBill = State(initialValue: fetchBill)
        self._service = State(initialValue: service)
    }
    public var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .top) {
                    TopBackground()
                        .alignmentGuide(.top) { d in d[.bottom] * 0.4 }
                        .frame(height: geo.size.height * 0.1)
                    RemoteImageCard(imageUrl: service.serviceLogo )
                        .scaleEffect(1.2)
                }
                Text(fetchBill.biller)
                    .padding([.horizontal, .top], 20)
                    .font(.system(size: PrimaryTheme.mediumTextSize).bold())
                    .foregroundColor(.black)
                Text(fetchBill.billReference)
                    .font(.system(size: PrimaryTheme.smallTextSize))
                    .foregroundColor(.black)
                Group {
                    TextFieldView(
                        fieldText: $fetchBill.billReference,
                        label: service.referenceLabel ,
                        placeHolder: service.referenceLabel
                    )
                    TextFieldView(
                        fieldText: $fetchBill.customerName,
                        label: "Account name",
                        placeHolder: fetchBill.customerName
                    )
                    TextFieldView(
                        fieldText: $amount,
                        label: "Bill found",
                        placeHolder: amount
                    )
                    TextFieldView(
                        fieldText: $dueDate,
                        label: "Due date",
                        placeHolder: dueDate
                    )
                }
                .disabled(true)
                .padding(.top, 10)
                Spacer()
                HStack {
                    outlinebutton(
                        backgroundColor: PrimaryTheme.getColor(.primaryColor),
                        buttonLabel: "Save bill"
                    ) {
                        homeViewModel.handleMCPRequests(action: .ADD, profileInfoComputed: profileInfoComputed)
                    }
                    .disabled(isNewAccountNumber ? false: true)
                    .handleViewStates(uiModel: $homeViewModel.serviceBillUIModel, showAlert: $homeViewModel.showAlert)
                    
                    button(
                        backgroundColor: PrimaryTheme.getColor(.primaryColor),
                        buttonLabel: "Pay bill"
                    ) {
                        //Todo
                    }
                }
            }
        }.onAppear {
            amount = amountComputed
            dueDate = dueDateComputed
            homeViewModel.observeUIModel(model: homeViewModel.$serviceBillUIModel) { content in
                let bill = content.data as! Bill
                let enrol = bill.convertBillToEnrollment(accountNumber: bill.merchantAccountNumber, service: service)
                homeViewModel.nominationInfo.$objects.append(enrol)
                navUtils.navigationStack = [.home]
            }
            isNewAccountNumber = homeViewModel.nominationInfo.getEntities().first { e in
                e.accountNumber == fetchBill.billReference
            } == nil
           
        }
    }
}

struct BillDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BillDetailsView(fetchBill: sampleInvoice, service: sampleServices[0])
            .environmentObject(HomeDI.createHomeViewModel())
    }
}

