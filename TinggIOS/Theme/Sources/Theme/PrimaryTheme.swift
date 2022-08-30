//
//  ThemeProperties.swift
//  Theme
//
//  Created by Abdulrasaq on 23/06/2022.
//

import SwiftUI

public struct PrimaryTheme {
    public init() {
        // Intentionally unimplemented...modular accessibility
    }
    public static var smallTextSize: CGFloat = 12.0
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
            return Image(name, bundle: .myModule)
        }
    }
    public enum AppColors: String {
        case secondaryColor, primaryColor, cellulantPurple,
             cellulantRed, skyBlue, cellulantLightGray, textColor, tinggwhite,
        tinggblack
        public static func getColor(_ name: String) -> Color {
            return  Color(name, bundle: .myModule)
        }
    }
    public static func getColor(_ name: AppColors) -> Color {
        return  AppColors.getColor(name.rawValue)
    }
    public static func getImage(image: Images) -> Image {
        return Images.getImage(image.rawValue)
    }
}

extension Bundle {
    static var myModule: Bundle = {
        let bundle: Bundle
        let bundleName = "Theme_Theme"
        let candidates = [
            /* Bundle should be present here when the package is linked into an App. */
            Bundle.main.resourceURL,
            /* Bundle should be present here when the package is linked into a framework. */
            Bundle(for: CurrentBundleFinder.self).resourceURL,
            /* Bundle should be present here when the package is used in UI Tests. */
            Bundle(for: CurrentBundleFinder.self).resourceURL?.deletingLastPathComponent(),
            /* For command-line tools. */
            Bundle.main.bundleURL,
            /* Bundle should be present here when running previews
             from a different package (this is the path to "…/Debug-iphonesimulator/"). */
            Bundle(for: CurrentBundleFinder.self).resourceURL?
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent(),
            Bundle(for: CurrentBundleFinder.self).resourceURL?
                .deletingLastPathComponent()
                .deletingLastPathComponent()
        ]
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                print("Bundle \(bundle)")
                return bundle
            }
        }
        fatalError("unable to find bundle named \(bundleName)")
    }()
}

class CurrentBundleFinder {}
