//
//  File.swift
//  
//
//  Created by Abdulrasaq on 21/07/2022.
//

import SwiftUI
public func topBackgroundDesign(
    height: CGFloat, color: Color
) -> some View {
    BottomCurve()
        .fill(color)
        .frame(height: height)
        .edgesIgnoringSafeArea(.all)
}
