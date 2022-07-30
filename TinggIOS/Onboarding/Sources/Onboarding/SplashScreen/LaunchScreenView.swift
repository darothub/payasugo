//
//  LaunchScreenView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 22/06/2022.
//
import Core
import SwiftUI
import Theme
public struct LaunchScreenView: View {
    @EnvironmentObject var splashScreenWatcher: EnvironmentUtils
    @EnvironmentObject var navigation: NavigationUtils
    public init() {}
    public var body: some View {
        ZStack {
            background
            image
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                navigation.screen = .intro
                navigation.navigatePermission.toggle()
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
