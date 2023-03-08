//
// MARK: BillView.swift
//  
//
//  Created by Abdulrasaq on 20/09/2022.
//
import Common
import Core
import SwiftUI
import Theme
/// Shows a tab for users bills and receipt
public struct BillView: View {
    @State var profileImageUrl: String = ""
    @State var color: Color = .green
    @State var items:[TabLayoutItem] = []

    var secondaryColor: Color {
        PrimaryTheme.getColor(.secondaryColor)
    }
    @State var isFullScreen = false
    @State var sections: [TransactionSectionModel] = [.sample, .sample2]
    public init() {
        //
    }
    public var body: some View {
        VStack(spacing: 0) {
            ProfileImageAndHelpIconView(imageUrl: $profileImageUrl, title: "My Bills")
                .background(secondaryColor)
            CustomTabView(items: $items, tabColor: $color)
        }.onAppear {
            profileImageUrl = (Observer<Profile>().$objects.wrappedValue.first?.photoURL)!
            color = secondaryColor
            let transactions = Observer<TransactionHistory>().getEntities()
            let transactionListModels = transactions.compactMap { t in

                let service = Observer<MerchantService>().getEntities().first { s in
                    s.hubServiceID == t.serviceID
                }
                let payer = Observer<MerchantPayer>().getEntities().first { p in
                    p.hubClientID == t.payerClientID
                }
                if service?.serviceName != "Unknown" {
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
                return nil
            }

            
            let dict = Dictionary(grouping: transactionListModels) {$0.date.formatted(with: "EEEE, dd MMMM yyyy")}

            sections = dict.map { (k, v) in
                TransactionSectionModel(list: v)
            }.sorted()
            
            let view = AnyView(TransactionListView(listOfModel: $sections)) 

            let tabItem = TabLayoutItem(title: "RECEIPTS", view: AnyView(view))
            withAnimation {
                items = [
                    TabLayoutItem(title: "MY BILLS", view: AnyView(MyBillView())),
                    tabItem
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
