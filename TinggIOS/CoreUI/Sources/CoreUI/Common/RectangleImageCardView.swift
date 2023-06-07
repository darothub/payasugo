//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 15/01/2023.
//
import SwiftUI
public struct RectangleImageCardView: View {
    @State var size: CGSize = CGSize(width: 100, height: 70)
    @State var imageUrl: String = ""
    @State var tag: String = ""
    @State var radius: CGFloat = 5
    @State var y: CGFloat = 3
    @Binding var selected: String
    var onResetAccountNumber: () -> Void
    public init(size: CGSize = CGSize(width: 100, height: 70), imageUrl: String = "", tag: String = "", radius: CGFloat = 5, y: CGFloat = 3, selected: Binding<String> = .constant(""), onResetAccountNumber: @escaping () -> Void = {
        //TODO
    }) {
        self._size = State(initialValue: size)
        self._imageUrl = State(initialValue: imageUrl)
        self._tag = State(initialValue: tag)
        self._radius = State(initialValue: radius)
        self._y = State(initialValue: y)
        self._selected = selected
        self.onResetAccountNumber = onResetAccountNumber
    }
    public var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
                .foregroundColor(.black)
        }
        .frame(width: size.width, height: size.height)
        .clipShape(Rectangle())
        .padding(5)
        .background(
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


