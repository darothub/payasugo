//
//  SwiftUIView.swift
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
    @State var items = [
        TabLayoutItem(title: "MY BILLS", view: AnyView(MyBillView())),
        TabLayoutItem(title: "RECEIPTS", view: AnyView(TransactionListView()))
    ]
    var secondaryColor: Color {
        PrimaryTheme.getColor(.secondaryColor)
    }
    public init() {
        // Intentionally unimplemented...
    }
    public var body: some View {
        VStack(spacing: 0) {
            ProfileImageAndHelpIconView(imageUrl: profileImageUrl, title: "My Bills")
                .background(secondaryColor)
            CustomTabView(items: items, tabColor: $color)
        }.onAppear {
            color = secondaryColor
            let transactions = Observer<TransactionHistory>().getEntities()
            let transactionListModels = transactions.map { t in
                if let service = t.service, let payer = t.payer {
                    let serviceLogo = t.serviceLogo ?? ""
                    let accountNumber = t.accountNumber ?? "0"
                    let dateCreated = makeDateFromString(validDateString: t.dateCreated ?? "")
                    let amount = Double(t.amount.convertStringToInt())
                    let currency = AppStorageManager.getCountry()?.currency ?? "KE"
                    let model = TransactionItemModel(
                        imageurl: serviceLogo,
                        accountNumber: accountNumber,
                        date: dateCreated,
                        amount: amount,
                        currency: currency,
                        payer: payer,
                        service: service,
                        status: TransactionStatus(rawValue:  t.status)!
                    )
                    return model
                }
                return TransactionItemModel()
            }
            
           
            let dict = Dictionary(grouping: transactionListModels) {$0.date}
            let sections = dict.map { (k, v) in
                TransactionSectionModel(list: v)
            }
            let view = AnyView(TransactionListView(listOfModel: sections))
            let tabItem = TabLayoutItem(title: "RECEIPTS", view: AnyView(view))
            items.append(tabItem)
        }
    }
}

struct BillView_Previews: PreviewProvider {
    static var previews: some View {
        BillView()
            .environmentObject(HomeDI.createHomeViewModel())
    }
}
