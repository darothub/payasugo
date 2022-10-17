//
//  File.swift
//  
//
//  Created by Abdulrasaq on 17/10/2022.
//

import Foundation

public class NavigationUtils: ObservableObject {
    @Published public var screen = Screens.launch
    @Published public var current = Screens.launch
    @Published public var navigatePermission = true
    public init() {
        // Intentionally unimplemented...needed for modular accessibility
    }
}
