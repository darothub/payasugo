//
//  FullScreen.swift
//  
//
//  Created by Abdulrasaq on 28/02/2023.
//

import Foundation
import SwiftUI
public struct FullScreen: View {
    public var view = AnyView(Text("Sample"))
    public var color = Color.white
    public init(view: AnyView = AnyView(Text("Sample")), color: SwiftUI.Color = Color.white) {
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
