//
//  ThemeProperties.swift
//  Theme
//
//  Created by Abdulrasaq on 23/06/2022.
//

import SwiftUI

public struct PrimaryTheme {
    public init() {}
    public static var smallTextSize: CGFloat = 14.0
    public static var mediumTextSize: CGFloat = 16.0
    public static var largeTextSize: CGFloat = 24.0
    public static var navigationTextSize: CGFloat = 18.0
    public static var smallPadding: CGFloat = 14.0
    public static var mediumPadding: CGFloat = 18.0
    public static var largePadding: CGFloat = 25.0
    public enum Images: String {
        case bill, tinggSplashScreenIcon, tinggAssistImage, tinggIcon,
        addBillImage, moneyImage, home, explore, group
        public var image: Image {
            return Images.getImage(self.rawValue)
        }
        public static func getImage(_ name: String) -> Image {
            return Image(name, bundle: Bundle.module)
        }
    }
    public enum AppColors: String {
        case secondaryColor, primaryColor, cellulantPurple,
             cellulantRed, skyBlue, cellulantLightGray, textColor
        public static func getColor(_ name: String) -> Color {
            return  Color(name, bundle: Bundle.module)
        }
    }
    public static func getColor(_ name: AppColors) -> Color {
        return  AppColors.getColor(name.rawValue)
    }
    public static func getImage(image: Images) -> Image {
        return Images.getImage(image.rawValue)
    }
}
