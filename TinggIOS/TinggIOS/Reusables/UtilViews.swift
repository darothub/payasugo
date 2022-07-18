//
//  UtilTestViews.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 26/06/2022.
//

import SwiftUI
import Theme

struct UtilViews: View {
    static var theme = PrimaryTheme()
    var backgroundColor = Color.red
    var buttonLabel = "Get started"
    var action = {}
    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                Text(buttonLabel)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(backgroundColor)
                    .cornerRadius(10)
                    .padding(.bottom, 30)
            }
        }
    }
}

struct UtilTestViews_Previews: PreviewProvider {
    static var previews: some View {
        UtilViews()
    }
}

extension UtilViews {
    static func button(backgroundColor: Color = Color.red,
                       buttonLabel: String = "Get started",
                       action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(buttonLabel)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(backgroundColor)
                .cornerRadius(10)
                .padding(.horizontal, theme.largePadding)
        }
    }
    static var tinggColoredLogo: some View {
        Image("tinggicon")
            .resizable()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .shadow(radius: 3)
    }
    static func topBackgroundDesign(height: CGFloat, color: Color) -> some View {
        BottomCurve()
            .fill(color)
            .frame(width: .infinity, height: height)
            .edgesIgnoringSafeArea(.all)
    }
}

extension View {
    func setPageIndicatorAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.2)
    }
}

struct BottoMCurveBackground: View {
    var proxy: GeometryProxy
    var height: CGFloat
    var color: Color
    var body: some View {
        BottomCurve()
            .fill(color)
            .frame(width: proxy.size.width, height: height)
            .edgesIgnoringSafeArea(.all)
    }
}
