//
//  OnboadingView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 23/06/2022.
//

import SwiftUI
import Theme

struct BottomCurve: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.width, y: rect.height),
                      control1: CGPoint(x: rect.width * 0.35, y: rect.height + 50),
                      control2: CGPoint(x: rect.width * 0.65, y: rect.height + 50))
        return path
    }
}

struct OnboadingView: View {
    let onboadingItem: OnboardingItem
    let screenSize: CGSize
    @EnvironmentObject var theme: EnvironmentUtils
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                VStack {
                    tinggColoredLogo
                    gifImage(size: screenSize)
                }
            }
            pageIntro
            pageSubIntro
        }
    }
}

struct OnboadingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboadingView(onboadingItem: exampleOnboarding(), screenSize: CGSize(width: 500, height: 500))
            .environmentObject(EnvironmentUtils())
    }
}

extension OnboadingView {
    func topBackgroundDesign(size: CGSize) -> some View {
        BottomCurve()
            .fill(theme.primaryTheme.lightGray)
            .frame(width: size.width, height: size.height * 0.6)
            .edgesIgnoringSafeArea(.all)
    }
    func gifImage(size: CGSize) -> some View {
        GifImage(onboadingItem.centerImage)
            .frame(width: size.width * 0.65, height: size.height * 0.5, alignment: .center)
            .padding(.vertical, 30)
    }
    var tinggColoredLogo: some View {
        Image("tinggcoloredicon")
            .resizable()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .shadow(radius: 3)
    }
    var pageIntro: some View {
        Text(onboadingItem.info)
            .font(.system(size: theme.primaryTheme.largeTextSize))
            .bold()
            .multilineTextAlignment(.center)
            .padding(.vertical, 10)
    }
    var pageSubIntro: some View {
        Text(onboadingItem.subInfo)
            .font(.system(size: theme.primaryTheme.mediumTextSize))
            .multilineTextAlignment(.center)
    }
}
