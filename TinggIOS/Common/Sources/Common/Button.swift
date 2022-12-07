//
//  File.swift
//  
//
//  Created by Abdulrasaq on 21/07/2022.
//

import SwiftUI

public func button(
    backgroundColor: Color = Color.red,
    buttonLabel: String = "Get started",
    padding: CGFloat = 25,
    action: @escaping () -> Void
) -> some View {
    Button {
        action()
    } label: {
        Text(buttonLabel)
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(10)
            .padding(.horizontal, padding)
    }
}

public func outlinebutton(
    backgroundColor: Color = Color.red,
    buttonLabel: String = "Get started",
    action: @escaping () -> Void
) -> some View {
    Button {
        action()
    } label: {
        Text(buttonLabel)
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.green)
            .cornerRadius(10)
            .padding(.horizontal, 25)
    } .overlay(
        RoundedRectangle(cornerRadius: 5)
            .stroke(lineWidth: 0.5)
    ).foregroundColor(backgroundColor)
        .padding(.horizontal, 25)
}
