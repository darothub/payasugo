//
// MARK: BillView.swift
//  
//
//  Created by Abdulrasaq on 20/09/2022.
//
import Checkout
import CoreUI
import Core
import SwiftUI
import Theme
import CoreNavigation
/// Shows a tab for users bills and receipt
public struct BillView: View {
    public static var RECEIPTVIEW_TITLE = "RECEIPTS"
    public static var MYBILLVIEW_TITLE = "MY BILLS"
    private var profileImageUrl: String {
        (Observer<Profile>().getEntities().first?.photoURL) ?? ""
    }
    private var secondaryColor: Color {
        PrimaryTheme.getColor(.secondaryColor)
    }
    @State var colorTint:Color = .blue
    @State var color: Color = .green
    @State var items: [TabLayoutItem] = sampleItem

    @State var isFullScreen = false
    @State var sections: [TransactionSectionModel] = []
    @StateObject var billViewModel = BillsDI.createBillViewModel()
    @EnvironmentObject var navigation: NavigationManager
    @State var selectedTab: Tab = .first
    let transactionHistory = Observer<TransactionHistory>().getEntities()
    public init(selectedTab: Tab = .first) {
        self._selectedTab = State(initialValue: selectedTab)
    }
    public var body: some View {
        VStack(spacing: 0) {
            ProfileImageAndHelpIconView(imageUrl: profileImageUrl, title: "My Bills")
                .background(color)
            DynamicTabView(items: items, selectedTab: selectedTab, tabColor: color)
        }
        .onAppear {
            color = secondaryColor
            let transactionListModels = transactionHistory.map { t in
                let service = Observer<MerchantService>().getEntities().first { s in
                    s.hubServiceID == t.serviceID
                }

                let payer = Observer<MerchantPayer>().getEntities().first { p in
                    p.hubClientID == t.payerClientID
                }
                let serviceLogo = t.serviceLogo ?? ""
                let accountNumber = t.accountNumber ?? "0"
                let dateCreated = makeDateFromString(validDateString: t.dateCreated ?? "")
                let amount = Double(t.amount.convertStringToInt())
                let currency = AppStorageManager.getCountry()?.currency ?? "KE"
                let model = TransactionItemModel(
                    id: t.beepTransactionID,
                    imageurl: serviceLogo,
                    accountNumber: accountNumber,
                    date: dateCreated,
                    amount: amount,
                    currency: currency,
                    payer: payer ?? .init(),
                    service: service ?? .init(),
                    status: TransactionStatus(rawValue:  t.status)!
                )
                return model
            }

            let dict = Dictionary(grouping: transactionListModels) {$0.date.formatted(with: "EEEE, dd MMMM yyyy")}
            let sectionsModels = dict.map { (k, v) in
                TransactionSectionModel(list: v)
            }.sorted()
            sections = sectionsModels
            let receiptViewContent = AnyView(TransactionListView(listOfModel: sections))

            let myBilViewContent = MyBillView()
                .environmentObject(navigation)
                .environmentObject(billViewModel)

            withAnimation {
                items = [
                    TabLayoutItem(title: BillView.MYBILLVIEW_TITLE, view: AnyView(myBilViewContent)),
                    TabLayoutItem(title: BillView.RECEIPTVIEW_TITLE, view: AnyView(receiptViewContent))
                ]
            }
        }
        
    }
}

struct BillView_Previews: PreviewProvider {
    static var previews: some View {
        BillView()
            .environmentObject(NavigationManager.shared)
    }
}

