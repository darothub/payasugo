//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 22/08/2022.
//

import SwiftUI
import Theme
import Core
import CoreUI
import Checkout

public struct DueBillsView: View {
    @EnvironmentObject var billViewModel: BillViewModel
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    @State var fetchedBill: [DynamicInvoiceType] = []
    @Binding var isShowingBills: Bool
    @State var showErrorAlert = false
    @State var showSuccessAlert = false
    @State var updatedTimeString: String = ""
    @State var dueBillItems: [DueBillItem] = []
    @State var billType = DueBillType.dueBills
    @State var placeHolderText = "checking for bills.."
    @State var showDefaultHeader = true
    @State var newHeader: AnyView? = nil
    @Binding var isLoading: Bool
    private let now = Date.now
    var type: String {
         billType == .dueBills ? "due" : "upcoming"
    }
    public init(isShowingBills: Binding<Bool>, billType: DueBillType = .dueBills, newHeader: AnyView? = nil,  isLoading: Binding<Bool>) {
        self._isShowingBills = isShowingBills
        self._billType = State(initialValue: billType)
        self._isLoading = isLoading
    }
    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                PrimaryTheme.getImage(image: .tinggAssistImage)
                    .resizable()
                    .frame(width: 35, height: 35)
                tinggAssistAndBillText()
                Spacer()
            }.showIf($showDefaultHeader)
            
            newHeader
                .showIfNot($showDefaultHeader)
                
            
            ForEach($dueBillItems, id: \.accountNumber) { $bill in
                let nomination = Observer<Enrollment>().getEntities().first { e in
                    (e.accountNumber == bill.accountNumber) && (Double(bill.amount) ?? 1.0) > 0.0
                }
                //This will be removed
                let service = Observer<MerchantService>().getEntities().first { s in
                    s.serviceName == bill.serviceName
                }
                if let currentService = service, let currentNomination = nomination {
                    DueBillCardView(item: bill, updatedTimeString: $updatedTimeString) {
                        checkoutVm.toCheckoutWithANomination(currentService, nomination: currentNomination)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .shadow(radius: 3, x: 0, y: 3)
                    )
                }
               
            }
            .onAppear {
                showDefaultHeader = newHeader == nil
            }
        }
        .padding()
        .handleViewStatesModWithCustomShimmer(
            uiState: billViewModel.$fetchBillUIModel,
            showAlertOnError: false, shimmerView: AnyView(DueBillsShimmerView()),
            isLoading: $isLoading
        ) { content in
            let data = content.data as? [DynamicInvoiceType]
           
            let dict = data?.reduce(into: [DueBillType: [DueBillItem]]()) { partialResult, bill in
                let daysDiff = (makeDateFromString(validDateString: bill.dueDate) - now)
                let yearsDiff = (makeDateFromString(validDateString: bill.dueDate) - now)
                let dueDaysString = dueDayString(dueDaysNumber: daysDiff.day)
                let billType = getBillType(dueDays: daysDiff, dueYear: yearsDiff)
                let service = Observer<MerchantService>().getEntities().first { s in
                    s.hubServiceID == bill.serviceID
                }
                if let currentService = service, (bill.amount.toString.convertStringToInt() > 0) {
                    let billItem = DueBillItem(
                        serviceName: currentService.serviceName,
                        serviceImageString: currentService.serviceLogo,
                        beneficiaryName: bill.customerName,
                        accountNumber: bill.billReference,
                        amount: "\(bill.currency) \(bill.amount.toString)",
                        dueDate: dueDaysString,
                        billType: billType
                        
                    )
                    partialResult[billType, default: []].append(billItem)
                }
            }
            withAnimation {
                if let dict = dict, billType != .others {
                    dueBillItems = dict[billType, default: []]
                } else {
                    var newList = [DueBillItem]()
                    newList.append(contentsOf: (dict?[.dueBills, default: []])!)
                    newList.append(contentsOf: (dict?[.upcomingBills, default: []])!)
                    dueBillItems = newList
                }
                isShowingBills = dueBillItems.isNotEmpty()
            }
        } onFailure: { str in
            isShowingBills = false
        }
        .showIf($isShowingBills)
        .onDisappear {
            billViewModel.fetchBillUIModel = UIModel.nothing
        }
        
    
    }
    
    private func getBillType(dueDays: TimeInterval, dueYear: TimeInterval) -> DueBillType {
        let billType: DueBillType = (dueDays.day <= 2 && dueYear.year <= 5) ? .dueBills : (dueDays.day >= 3 && dueYear.year <= 5) ? .upcomingBills : .others
        return billType
    }
    
    @ViewBuilder
    private func tinggAssistAndBillText() -> some View {
        VStack(alignment: .leading) {
            Text("Tingg Assist")
                .bold()
                .foregroundColor(.black)
            Text("You have \(type) bills")
                .font(.caption)
                .foregroundColor(.black)
        }
    }
    func dueDayString(dueDaysNumber: Int) -> String {
        if dueDaysNumber < 0 {
            return "\(abs(dueDaysNumber)) day(s) ago"
        }
        else if dueDaysNumber == 0 {
            return "today"
        }
        else if dueDaysNumber == 1 {
            return "tomorrow"
        }
        else {
            return String(dueDaysNumber)+"days"
        }
    }
}

