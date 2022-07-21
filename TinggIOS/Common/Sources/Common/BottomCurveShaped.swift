//
//  File.swift
//  
//
//  Created by Abdulrasaq on 21/07/2022.
//

import SwiftUI
public struct BottomCurve: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.width, y: rect.height),
                      control1: CGPoint(x: rect.width * 0.35, y: rect.height + 40),
                      control2: CGPoint(x: rect.width * 0.65, y: rect.height + 40))
        return path
    }
}
