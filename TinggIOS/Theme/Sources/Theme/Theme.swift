//
//  ThemeProperties.swift
//  Theme
//
//  Created by Abdulrasaq on 23/06/2022.
//

import SwiftUI

public protocol ThemeProperties {
    var smallTextSize: CGFloat { get }
    var mediumTextSize: CGFloat { get }
    var largeTextSize: CGFloat { get }
    var navigationTextSize: CGFloat { get }
    var textColor: Color { get }
    var primaryColor: Color { get }
    var primaryBgColor: Color { get }
    var secondaryColor: Color { get }
    var smallPadding: CGFloat { get }
    var mediumPadding: CGFloat { get }
    var largePadding: CGFloat { get }
    var skyBlue: Color { get }
    var cellulantPurple: Color { get }
    var cellulantRed: Color { get }
    var splashScreenImage: Image { get }
    var lightGray: Color { get }
}

public struct PrimaryTheme: ThemeProperties {
    public init() {}
    public var smallTextSize: CGFloat = 14.0
    public var mediumTextSize: CGFloat = 16.0
    public var largeTextSize: CGFloat = 24.0
    public var navigationTextSize: CGFloat = 18.0
    public var smallPadding: CGFloat = 14.0
    public var mediumPadding: CGFloat = 18.0
    public var largePadding: CGFloat = 25.0
    public var textColor: Color = getColor("textColor")
    public var primaryColor: Color = getColor("primaryColor")
    public var primaryBgColor: Color = getColor("primaryColor")
    public var secondaryColor: Color = getColor("secondaryColor")
    public var skyBlue: Color = getColor("cellulantSkyBlue")
    public var cellulantPurple: Color = getColor("cellulantPurple")
    public var cellulantRed: Color = getColor("cellulantRed")
    public var splashScreenImage: Image = Image("TinggSplashScreenIcon")
    public var lightGray: Color = getColor("cellulantLightGray")
    static func getColor(_ name: String) -> Color {
        return  Color(name, bundle: Bundle.module)
    }
}

extension ThemeProperties {
    public var primaryGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [cellulantPurple, cellulantRed]),
            startPoint: .top, endPoint: .bottom
        )
    }
    public var primaryBgGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [primaryColor, secondaryColor]),
            startPoint: .bottomLeading, endPoint: .topTrailing
        )
    }
}
