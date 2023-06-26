//
//  IconImageCardView.swift
//  
//
//  Created by Abdulrasaq on 30/07/2022.
//

import SwiftUI
public struct IconImageCardView: View {
    @State var imageUrl: String = ""
    @State var radius: CGFloat = 10
    @State var scaleEffect: CGFloat = 1
    @State var x: CGFloat = 0
    @State var y: CGFloat = 3
    @State var shadowRadius: CGFloat = 3
    @State var bgShape: ImageClipShape = .rectangular
    public init(imageUrl: String, radius: CGFloat = 10, scaleEffect: CGFloat = 1, x: CGFloat = 1, y: CGFloat = 1, shadowRadius: CGFloat = 3, bgShape: ImageClipShape = .rectangular) {
        self._imageUrl = State(initialValue: imageUrl)
        self._radius = State(initialValue: radius)
        self._scaleEffect = State(initialValue: scaleEffect)
        self._x = State(initialValue: x)
        self._y = State(initialValue: y)
        self._shadowRadius = State(initialValue: shadowRadius)
        self._bgShape = State(initialValue: bgShape)
    }
    public var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image.resizable()
        } placeholder: {
            Image(systemName: "photo")
                      .foregroundColor(.red)
                
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
        .padding()
        .scaleEffect(scaleEffect)
        .background(
            bgShape == .rectangular ?
            RoundedRectangle(cornerRadius: radius)
                .foregroundColor(.white)
                .shadow(radius: shadowRadius, x: x, y: y)
            :
            RoundedRectangle(cornerRadius: 50)
                .foregroundColor(.white)
                .shadow(radius: shadowRadius, x: x, y: y)
        )
       
        
    }
}
public struct ResponsiveImageCardView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var imageUrl: String
    @State var radius: CGFloat = 10
    @State var scaleEffect: CGFloat = 1
    @State var x: CGFloat = 0
    @State var y: CGFloat = 3
    @State var shadowRadius: CGFloat = 3
    @State var bgShape: ImageClipShape = .rectangular
    public init(imageUrl: Binding<String>, radius: CGFloat = 10, scaleEffect: CGFloat = 1, x: CGFloat = 0, y:CGFloat = 3, shadowRadius: CGFloat = 0, bgShape: ImageClipShape = .circular) {
        self._imageUrl = imageUrl
        self._radius = State(initialValue: radius)
        self._scaleEffect = State(initialValue: scaleEffect)
        self._x = State(initialValue: x)
        self._y = State(initialValue: y)
        self._shadowRadius = State(initialValue: shadowRadius)
        self._bgShape = State(initialValue: bgShape)
    }
    public var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image.resizable()
                
        } placeholder: {
            Image(systemName: "camera.fill")
                .foregroundColor(colorScheme == .dark ? .black : .black)
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
        .padding()
        .scaleEffect(scaleEffect)
        .background(
            bgShape == .rectangular ?
            RoundedRectangle(cornerRadius: radius)
                .foregroundColor(.white)
                .shadow(radius: shadowRadius, x: x, y: y)
            :
            RoundedRectangle(cornerRadius: 50)
                .foregroundColor(.white)
                .shadow(radius: shadowRadius, x: x, y: y)
        )
       
        
    }
}
public enum ImageClipShape: Hashable {
    case rectangular, circular
}

struct IconImageCardView_Previews: PreviewProvider {
    static var previews: some View {
        IconImageCardView(imageUrl: "")
    }
}


public struct BoxShimmerView: View {
    var size: CGSize
    public init(size: CGSize = CGSize(width: 60, height: 60)) {
        self.size = size
    }
    public var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.gray)
            .frame(width: size.width, height: size.height)
    }
}
public struct TextShimmerView: View {
    var width: CGFloat
    public init(width: CGFloat = 100) {
        self.width = width
    }
    public var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(.gray)
            .frame(width: width, height: 5)
    }
}