struct DueBillsView_Previews: PreviewProvider {
    static var previews: some View {
        DueBillsView(isShowingBills: .constant(true), isLoading: .constant(false))
            .environmentObject(BillsDI.createBillViewModel())
            .environmentObject(CheckoutDI.createCheckoutViewModel())
    }
}


struct DueBillCardView: View {
    @State private var barColor = Color.red
    @State var item: DueBillItem = .init()
    @Binding var updatedTimeString: String
    var action:() -> Void = {}
    var body: some View {
        HStack {
            Rectangle()
                     .fill(barColor)
                     .frame(width: 10, height: 90)
                     .cornerRadius(20, corners: [.topRight, .bottomRight])
            LeftHandSideView(serviceName: item.serviceName, serviceImageString: item.serviceImageString, beneficiaryName: item.beneficiaryName, accountNumber: item.accountNumber, updatedTimeString: $updatedTimeString)
            Spacer()
            RightHandSideView(amount: item.amount, dueDate: item.dueDate, action: action)
        }
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 10))
        .onAppear {
            barColor = item.billType == .dueBills ? item.dueDate == "today" ? .red : .orange : .gray
        }
    }
}
public struct DueBillItem: Identifiable {
    public var id: String = UUID().uuidString
    public var serviceName: String = "sample service"
    public var serviceImageString = ""
    public var beneficiaryName = "Sample Bene"
    public var accountNumber = "0900000"
    public var amount = "0.0"
    public var dueDate = "today"
    public var billType: DueBillType = .dueBills
    
}

struct LeftHandSideView: View {
    @State var serviceName: String = ""
    @State var serviceImageString = ""
    @State var beneficiaryName = ""
    @State var accountNumber = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var updatedTime: Int = 0
    @Binding var updatedTimeString: String
    var body: some View {
        HStack {
            IconImageCardView(imageUrl: serviceImageString, radius: 0, scaleEffect: 1.5, x: 0, y: 0, shadowRadius: 0)
            VStack(alignment: .leading) {
                Text("\(serviceName)")
                    .bold()
                    .font(.caption)
                    .foregroundColor(.black)
                Text("Updated at: \(updatedTimeString)")
                    .font(.caption)
                    .foregroundColor(.black)
                Text("\(beneficiaryName)")
                    .bold()
                    .textCase(.uppercase)
                    .font(.caption)
                    .foregroundColor(.black)
                Text("Acc No: \(accountNumber)")
                    .font(.caption)
                    .foregroundColor(.black)
            }
        }.onReceive(timer) { latest in
            updatedTime += 1
            updatedTimeString = updatedTimeInUnits(time: updatedTime)
        }
    }

}
struct RightHandSideView: View {
    @State var amount = "0.0"
    @State var dueDate = "today"
    var action:() -> Void = {}
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(amount)")
                .bold()
                .textCase(.uppercase)
                .font(.caption)
                .foregroundColor(.black)
            Text("Due: \(dueDate)")
                .font(.caption)
                .foregroundColor(.red)
            Button {
                print("Pay your")
            } label: {
                Text("Pay")
                    .frame(width: 50)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .font(.caption)
                    .background(.green)
                    .cornerRadius(25)
                    .onTapGesture {
                        action()
                    }
                   
            }
        }
    }
}

public enum DueBillType {
    case dueBills
    case upcomingBills
    case others
}



