//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 30/07/2022.
//

import SwiftUI
import Theme
public struct IconImageCardView: View {
    @State var imageUrl: String = ""
    @State var radius: CGFloat = 10
    @State var scaleEffect: CGFloat = 1
    public init(imageUrl: String, radius: CGFloat = 10, scaleEffect: CGFloat = 1) {
        self._imageUrl = State(initialValue: imageUrl)
        self._radius = State(initialValue: radius)
        self._scaleEffect = State(initialValue: scaleEffect)
    }
    public var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image.resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding()
        } placeholder: {
            PrimaryTheme.getImage(image: .tinggIcon)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding()
        }.background(
            RoundedRectangle(cornerRadius: radius)
                .foregroundColor(.white)
                .shadow(radius: 3, x: 0, y: 3)
        ).scaleEffect(scaleEffect)
    }
}

public enum BackgroundShape: Hashable, Equatable {
    case rectangle
    case circle
}
struct IconImageCardView_Previews: PreviewProvider {
    static var previews: some View {
        IconImageCardView(imageUrl: "")
    }
}
