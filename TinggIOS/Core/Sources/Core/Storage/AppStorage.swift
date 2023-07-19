//
//  File.swift
//  
//
//  Created by Abdulrasaq on 21/07/2022.
//

import SwiftUI
/// A class to manage storage in user default
public struct AppStorageManager {
    @AppStorage(LocalProperties.activeCountry.rawValue) fileprivate static var activeCountry: CountriesInfoDTO? = nil
    @AppStorage(LocalProperties.phoneNumber.rawValue) fileprivate static var phoneNumber: String = ""
    @AppStorage(LocalProperties.defaultNetworkId.rawValue) fileprivate static var defaultNetworkId: Int? = 0
    @AppStorage(LocalProperties.defaultNetwork.rawValue) fileprivate static var defaultNetwork: MerchantService? = nil
    @AppStorage(LocalProperties.countriesExtraInfo.rawValue) fileprivate static var countriesExtraInfo: CountriesExtraInfo? = nil
    @AppStorage(LocalProperties.billReminder.rawValue) fileprivate static var billReminder: Bool = false
    @AppStorage(LocalProperties.campaignMessage.rawValue) fileprivate static var campaignMessage: Bool = false
    @AppStorage(LocalProperties.deviceToken.rawValue) fileprivate static var deviceToken: String = ""
    @AppStorage(LocalProperties.isLogin.rawValue) fileprivate static var isLogin: Bool = false
    public static func retainPhoneNumber(number: String) {
        phoneNumber = number
    }
    public static func setDefaultNetworkId(id: Int) {
        defaultNetworkId = id
    }
    public static func getDefaultNetworkId() -> Int? {
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

    public static func retainActiveCountry(country: CountriesInfoDTO?) {
        activeCountry = country
    }
    public static func retainCountriesExtraInfo(countrExtra: CountriesExtraInfo?) {
        countriesExtraInfo = countrExtra
    }
    public static func getCountriesExtraInfo() -> CountriesExtraInfo? {
        return countriesExtraInfo
    }
    public static func getCountry() -> CountriesInfoDTO? {
        activeCountry
    }
    public static func optInForBillReminder() -> Bool {
        billReminder
    }
    public static func setOptForBillReminder(value: Bool) {
        billReminder = value
    }
    public static func optInForCampaignMessages() -> Bool {
        campaignMessage
    }
    public static func setOptForCampaignMessages(value: Bool) {
        campaignMessage = value
    }
    public static func getDeviceToken() -> String {
        deviceToken
    }
    public static func setDeviceToken(value: String) {
        deviceToken = value
    }
    public static func setIsLogin(value: Bool) {
        isLogin = value
    }
    public static func getIsLogin() -> Bool {
        isLogin
    }
}

public enum LocalProperties: String {
    case activeCountry
    case phoneNumber
    case defaultNetworkId
    case defaultNetwork
    case countriesExtraInfo
    case billReminder
    case campaignMessage
    case deviceToken
    case isLogin
}

