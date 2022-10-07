//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 07/10/2022.
//
import Core
import SwiftUI

struct SuggestedAmountListView: View {
    @State var history: [TransactionHistory] = .init()
    @Binding var amount: String
    @Binding var accountNumber: String
    var historyByAccountNumber: [TransactionHistory] {
        history.filter {$0.accountNumber == accountNumber}
    }
    @State var selectedIndex = -1
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(historyByAccountNumber, id: \.payerTransactionID) { transaction in
                    let index = historyByAccountNumber.firstIndex(of: transaction)
                    let floatValue = Float(transaction.amount ?? "10.0")
                    let intAmount = Int(floatValue ?? 0.0)
                    let strAmount = "\(String(describing: intAmount))"
                    BoxedTextView(text: .constant(strAmount))
                        .background(index == selectedIndex ? .red : .white)
                        .onTapGesture {
                            if let tIndex = index {
                                selectedIndex = tIndex
                            }
                            if let tAmount = transaction.amount {
                                amount = tAmount
                            }
                        }
                }
            }
        }
    }
}

struct BoxedTextView: View {
    @Binding var text: String
    var body: some View {
        Text(text)
            .frame(width: 40)
            .padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 0.1)
            ).foregroundColor(.black)
            
    }
}
struct SuggestedAmountListView_Previews: PreviewProvider {
    struct SuggestedAmountListViewHolder: View {
        @State var number = "200"
        @State var accountNumber: String = ""
        var historys: [TransactionHistory] {
            let hist1 = TransactionHistory.init()
            hist1.payerTransactionID = "1"
            hist1.amount = "100"
            let hist2 = TransactionHistory.init()
            hist2.payerTransactionID = "2"
            hist2.amount = "10"
            return [hist1, hist2]
        }
        var body: some View {
            SuggestedAmountListView(history: historys, amount: $number, accountNumber: $accountNumber)
        }
    }
    static var previews: some View {
        SuggestedAmountListViewHolder()
    }
}
