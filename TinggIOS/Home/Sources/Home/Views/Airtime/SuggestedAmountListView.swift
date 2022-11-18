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
    @Binding var selectedServiceName: String
    @Binding var amount: String
    @Binding var accountNumber: String
    var historyByAccountNumber: [String] {
       Set(
            history.filter {
                ($0.accountNumber == accountNumber) &&
                ($0.serviceName == selectedServiceName)
            }.map{$0.amount ?? "10.0"}
       ).sorted(by: <)
        
    }
    @State var selectedIndex = -1
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(historyByAccountNumber, id: \.self) { amount in
                    let index = historyByAccountNumber.firstIndex(of: amount)
                    let intAmount = convertStringToInt(value: amount )
                    let strAmount = "\(String(describing: intAmount))"
                    
                    BoxedTextView(text: .constant(strAmount))
                        .background(index == selectedIndex ? .red : .white)
                        .onTapGesture {
                            if let tIndex = index {
                                selectedIndex = tIndex
                            }
                            self.amount = amount
                        }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.white)
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
        @State var serviceName = "Safaricom"
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
            SuggestedAmountListView(history: historys, selectedServiceName: $serviceName, amount: $number, accountNumber: $accountNumber)
        }
    }
    static var previews: some View {
        SuggestedAmountListViewHolder()
    }
}

func convertStringToInt(value: String) -> Int {
    let floatValue = Float(value)
    let intAmount = Int(floatValue ?? 0.0)
    return intAmount
}
