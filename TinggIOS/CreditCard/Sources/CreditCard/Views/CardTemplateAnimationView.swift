//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 12/01/2023.
//

import SwiftUI
import Theme
struct CardTemplateAnimationView: View {
    @State private var backDegree = -90.0
    @State private var frontDegree = 0.0
    @State private var isFlipped = false
    @State private var cardFace = CardFaces.frontBeforeEdit
    @State var frontBackGroundColor:Color = .blue.opacity(0.5)
    @Binding var cardNumber: String
    @Binding var holderName: String
    @Binding var expDate: String
    @Binding var cvv: String
    @Binding var cardImage: PrimaryTheme.Images
    let durationAndDelay : CGFloat = 0.3
    var body: some View {
        ZStack {
            VStack {
                CardTemplateFrontView(rotationDegree: $frontDegree, backGroundColor: $frontBackGroundColor, cardNumber: $cardNumber, holderName: $holderName, expDate: $expDate, image: $cardImage)
            }
            
            CardTemplateBackView(rotationDegree: $backDegree, cvv: $cvv, image: $cardImage)
        }
        .onChange(of: cardNumber){ newValue in
            frontAnimation()
        }
        .onChange(of: holderName){ newValue in
            frontAnimation()
        }
        .onChange(of: expDate){ newValue in
            frontAnimation()
        }
        .onChange(of: cvv){ newValue in
            backAnimation()
        }
    }
    //MARK: Flip Card Function
    func flipToTheBack() {
        withAnimation(.linear(duration: durationAndDelay)) {
            frontDegree = 90
        }
        withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
            backDegree = 0
        }
    }
    func flipFrontCard () {
        withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
            frontDegree = 90
        }
        withAnimation(.linear(duration: 0.6).delay(0.6)){
            frontDegree = 0
            frontBackGroundColor = .black
        }
    }
    func flipToFrontCard() {
        withAnimation(.linear(duration: durationAndDelay)) {
            backDegree = -90
        }
        withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
            frontDegree = 0
        }
    }
    func frontAnimation() {
        if cardFace == .frontBeforeEdit {
            flipFrontCard()
        } else if cardFace == .backOnEdit && frontBackGroundColor == .black {
            flipToFrontCard()
        } else if cardFace == .backOnEdit && frontBackGroundColor != .black  {
            flipToFrontCard()
            flipFrontCard()
        }
        cardFace = .frontOnEdit
    }
    func backAnimation() {
        if cardFace == .frontBeforeEdit || cardFace == .frontOnEdit {
            flipToTheBack()
            cardFace = .backOnEdit
        }
    }
}

struct CardTemplateAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CardTemplateAnimationView(
            cardNumber: .constant("55555"),
            holderName: .constant("Joe"),
            expDate: .constant("MM/YY"),
            cvv: .constant("542"),
            cardImage: .constant(.cardTempIcon)
        )
    }
}


enum CardFaces: Equatable {
    case frontBeforeEdit, backBeforeEdit, frontOnEdit, backOnEdit
}
