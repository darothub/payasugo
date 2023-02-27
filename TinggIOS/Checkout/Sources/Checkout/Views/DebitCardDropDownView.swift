//
//  SwiftUIView.swift
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
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 0.5)
            }
            .onTapGesture {
                dcddm.showDropDown.toggle()
            }
            List {
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
            }.listStyle(.plain)
            .showIf($dcddm.showDropDown)
        
        }
  
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