//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 07/10/2022.
//
import SwiftUI

public struct SuggestedAmountListView: View {
    @Binding var accountNumberHistory: [String]
    @Binding var amountSelected: String
    @State var selectedIndex = -1
    public init(accountNumberHistory: Binding<[String]>, amountSelected: Binding<String>, selectedIndex: Int = 1) {
        self._accountNumberHistory = accountNumberHistory
        self._amountSelected = amountSelected
        self.selectedIndex = selectedIndex
    }
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(accountNumberHistory, id: \.self) { amount in
                    let index = accountNumberHistory.firstIndex(of: amount)
                    let intAmount = convertStringToInt(value: amount )
                    let strAmount = "\(String(describing: intAmount))"
                    BoxedTextView(text: .constant(strAmount))
                        .background(index == selectedIndex ? .red : .white)
                        .onTapGesture {
                            if let tIndex = index {
                                selectedIndex = tIndex
                            }
                            amountSelected = amount
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
        @State var amount = "Safaricom"
        var body: some View {
            SuggestedAmountListView(accountNumberHistory: .constant([String]()), amountSelected: $amount)
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
