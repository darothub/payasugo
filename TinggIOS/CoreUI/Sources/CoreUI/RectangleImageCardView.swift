//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 15/01/2023.
//
import SwiftUI
public struct RectangleImageCardView: View {
    @State var imageUrl: String = ""
    @State var tag: String = ""
    @State var radius: CGFloat = 5
    @State var y: CGFloat = 3
    @Binding var selected: String
    var onResetAccountNumber: () -> Void
    public init(imageUrl: String = "", tag: String = "", radius: CGFloat = 5, y: CGFloat = 3, selected: Binding<String> = .constant(""), onResetAccountNumber: @escaping () -> Void = {}) {
        self.imageUrl = imageUrl
        self.tag = tag
        self.radius = radius
        self.y = y
        self._selected = selected
        self.onResetAccountNumber = onResetAccountNumber
    }
    public var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image.resizable()
                .frame(width: 100, height: 70)
                .clipShape(Rectangle())
                .padding(5)
        } placeholder: {
            Image(systemName: "person")
                .frame(width: 100, height: 70)
                .clipShape(Rectangle())
                .padding(5)
        }.background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.white)
                .shadow(color: .red, radius: selected == tag ? radius : 0, x: 0 , y: selected == tag ? y : 0)
        )
        .padding([.vertical, .horizontal], 5)
        .onTapGesture {
            withAnimation {
                selected = tag
                onResetAccountNumber()
            }
        }
    }
}


