//
//  File.swift
//  
//
//  Created by Abdulrasaq on 07/07/2022.
//

import Foundation
import UIKit
public struct TinggRequest: Encodable {
    public var service: String?
    public var accountNumber: String?
    public var msisdn: String? = AppStorageManager.getPhoneNumber()
    public var clientId: String? = AppStorageManager.getClientId()
    public var activationCode: String?
    public var uuid: String = uuidForVendor
    public var osVersion: String = deviceOSVersion()
    public var deviceName: String = modelIdentifier()
    public var osType: String = "iOS"
    public var appVersion: String = "1.0"
    public var origin: String = "MULA_APP"
    public var parseInstallationId: String = "fISa32Gnhwg:APA91bGmtBreiR9tcInsNtdjE1U_elSnAczL0OcFUSwaaG-1G2k9yc6tM3fGMzoEzB5l7sXc5XfsEf1HyiF4RNBTNmcGDBGkXbktrNQJe1STZZ2Sf2Ux0LgJk6okjUx85lu9zzzDziGz"
    public var merchantDetails: String? = ""
    public var profileInfo: String? = ""
    public var apiLevel: Int = 15
    public var isExplicit = "1"
    public var dataSource: String? = AppStorageManager.getCountry()?.name
    public var billAccounts: [BillAccount]?
    public var serviceId: String? = ""
    public var action: String = ""
    public var defaultNetworkServiceId = ""
    public static var shared = TinggRequest()
    public init() {
        // Intentionally unimplemented...needed for modular accessibility
    }
    enum CodingKeys: String, CodingKey {
        case service = "SERVICE"
        case accountNumber = "ACCOUNT_NUMBER"
        case msisdn = "MSISDN"
        case uuid = "UUID"
        case clientId = "CLIENT_ID"
        case osVersion = "OS_VERSION"
        case deviceName = "DEVICE_NAME"
        case osType = "OS_TYPE"
        case appVersion = "APP_VERSION"
        case origin = "ORIGIN"
        case parseInstallationId = "PARSE_INSTALLATION_ID"
        case merchantDetails = "MERCHANT_DETAILS"
        case profileInfo = "PROFILE_INFO"
        case apiLevel = "API_LEVEL"
        case isExplicit = "IS_EXPLICIT"
        case activationCode = "ACTIVATION_CODE"
        case dataSource = "DATA_SOURCE"
        case serviceId = "SERVICE_ID"
        case billAccounts = "BILL_ACCOUNTS"
        case action = "ACTION"
        case defaultNetworkServiceId = "DEFAULT_NETWORK_SERVICE_ID"
    }
}

public struct BillAccount: Codable {
    public let serviceId: String
    public let accountNumber: String
    public init(serviceId: String, accountNumber: String){
        self.serviceId = serviceId
        self.accountNumber = accountNumber
    }
    enum CodingKeys: String, CodingKey {
        case serviceId = "SERVICE_ID"
        case accountNumber = "ACCOUNT_NUMBER"
    }
}
func modelIdentifier() -> String {
    if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
        return simulatorModelIdentifier }
    var sysinfo = utsname()
    uname(&sysinfo) // ignore return value
    return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)),
                  encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
}

func deviceOSVersion() -> String {
    return UIDevice.current.systemVersion
}
var uuidForVendor: String {
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
        return uuid
    }
    return ""
}
