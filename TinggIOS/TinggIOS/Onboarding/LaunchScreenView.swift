//
//  LaunchScreenView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 22/06/2022.
//

import SwiftUI

struct LaunchScreenView: View {
    var primaryTheme = PrimaryTheme()
    var body: some View {
        ZStack {
            background
            image
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}

private extension LaunchScreenView {
    var background : some View {
        primaryTheme.secondaryColor.edgesIgnoringSafeArea(.all)
    }
    var image : Image {
        primaryTheme.splashScreenImage
    }
}
