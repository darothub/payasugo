//
//  TransactionItemView.swift
//  
//
//  Created by Abdulrasaq on 27/02/2023.
//
import Core
import Common
import SwiftUI

struct TransactionItemView: View {
    var model: TransactionItemModel
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
                HStack {
                    VStack(alignment: .leading) {
                        Text(model.amount, format: .currency(code: "\(model.currency)"))
                        Text("Paid via \(model.payer.clientName!)")
                        Text(model.status.rawValue)
                            .foregroundColor(model.status == .pending ? .orange : .green)
                    }.font(.caption)
                }
                Spacer()
                Image(systemName: "info.circle")
            }
        }
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
    var currency: String = "KES"
    var payer: MerchantPayer = .init()
    var service: MerchantService = sampleServices[0]
    var status: TransactionStatus = .pending
    
    static var sample = TransactionItemModel()
    static var sample2 = TransactionItemModel(date: Date.distantPast)
    
}

struct TransactionSectionModel: Identifiable {
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
