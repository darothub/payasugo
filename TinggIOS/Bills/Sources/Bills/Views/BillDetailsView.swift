//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 06/09/2022.
//
import CoreUI
import CoreNavigation
import Theme
import SwiftUI
import Core
public struct BillDetailsView: View {
    @State var fetchBill: Invoice = sampleInvoice
    @State var service: MerchantService = sampleServices[0]
    @State private var amount = ""
    @State private var dueDate = ""
    @State private var isNewAccountNumber = false
    private var enrollments = Observer<Enrollment>().getEntities()
    @EnvironmentObject var billViewModel: BillViewModel
    @EnvironmentObject var navUtils: NavigationManager
    private var dueDateComputed: String {
        let date = makeDateFromString(validDateString: fetchBill.estimateExpiryDate)
        return date.formatted(with: "EE, dd MM yyyy")
    }
    private var amountComputed: String {
        fetchBill.currency + String(fetchBill.amount)
    }
    private var profileInfoComputed: String {
        computeProfileInfo(service: service, accountNumber: fetchBill.billReference)
    }
    
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
                    IconImageCardView(imageUrl: service.serviceLogo )
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
                .padding(.horizontal)
                Spacer()
                HStack {
                    TinggOutlineButton(
                        backgroundColor: PrimaryTheme.getColor(.primaryColor),
                        buttonLabel: "Save bill"
                    ) {
                        Task {
                            await billViewModel.handleMCPRequests(action: .ADD, profileInfoComputed: profileInfoComputed)
                        }
                    }
                    .disabled(isNewAccountNumber ? false: true)
                    .handleUIState(uiState: $billViewModel.serviceBillUIModel)
                    
                    TinggButton(
                        backgroundColor: PrimaryTheme.getColor(.primaryColor),
                        buttonLabel: "Pay bill"
                    ) {
                        //Todo
                    }  .padding()
                }
            }
        }
    
        .background(.white)
        .onAppear {
            amount = amountComputed
            dueDate = dueDateComputed
            isNewAccountNumber = enrollments.first { e in
                e.accountNumber == fetchBill.billReference
            } == nil
           
        }
        .handleViewStatesMods(uiState: billViewModel.$serviceBillUIModel) { content in
            log(message: content)
            if let bill = content.data as? Bill {
                let enrol = bill.convertBillToEnrollment(accountNumber: bill.merchantAccountNumber, service: service)
                Observer<Enrollment>().$objects.append(enrol)
                navUtils.navigateTo(screen: Screens.home)
            }
        }
    }
}

struct BillDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BillDetailsView(fetchBill: sampleInvoice, service: sampleServices[0])
            .environmentObject(BillsDI.createBillViewModel())
    }
}

