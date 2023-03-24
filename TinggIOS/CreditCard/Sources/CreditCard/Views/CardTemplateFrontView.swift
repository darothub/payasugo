//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 10/01/2023.
//
import Core
import CoreUI
import SwiftUI
import Theme

struct CardTemplateFrontView: View {
    @State var cardHeight:CGFloat = 230
    @Binding var rotationDegree:Double
    @Binding var backGroundColor: Color
    @Binding var cardNumber: String
    @Binding var holderName: String
    @Binding var expDate: String
    @Binding var image: PrimaryTheme.Images
    var body: some View {
        VStack {
            HStack {
               RoundedRectangle(cornerRadius: 5)
                    .fill(.gray.opacity(0.5))
                    .frame(width: 80, height: 60)
                    
                Spacer()
                PrimaryTheme.getImage(image: image)
                    .scaleEffect(1.5)
                    .padding(.trailing, 5)
            }.padding(EdgeInsets(top: 10, leading:10, bottom: 15, trailing: 10))
            Text(cardNumber)
                .padding()
                .foregroundColor(.white)
            HStack {
                VStack(alignment: .leading) {
                    Text("CARD HOLDER")
                        .font(.caption)
                    Text(holderName)

                }.textCase(.uppercase)
                Spacer()
                VStack(alignment: .leading) {
                    Text("Expiry date")
                        .font(.caption)
                    Text(expDate)
                }
                Spacer()
            }.padding(EdgeInsets(top: 10, leading:10, bottom: 15, trailing: 10))
            .foregroundColor(.white)
        }
        .frame(height: cardHeight)
        .background (
            RoundedRectangle(cornerRadius: 10)
                .fill(backGroundColor)
                
        ).rotation3DEffect(Angle(degrees: rotationDegree), axis: (x: 0, y: 1, z: 0))
      
    }
}

struct CardTemplateFrontView_Previews: PreviewProvider {
    static var previews: some View {
        CardTemplateFrontView(
            rotationDegree: .constant(-90),
            backGroundColor: .constant(.blue.opacity(0.5)),
            cardNumber: .constant("55555"),
            holderName: .constant("Joe"),
            expDate: .constant("MM/YY"),
            image: .constant(.cardTempIcon)
        )
    }
}
