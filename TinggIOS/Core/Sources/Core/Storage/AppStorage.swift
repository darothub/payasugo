//
//  File.swift
//  
//
//  Created by Abdulrasaq on 21/07/2022.
//

import SwiftUI
/// A class to manage storage in user default
public struct AppStorageManager {
    @AppStorage(LocalProperties.activeCountry.rawValue) fileprivate static var activeCountry: Country? = nil
    @AppStorage(LocalProperties.phoneNumber.rawValue) fileprivate static var phoneNumber: String = ""
    @AppStorage(LocalProperties.defaultNetworkId.rawValue) fileprivate static var defaultNetworkId: String = ""
    @AppStorage(LocalProperties.defaultNetwork.rawValue) fileprivate static var defaultNetwork: MerchantService? = nil
    public static func retainPhoneNumber(number: String) {
        phoneNumber = number
    }
    public static func setDefaultNetworkId(id: String) {
        defaultNetworkId = id
    }
    public static func getDefaultNetworkId() -> String {
        return defaultNetworkId
    }
    public static func setDefaultNetwork(service: MerchantService) {
        defaultNetwork = service
    }
    public static func getDefaultNetwork() -> MerchantService? {
        return defaultNetwork
    }
    public static func getPhoneNumber() -> String {
        return phoneNumber
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
    case phoneNumber
    case defaultNetworkId
    case defaultNetwork
}

