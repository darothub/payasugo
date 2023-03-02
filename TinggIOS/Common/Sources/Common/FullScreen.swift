//
//  FullScreen.swift
//  
//
//  Created by Abdulrasaq on 28/02/2023.
//

import Foundation
import SwiftUI
public struct FullScreen: View {
    @Binding public var isFullScreen: Bool
    public var view = AnyView(Text("Sample"))
    public var color = Color.white
    public init(isFullScreen: Binding<Bool>, view: AnyView = AnyView(Text("Sample")), color: SwiftUI.Color = Color.white) {
        self._isFullScreen = isFullScreen
        self.view = view
        self.color = color
    }
    public var body: some View {
        ZStack {
            color.edgesIgnoringSafeArea(.all)
            view
        }
    }
}
