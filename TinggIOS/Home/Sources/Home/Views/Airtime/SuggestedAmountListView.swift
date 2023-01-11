//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 07/10/2022.
//
import Core
import SwiftUI

struct SuggestedAmountListView: View {
    @Binding var sam: SuggestedAmountModel
    @State var selectedIndex = -1
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(sam.historyByAccountNumber, id: \.self) { amount in
                    let index = sam.historyByAccountNumber.firstIndex(of: amount)
                    let intAmount = convertStringToInt(value: amount )
                    let strAmount = "\(String(describing: intAmount))"
                    BoxedTextView(text: .constant(strAmount))
                        .onTapGesture {
                            if let tIndex = index {
                                selectedIndex = tIndex
                            }
                            sam.amount = amount
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
//            .background(index == selectedIndex ? .red : .white)
            
    }
}
struct SuggestedAmountListView_Previews: PreviewProvider {
    struct SuggestedAmountListViewHolder: View {
        var body: some View {
            SuggestedAmountListView(sam: .constant(.init()))
        }
    }
    static var previews: some View {
        SuggestedAmountListViewHolder()
    }
}


