//
//  LaunchScreenView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 22/06/2022.
//
//import Common
import SwiftUI
import Theme
public struct LaunchScreenView: View {
    @EnvironmentObject var splashScreenWatcher: EnvironmentUtils
    public init() {}
    public var body: some View {
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
        PrimaryTheme.getColor(.secondaryColor)
            .edgesIgnoringSafeArea(.all)
    }
    var image: some View {
        PrimaryTheme.getImage(image: .tinggSplashScreenIcon)
            .renderingMode(.template)
            .foregroundColor(Color.white)
    }
}
