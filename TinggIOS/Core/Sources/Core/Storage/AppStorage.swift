//
//  File.swift
//  
//
//  Created by Abdulrasaq on 21/07/2022.
//

import SwiftUI
public struct AppStorageManager {
    @AppStorage(LocalProperties.activeCountry.rawValue) fileprivate static var activeCountry: Country? = nil
    @AppStorage(LocalProperties.countryName.rawValue) fileprivate static var userCountry: String = ""
    @AppStorage(LocalProperties.phoneNumber.rawValue) fileprivate static var phoneNumber: String = ""
    @AppStorage(LocalProperties.clientId.rawValue) fileprivate static var clientId: String = ""
    public static func retainActiveCountry(country: String) {
        userCountry = country
    }
    public static func retainPhoneNumber(number: String) {
        phoneNumber = number
    }
    public static func getActiveCountry() -> String {
        return userCountry
    }
    public static func getPhoneNumber() -> String {
        return phoneNumber
    }
    public static func retainClientId(id: String) {
        clientId = id
    }
    public static func getClientId() -> String {
        return clientId
    }
    public static func retainActiveCountry(country: Country?) {
        activeCountry = country
    }
    
    public static func getCountry() -> Country? {
        activeCountry
    }
}

public enum LocalProperties: String {
    case activeCountry
    case countryName
    case phoneNumber
    case clientId
}


class User: Codable {
    var name = "Somebody"
}
