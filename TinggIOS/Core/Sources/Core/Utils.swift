//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Foundation
public enum Utils {
    public static let baseUrlStaging = "https://kartana.tingg.africa/pci/mula_ke/api/v1/"
}


public enum ViewRooms {
    case launch, intro, home, phone
}

public class NavigationUtils: ObservableObject {
    @Published public var rooms = ViewRooms.intro
    @Published public var navigatePermission = false
    public init() {}
}
