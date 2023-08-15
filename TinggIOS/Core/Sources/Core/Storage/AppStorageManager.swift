//
//  AppStorageManager.swift
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
    @AppStorage(LocalProperties.isLogin.rawValue) fileprivate static var isLogin: Data?
    @AppStorage(LocalProperties.authClientId.rawValue) fileprivate static var authClientId: String = ""
    @AppStorage(LocalProperties.authClientSecret.rawValue) fileprivate static var authClientSecret: String = ""
    @AppStorage(LocalProperties.fetchTokenUrl.rawValue) fileprivate static var fetchTokenUrl: String = ""
    @AppStorage(LocalProperties.token.rawValue) fileprivate static var token: String = ""
    @AppStorage(LocalProperties.processRequestUrl.rawValue) fileprivate static var processRequestUrl: String = ""
    @AppStorage(LocalProperties.privateKeyData.rawValue) fileprivate static var privateKeyData: Data?
    @AppStorage(LocalProperties.publicKeyData.rawValue) fileprivate static var publicKeyData: Data?
    @AppStorage(LocalProperties.securityQuestion.rawValue) public static var securityQuestion: String?
    @AppStorage(LocalProperties.securityAnswer.rawValue) public static var securityAnswer: String?
    @AppStorage(LocalProperties.mulaPin.rawValue) public static var mulaPin: String?
    @AppStorage(LocalProperties.pinRequestChoice.rawValue) public static var pinRequestChoice: String = ""
    @AppStorage(LocalProperties.termsAncConditionMessage.rawValue) public static var termsAncConditionMessage: String = ""
    @AppStorage(LocalProperties.acceptedTermsAndCondition.rawValue) public static var acceptedTermsAndCondition: Bool = false
    @AppStorage(LocalProperties.hasCheckedDontShowPinIntroductionAgain.rawValue) public static var hasCheckedDontShowPinIntroductionAgain: Bool = false
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
    public static func setIsLogin(value: Data) {
        isLogin = value
    }
    public static func getIsLogin() -> Data? {
        isLogin
    }
    public static func setAuthClientId(_ id: String) -> Void {
        authClientId = id
    }
    public static func getAuthClientId() -> String {
        authClientId
    }
    public static func setAuthClientSecret(_ secret: String) -> Void {
        authClientSecret = secret
    }
    public static func getAuthClientSecret() -> String {
        authClientSecret
    }
    public static func setFetchTokenUrl(_ url: String) -> Void {
        fetchTokenUrl = url
    }
    public static func getFetchTokenUrl() -> String {
        fetchTokenUrl
    }
    public static func setToken(_ value: String) -> Void {
        token = value
    }
    public static func getToken() -> String {
        token
    }
    public static func setProcessRequestUrl(_ value: String) -> Void {
        processRequestUrl = value
    }
    public static func getProcessRequestUrl() -> String {
        processRequestUrl
    }
    public static func getPublicKeyData() -> Data? {
        publicKeyData
    }
    public static func getPrivateKeyData() -> Data? {
        privateKeyData
    }
    public static func setPublicKeyData(_ data: Data) -> Void {
        publicKeyData = data
    }
    public static func setPrivateKeyData(_ data: Data) -> Void {
        privateKeyData = data
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
    case authClientId
    case authClientSecret
    case fetchTokenUrl
    case token
    case processRequestUrl
    case privateKeyData
    case publicKeyData
    case securityQuestion
    case securityAnswer
    case mulaPin
    case pinRequestChoice
    case termsAncConditionMessage
    case acceptedTermsAndCondition
    case hasCheckedDontShowPinIntroductionAgain
}

