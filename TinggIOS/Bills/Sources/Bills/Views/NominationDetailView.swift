//
//  NominationDetailView.swift
//  
//
//  Created by Abdulrasaq on 10/11/2022.
//

import Checkout
import Core
import CoreUI
import SwiftUI

public struct NominationDetailView: View {
    @StateObject var billViewModel: BillViewModel = BillsDI.createBillViewModel()
    @Environment(\.editMode) private var editMode
    @State var invoice: Invoice = sampleInvoice
    @State private var disableTextField: Bool = true
    @State private var imageUrl = ""
    let services = Observer<MerchantService>().getEntities()
    let transactionHistories = Observer<TransactionHistory>().getEntities()
    private var currentTransactionHistory: [TransactionHistory] {
        transactionHistories.filter { transaction in
            transaction.serviceID == invoice.serviceID && transaction.accountNumber == invoice.billReference
        }
    }
    private var chartData: [ChartData] {
        billViewModel.mapHistoryIntoChartData(transactionHistory: currentTransactionHistory)
    }
    public init(invoice: Invoice) {
        self._invoice = State(initialValue: invoice)
    }
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomTrailing) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        TopViewDesign(imageUrl: $imageUrl, geo: geo)
                        VStack(alignment: .leading) {
                            Text("Monthly Bill")
                                .textCase(.uppercase)
                                .padding(.top)
                                .padding(.horizontal)
                            Text(invoice.customerName)
                                .font(.title3)
                                .textCase(.uppercase)
                                .bold()
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                            VStack {
                                HTextAndTextFieldWithDivider(
                                    edittableText: invoice.customerName ,
                                    disableTextField: $disableTextField
                                )
                                HTextAndTextFieldWithDivider(
                                    text: "Account number",
                                    edittableText: invoice.billReference,
                                    disableTextField: $disableTextField
                                )
                                HTextAndTextFieldWithDivider(
                                    text: "Amount",
                                    edittableText: invoice.amount,
                                    disableTextField: $disableTextField
                                )
                                
                                HTextAndTextFieldWithDivider(
                                    text: "Due on",
                                    edittableText: invoice.dueDate,
                                    disableTextField: $disableTextField
                                )
                            }
                            .padding(.horizontal)
                            .shadowBackground()
                                                      
                            VStack(alignment: .leading) {
                                Text("Bill summary")
                                    .textCase(.uppercase)
                                ExpensesGraphView(chartData: chartData)
                            }
                            .padding()
                            .shadowBackground()
                            
                            VStack(alignment: .leading) {
                                Text("Transactions")
                                    .textCase(.uppercase)
                                ForEach(currentTransactionHistory, id:\.payerTransactionID) { transaction in
                                    SingleTransactionSummaryView(transaction: transaction)
                                }.listStyle(.plain)
                            }
                            .padding()
                            .shadowBackground()

                        }
                    }
                }.edgesIgnoringSafeArea(.all)
                HStack{
                    Image(systemName: "arrowshape.turn.up.left.fill")
                    Text("Pay bill")
                }
                .padding()
                .foregroundColor(.white)
                .textCase(.uppercase)
                .font(.caption)
                .background(.green)
                .cornerRadius(25)
                .someShadow(showShadow: .constant(true))
            }
        }
        .onChange(of: editMode?.wrappedValue) { newValue in
            if newValue != nil && newValue!.isEditing {
                disableTextField = false
            } else {
                disableTextField = true
                let service = services.first { service in
                    service.hubServiceID == invoice.serviceID
                }
                
                if let s = service {
                    let profileInfo = computeProfileInfo(service: s, accountNumber: invoice.billReference )
                    Task {
                       await billViewModel.handleMCPRequests(action: .UPDATE, profileInfoComputed: profileInfo)
                    }
                }
            }
        }
        .handleUIState(uiState: $billViewModel.serviceBillUIModel) { content in
            
        }
        .toolbar {
            EditButton()
                .foregroundColor(.white)
        }
        .onAppear {
            let service = Observer<MerchantService>().getEntities().first { $0.hubServiceID == invoice.serviceID
            }
            if let service = service {
                imageUrl = service.serviceLogo
            }
        }
    }
}
struct TopViewDesign: View {
    @Binding var imageUrl: String
    let geo: GeometryProxy
    var body: some View  {
        ZStack(alignment: .top) {
            TopBackground(color: .blue)
                .alignmentGuide(.top) { d in d[.bottom] * 0.17 }
                .frame(height: geo.size.height/5)
            HStack {
                IconImageCardView(imageUrl: imageUrl)
                Spacer()
            }.padding(.top, 100)
            .padding(.horizontal)
        }
    }
}
struct SingleTransactionSummaryView: View {
    @State var transaction: TransactionHistory = .init()
    var date: Date {
        makeDateFromString(validDateString: transaction.paymentDate)
    }
    var status: TransactionStatus {
        if let status: TransactionStatus = .init(rawValue: transaction.status){
            return status
        }
        return TransactionStatus.failed
    }
    var color: Color {
        status == .success ? .green : .red
    }
    var body: some View {
        HStack {
            Image(systemName: status == .success ? "checkmark" : "xmark")
                .scaleEffect(0.5)
                .padding(5)
                .foregroundColor(color)
                .background(.gray.opacity(0.2))
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(transaction.amount)
                    .font(.caption)
                Text(date, style: .date)
                    .font(.caption)
            }
            Spacer()
            Text(status.rawValue)
                .font(.caption)
                .foregroundColor(color)
        }.onAppear {
            print("Transaction \(transaction)")
        }
    }
}
struct HTextAndTextFieldWithDivider: View {
    @State var text: String = "Account name"
    @State var edittableText: String
    @Binding var disableTextField: Bool
    var body: some View {
        HStack {
            Text(text)
                .font(.body)
            Spacer()
            TextField("text", text: $edittableText)
                .font(.body)
                .multilineTextAlignment(.trailing)
                .disabled(disableTextField)
        }
        Divider()
    }
}

struct NominationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NominationDetailView(invoice: sampleInvoice)
    }
}



