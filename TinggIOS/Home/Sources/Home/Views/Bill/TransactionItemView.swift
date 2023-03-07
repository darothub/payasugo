//
//  TransactionItemView.swift
//  
//
//  Created by Abdulrasaq on 27/02/2023.
//
import Checkout
import Core
import Common
import SwiftUI

struct TransactionItemView: View {
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    @State private var view = AnyView(EmptyView())
    private var color: Color {
        switch model.status {
        case .success:
            return .green
        case .failed:
            return .red
        case .pending:
            return .orange
        }
    }
    @State var model: TransactionItemModel = TransactionItemModel.sample
    
    @State private var isFullScreen = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                IconImageCardView(imageUrl: model.imageurl, radius: 0, y: 0, shadowRadius: 0)
                VStack(alignment: .leading) {
                    Text(model.service.serviceName)
                    Text(model.accountNumber)
                    Text("\(model.date, formatter: Date.mmddyyFormat)")
                }.font(.caption)
                Spacer()
                VStack(alignment: .leading) {
                    Text(model.amount, format: .currency(code: "\(model.currency)"))
                    Text("Paid via \(model.payer.clientName!)")
                    Text(model.status.rawValue)
                        .foregroundColor(color)
                }.font(.caption)
                Spacer()
                Menu {
                    Button("View receipt", action: viewReceipt)
                    Button("Buy again", action: gotoCheckout)
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .fullScreenCover(isPresented: $isFullScreen, onDismiss: {
            //Dismiss
            log(message: "Receipt dismissed")
        }) {
           handleFullScreen()
        }
    }
    private func viewReceipt() -> Void {
        isFullScreen.toggle()
    }
    
    private func gotoCheckout() -> Void {
        let enrollments = filterNomination(by: model.service)
        let selectedNetwork = model.service.serviceName
        let fem = FavouriteEnrollmentModel(enrollments: enrollments, accountNumber: model.accountNumber, selectedNetwork: selectedNetwork)
        let sam = SuggestedAmountModel(amount: "\(model.amount)", currency: model.currency)
        checkoutVm.fem = fem
        checkoutVm.sam = sam
        checkoutVm.service = model.service
        log(message: "\(model.service)")
        checkoutVm.showView = true
    }
    
    private func handleFullScreen() -> some View {
        DispatchQueue.main.async {
            view = AnyView(SingleReceiptView(color: color, model: model))
        }
        return FullScreen(isFullScreen: $isFullScreen, view: view, color: color)
    }

}

struct TransactionItemModel: Identifiable, Comparable, Hashable {
    static func < (lhs: TransactionItemModel, rhs: TransactionItemModel) -> Bool {
        lhs.date < rhs.date
    }
    
    var id = UUID().description
    var imageurl: String = ""
    var accountNumber: String = "000000"
    var date: Date = .distantPast
    var amount: Double = 72.3
    var currency: String = AppStorageManager.getCountry()?.currency ?? "KES"
    var payer: MerchantPayer = .init()
    var service: MerchantService = sampleServices[0]
    var status: TransactionStatus = .pending
    
    static var sample = TransactionItemModel()
    static var sample2 = TransactionItemModel(date: Date.distantPast)
    
}

struct TransactionSectionModel: Identifiable, Comparable {
    static func < (lhs: TransactionSectionModel, rhs: TransactionSectionModel) -> Bool {
        lhs.list[0].date > rhs.list[0].date
    }
    
    var id = UUID().description
    var header: String {
        list[0].date.formatted(with: "EEEE, dd MMMM yyyy")
    }
    var list = [TransactionItemModel.sample, TransactionItemModel.sample2]
    static var sample = TransactionSectionModel()
    static var sample2 = TransactionSectionModel()
}

struct TransactionItemView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionItemView(model: .init())
    }
}
