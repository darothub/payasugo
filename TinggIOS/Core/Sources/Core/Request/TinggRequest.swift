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
    public var msisdn: String?
    public var clientId: String?
    public var uuid: UUID = UUID()
    public var osVersion: String = deviceOSVersion()
    public var deviceName: String = modelIdentifier()
    public var osType: String = "iOS"
    public var appVersion: String = "1.0"
    public var origin: String = "MULA_APP"
    public var parseInstallationId: String = "fISa32Gnhwg:APA91bGmtBreiR9tcInsNtdjE1U_elSnAczL0OcFUSwaaG-1G2k9yc6tM3fGMzoEzB5l7sXc5XfsEf1HyiF4RNBTNmcGDBGkXbktrNQJe1STZZ2Sf2Ux0LgJk6okjUx85lu9zzzDziGz"
    public var merchantDetails: String? = ""
    public var profileInfo: String? = ""
    public var apiLevel: String = "13"
    public var isExplicit = "1"
    public init() {}
    public mutating func change(service: String, msisdn: String, clientId: String) {
        self.service = service
        self.msisdn = msisdn
        self.clientId = clientId
    }
    enum CodingKeys: String, CodingKey {
        case service = "SERVICE"
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
