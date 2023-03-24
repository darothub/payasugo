//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 11/01/2023.
//
import CoreUI
import SwiftUI
import Theme

struct CardTemplateBackView: View {
    @State var cardHeight:CGFloat = 250
    @Binding var rotationDegree:Double
    @Binding var cvv:String
    @Binding var image: PrimaryTheme.Images
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.indigo)
                        .frame(height: 50)
                    VStack {
                        Divider()
                            .frame(height: 3)
                            .background(.yellow.opacity(0.2))
                        Divider()
                            .frame(height: 3)
                            .background(.yellow.opacity(0.2))
                        Divider()
                            .frame(height: 3)
                            .background(.yellow.opacity(0.2))
                    }
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(.white)
                        .frame(width: 60, height: 40)
                    Text(cvv)
                }
            }
            .padding(.bottom)
            HStack {
                Spacer()
                PrimaryTheme.getImage(image: image)
                    .padding(.trailing, 5)
                    .scaleEffect(0.7)
            }
            
        }
        .frame(height: cardHeight)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.black)
            
        ).rotation3DEffect(Angle(degrees: rotationDegree), axis: (x: 0, y: 1, z: 0))
    }
}

struct CardTemplateBackView_Previews: PreviewProvider {
    static var previews: some View {
        CardTemplateBackView(rotationDegree: .constant(0), cvv: .constant("542"), image: .constant(.cardTempIcon))
    }
}
