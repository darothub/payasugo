//
//  File.swift
//  
//
//  Created by Abdulrasaq on 21/07/2022.
//

import SwiftUI

public func TinggButton(
    backgroundColor: Color = Color.green,
    buttonLabel: String = "Get started",
    padding: CGFloat = 25,
    textPadding: CGFloat = 20,
    action: @escaping () -> Void
) -> some View {
    Button {
        action()
    } label: {
        Text(buttonLabel)
            .frame(maxWidth: .infinity)
            .padding(textPadding)
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(10)
    }.accessibility(identifier: "btn")
}

public func TinggOutlineButton(
    backgroundColor: Color = Color.red,
    buttonLabel: String = "Get started",
    padding: CGFloat = 25,
    textColor: Color = .green,
    textHorPadding: CGFloat = 25,
    action: @escaping () -> Void
) -> some View {
    Button {
        action()
    } label: {
        Text(buttonLabel)
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(textColor)
            .cornerRadius(10)
            .padding(.horizontal, textHorPadding)
    } .overlay(
        RoundedRectangle(cornerRadius: 5)
            .stroke(lineWidth: 1)
    ).foregroundColor(backgroundColor)
        .padding(.horizontal, padding)
}
