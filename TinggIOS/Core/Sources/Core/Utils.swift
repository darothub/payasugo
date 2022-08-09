//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Foundation
import SwiftUI
public enum Utils {
    public static let baseUrlStaging = "https://kartana.tingg.africa/pci/mula_ke/api/v1/"
}
public enum Screens {
    case launch, intro, home
}

public class NavigationUtils: ObservableObject {
    @Published public var screen = Screens.intro
    @Published public var navigatePermission = false
    public init() {}
}
