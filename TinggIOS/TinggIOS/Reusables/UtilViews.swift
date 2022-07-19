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
            BottomCurve()
                .fill(Color.red)
                .frame(height: 50)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct UtilTestViews_Previews: PreviewProvider {
    static var previews: some View {
        UtilViews()
    }
}
struct BottomCurve: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.width, y: rect.height),
                      control1: CGPoint(x: rect.width * 0.35, y: rect.height + 40),
                      control2: CGPoint(x: rect.width * 0.65, y: rect.height + 40))
        return path
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
                .padding(.horizontal, PrimaryTheme.largePadding)
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
            .frame(height: height)
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
