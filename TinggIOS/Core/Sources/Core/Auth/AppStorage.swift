//
//  File.swift
//  
//
//  Created by Abdulrasaq on 21/07/2022.
//

import SwiftUI
public struct AppStorageManager {
//    static var activeCountry: String = ""
    @AppStorage(LocalProperties.activeCountry.rawValue) public static var activeCountry: Data = .init()
    @AppStorage(LocalProperties.activeCountry.rawValue) static var userCountry: String = ""
    public static func retainActiveCountry(country: String) {
//        guard let data = try? JSONEncoder().encode(country) else { return }
//        activeCountry = data
//        print("ActiveCountryData \(activeCountry)")
        userCountry = country
    }
    public static func getActiveCountry() -> String {
        print("ActiveCountry \(userCountry)")
        return userCountry
//        guard let activeCountry = try? JSONDecoder().decode(Country.self, from: activeCountry) else { fatalError("Country decode error") }
//        return activeCountry
    }
}

public enum LocalProperties: String {
    case activeCountry
}
