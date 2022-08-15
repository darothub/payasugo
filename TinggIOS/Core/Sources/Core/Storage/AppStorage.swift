//
//  File.swift
//  
//
//  Created by Abdulrasaq on 21/07/2022.
//

import SwiftUI
public struct AppStorageManager {
    @AppStorage(LocalProperties.activeCountry.rawValue) public static var activeCountry: Data = .init()
    @AppStorage(LocalProperties.activeCountry.rawValue) static var userCountry: String = ""
    public static func retainActiveCountry(country: String) {
        userCountry = country
    }
    public static func getActiveCountry() -> String {
        print("ActiveCountry \(userCountry)")
        return userCountry
    }
}

public enum LocalProperties: String {
    case activeCountry
}
