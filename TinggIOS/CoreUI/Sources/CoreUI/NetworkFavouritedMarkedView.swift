//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 15/01/2023.
//

import SwiftUI

public struct NetworkFavouritedMarkedView: View {
    public init() {
        
    }
    public var body: some View {
        Triangle()
            .fill(.purple)
            .frame(width: 40, height: 40)
            .cornerRadius(3, corners: [.topRight])
            .overlay(alignment: .topTrailing) {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .scaleEffect(0.7)
                    .padding(4)
                    .bold()
            }.padding(5)
    }
}

public struct Triangle: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
