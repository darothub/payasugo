//
//  DebitCardDropDownView.swift
//  
//
//  Created by Abdulrasaq on 19/12/2022.
//
import Core
import SwiftUI

struct DebitCardDropDownView: View {
    @Binding var dcddm: DebitCardDropDownModel
    var body: some View {
        VStack {
            HStack {
                DebitCardView(model: $dcddm.selectedCardDetails)
                Image(systemName: dcddm.showDropDown ? "chevron.up":"chevron.down")
                    .foregroundColor(.black)
            }
            .padding(20)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(.black)
            }
            .onTapGesture {
                dcddm.showDropDown.toggle()
            }
            List {
                showCards()
               
            }.listStyle(.plain)
            .showIf($dcddm.showDropDown)
        }.background(.white)
  
    }
    @ViewBuilder
    fileprivate func showCards() -> some View {
        ForEach(dcddm.cardDetails, id: \.cardAlias) { card in
            DebitCardView(model: .constant(card))
                .padding()
                .onTapGesture {
                    withAnimation {
                        dcddm.selectedCardDetails = card
                        dcddm.showDropDown.toggle()
                    }
                }
        }.listRowInsets(EdgeInsets())
        .padding(.vertical)
    }
}

struct DebitCardDropDownView_Previews: PreviewProvider {
    struct DebitCardDropDownViewPreview: View {
        @State var dcddm: DebitCardDropDownModel = .init()
        var body: some View {
            DebitCardDropDownView(dcddm:
                    $dcddm
            )
        }
    }
    static var previews: some View {
        DebitCardDropDownViewPreview()
    }
}
