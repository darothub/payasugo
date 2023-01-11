//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 19/12/2022.
//
import Common
import Core
import SwiftUI

struct DebitCardView: View {
    @Binding var model: CardDetailDTO
    var body: some View {
        HStack {
            IconImageCardView(imageUrl: model.logoUrl)
            VStack(alignment: .leading) {
                Text("Normal")
                Text("Debit ****\(model.cardAlias)")
            }
            Spacer()
        }
    }
}

struct DebitCardView_Previews: PreviewProvider {
    struct DebitCardViewPreviewHolder: View {
        @State var cardDto = CardDetailDTO(cardAlias: "0000", payerClientID: "162", cardType: "002", activeStatus: "1", logoUrl: "")
        var body: some View {
            DebitCardView(
                model:
                .constant(
                     cardDto
                )
            )
        }
    }
    static var previews: some View {
        DebitCardViewPreviewHolder()
    }
}


