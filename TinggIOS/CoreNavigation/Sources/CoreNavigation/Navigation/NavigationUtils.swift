//
//  NavigationUtils.swift
//  
//
//  Created by Abdulrasaq on 17/10/2022.
//

import Foundation
import SwiftUI
/// An util class for handling navigation stack
public class NavigationUtils: ObservableObject {
    @Published public var screen = Screens.intro
    @Published public var current = Screens.intro
    @Published public var navigatePermission = true
    @Published public var navigationStack = NavigationPath()
   
    
    public init() {
        // Intentionally unimplemented...needed for modular accessibility
        
    }
    
}




