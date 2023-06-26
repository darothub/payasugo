//
// MARK: BillView.swift
//  
//
//  Created by Abdulrasaq on 20/09/2022.
//
import CoreUI
import Core
import SwiftUI
import Theme
import CoreNavigation
/// Shows a tab for users bills and receipt
public struct BillView: View {
    @State var profileImageUrl: String = ""
    @State var color: Color = .green
    @State var items: [TabLayoutItem<AnyView>] =  []
    @State var receiptView = TabLayoutItem(title: BillView.RECEIPTVIEW_TITLE)
    @State var myBillView = TabLayoutItem(title: BillView.MYBILLVIEW_TITLE)
    var secondaryColor: Color {
        PrimaryTheme.getColor(.secondaryColor)
    }
    @State var isFullScreen = false
    @State var sections: [TransactionSectionModel] = []
    static var RECEIPTVIEW_TITLE = "RECEIPTS"
    static var MYBILLVIEW_TITLE = "MY BILLS"
    public init() {
        //
    }
    public var body: some View {
        VStack(spacing: 0) {
            ProfileImageAndHelpIconView(imageUrl: $profileImageUrl, title: "My Bills")
                .background(secondaryColor)
            CustomTabView(items: $items, tabColor: $color, selectedTab: BillView.MYBILLVIEW_TITLE)
        }.onAppear {
            profileImageUrl = (Observer<Profile>().getEntities().first?.photoURL) ?? ""
            color = secondaryColor
            let transactions = Observer<TransactionHistory>().getEntities()
            let transactionListModels = transactions.map { t in
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
//

            let dict = Dictionary(grouping: transactionListModels) {$0.date.formatted(with: "EEEE, dd MMMM yyyy")}
            let sectionsModels = dict.map { (k, v) in
                TransactionSectionModel(list: v)
            }.sorted()
            sections = sectionsModels
//
            let receiptViewContent = AnyView(TransactionListView(listOfModel: $sections))
            receiptView.setContent {
                receiptViewContent
            }
            let myBilViewContent = MyBillView()
                .environmentObject(HomeDI.createHomeViewModel())
                .environmentObject(NavigationUtils())
            myBillView.setContent {
                AnyView(myBilViewContent)
            }
            withAnimation {
                items = [
                    myBillView,
                    receiptView
                ]
            }
        }
    }
}

struct BillView_Previews: PreviewProvider {
    static var previews: some View {
        BillView()
    }
}
