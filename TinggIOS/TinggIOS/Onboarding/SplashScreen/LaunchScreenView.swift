//
//  LaunchScreenView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 22/06/2022.
//

import SwiftUI
import Theme
struct LaunchScreenView: View {
    @EnvironmentObject var splashScreenWatcher: EnvironmentUtils
    var primaryTheme = PrimaryTheme()
    var body: some View {
        ZStack {
            background
            image
        }.onAppear {
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    splashScreenWatcher.state = .finish
                }
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .environmentObject(EnvironmentUtils())
    }
}

private extension LaunchScreenView {
    var background: some View {
        primaryTheme.secondaryColor.edgesIgnoringSafeArea(.all)
    }
    var image: some View {
        primaryTheme.splashScreenImage
            .renderingMode(.template)
            .foregroundColor(Color.white)
    }
}
