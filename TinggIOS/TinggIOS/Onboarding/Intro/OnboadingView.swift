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
    let primaryTheme = PrimaryTheme()
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .top) {
                    bottomCurve(geometry: geometry)
                    VStack {
                        tinggColoredLogo
                        gifImage(geometry: geometry)
                    }
                }
                pageIntro
                pageSubIntro
            }
        }
    }
}

struct OnboadingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboadingView(onboadingItem: exampleOnboarding())
    }
}

extension OnboadingView {
    func bottomCurve(geometry: GeometryProxy) -> some View {
        BottomCurve()
            .fill(primaryTheme.lightGray)
            .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
            .edgesIgnoringSafeArea(.all)
    }
    func gifImage(geometry: GeometryProxy) -> some View {
        GifImage(onboadingItem.centerImage)
            .frame(width: geometry.size.width * 0.65, height: geometry.size.height * 0.5, alignment: .center)
            .padding(.vertical, 30)
    }
    var tinggColoredLogo: some View {
        Image(onboadingItem.logo)
            .resizable()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .shadow(radius: 3)
    }
    var pageIntro: some View {
        Text(onboadingItem.info)
            .font(.system(size: primaryTheme.largeTextSize))
            .bold()
            .multilineTextAlignment(.center)
            .padding(.vertical, 10)
    }
    var pageSubIntro: some View {
        Text(onboadingItem.subInfo)
            .font(.system(size: primaryTheme.mediumTextSize))
            .multilineTextAlignment(.center)
    }
}
