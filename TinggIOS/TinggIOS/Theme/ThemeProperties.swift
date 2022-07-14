//
//  ThemeProperties.swift
//  TingIOS
//
//  Created by Abdulrasaq on 26/05/2022.
//

import SwiftUI

protocol ThemeProperties {
    var smallTextSize: CGFloat { get }
    var mediumTextSize: CGFloat { get }
    var largeTextSize: CGFloat { get }
    var navigationTextSize: CGFloat { get }
    var textColor: UIColor? { get }
    var primaryColor: UIColor? { get }
    var primaryBgColor: UIColor? { get }
    var secondaryColor: UIColor? { get }
    var smallPadding: CGFloat { get }
    var mediumPadding: CGFloat { get }
    var largePadding: CGFloat { get }
    var skyBlue: UIColor? { get }
}

struct PrimaryTheme: ThemeProperties {
    var smallTextSize: CGFloat = 12.0
    var mediumTextSize: CGFloat = 14.0
    var largeTextSize: CGFloat = 16.0
    var navigationTextSize: CGFloat = 18.0
    var smallPadding: CGFloat = 12.0
    var mediumPadding: CGFloat = 14.0
    var largePadding: CGFloat = 16.0
    var textColor: UIColor? = UIColor(named: "textColor")
    var primaryColor: UIColor? = UIColor(named: "primaryColor")
    var primaryBgColor: UIColor? = UIColor(named: "primaryColor")
    var secondaryColor: UIColor? = UIColor(named: "secondaryColor")
    var skyBlue: UIColor? = UIColor(named: "cellulantSkyBlue")
}

extension ThemeProperties {
    var primaryGradient: LinearGradient {
        return LinearGradient(gradient:
                                Gradient(colors: [Color(primaryColor!), Color(secondaryColor!)]),
                              startPoint: .bottomLeading, endPoint: .topTrailing
        )
    }
    var primaryBgGradient: LinearGradient {
        return LinearGradient(gradient:
                                Gradient(colors: [Color(primaryColor!), Color(secondaryColor!)]),
                              startPoint: .bottomLeading, endPoint: .topTrailing
        )
    }
}
