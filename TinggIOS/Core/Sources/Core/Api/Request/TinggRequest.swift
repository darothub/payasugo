//
//  TinggRequest.swift
//
//
//  Created by Abdulrasaq on 07/07/2022.
//

import Foundation

import CryptoSwift
import UIKit
@available(swift, deprecated: 5.0 , message: "This has been deprecated in build 9.0 v0.1.0 use Request instead")
/// A type for parameterized for tingg request
public struct TinggRequest: Encodable {
    public var service: String?
    public var accountNumber: String?
    public var msisdn: String? = AppStorageManager.getPhoneNumber()
    public var clientId: String? = AppStorageManager.getCountry()?.mulaClientID
    public var activationCode: String?
    public var uuid: String = uuidForVendor
    public var osVersion: String = deviceOSVersion()
    public var deviceName: String = modelIdentifier()
    public var osType: String = "iOS"
    public var appVersion: String = "4.0.23"
    public var origin: String = "MULA_APP"
    public var parseInstallationId: String = AppStorageManager.getDeviceToken()
    public var merchantDetails: String? = ""
    public var profileInfo: String? = ""
    public var apiLevel: Int = 15
    public var isExplicit = "1"
    public var dataSource: String? = AppStorageManager.getCountry()?.name
    public var billAccounts: [BillAccount]?
    public var serviceId: String? = ""
    public var action: String = ""
    public var defaultNetworkServiceId = AppStorageManager.getDefaultNetworkId()
    public var isNomination = ""
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
        case isNomination = "IS_NOMINATION"
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

public func deviceOSVersion() -> String {
    return UIDevice.current.systemVersion
}
public var uuidForVendor: String {
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
        return uuid
    }
    return ""
}

public struct RequestMap  {
    public var dict: [String: Any]
    private var iv: String?
    private var secretKey:String?
    public var base64Payload: [String: String] = [:]
    private init(dict: [String: Any]) {
        self.dict = dict
    }
    public class Builder {
        fileprivate var dict: [String: Any] = [:]
        private var parseInstallationId: String = AppStorageManager.getDeviceToken()
        
        public init() {
            
            self.dict.updateValue(AppStorageManager.getPhoneNumber(), forKey: RequestKey.MSISDN.str)
            if let clientId = AppStorageManager.getCountry()?.mulaClientID, let countryName = AppStorageManager.getCountry()?.name {
                self.dict.updateValue(clientId, forKey: RequestKey.CLIENT_ID.str)
                self.dict.updateValue(countryName, forKey: RequestKey.DATA_SOURCE.str)
            }
            self.dict.updateValue(uuidForVendor, forKey: RequestKey.UUID.str)
            self.dict.updateValue(deviceOSVersion(), forKey: RequestKey.OS_VERSION.str)
            self.dict.updateValue(modelIdentifier(), forKey: RequestKey.DEVICE_NAME.str)
            self.dict.updateValue(15, forKey: RequestKey.API_LEVEL.str)
            self.dict.updateValue( "iOS", forKey: RequestKey.OS_TYPE.str)
            self.dict.updateValue("4.0.73", forKey: RequestKey.APP_VERSION.str)
            self.dict.updateValue("MULA_APP", forKey: RequestKey.ORIGIN.str)
            self.dict.updateValue(parseInstallationId, forKey: RequestKey.PARSE_INSTALLATION_ID.str)
            self.dict.updateValue("1", forKey: RequestKey.IS_EXPLICIT.str)
        }
        public func clear() -> Builder {
            dict.removeAll()
            return self
        }
        public func add<T>(value: T, for key: RequestKey) -> Builder where T: Encodable {
            dict.updateValue(value, forKey: key.str)
            return self
        }
        public func add<T>(value: T, for key: String) -> Builder where T: Encodable {
            dict.updateValue(value, forKey: key)
            return self
        }
        public func build() -> RequestMap {
            RequestMap(dict: dict)
        }
    }
    public func encryptPayload() -> [String: String]? {
        let iv = TinggSecurity.generateRandomAlphanumericString(length: 12)
        let secretKey = TinggSecurity.generateRandomAlphanumericString(length: 32)
        let dictCopy = dict
        let payload = dictCopy.convertDictionaryToJson()
        let ivByte = iv.data(using: .utf8)!
        let secretKeyByte = secretKey.data(using: .utf8)!
        let ivbase64String = ivByte.base64EncodedString()
        let secretKeyBase64String = secretKeyByte.base64EncodedString()
        if let encryptedDataInBase64String = TinggSecurity.symmetricEncrypt(plainText: payload, secretKeyBase64: secretKeyBase64String, ivBase64: ivbase64String),
           let encryptedData = Data(base64Encoded: encryptedDataInBase64String) {
            return encryptSecretKeyAsymmetrically(secretKeyBase64String, ivbase64String, encryptedPayload: encryptedData)
        }
        return nil
    }
    func encryptSecretKeyAsymmetrically(_ key: String, _ iv: String, encryptedPayload: Data) -> [String: String]? {
        guard let publicKeyData = AppStorageManager.getPublicKeyData() else {
            return nil
        }
        guard let publicKey = TinggSecurity.dataToSecKey(publicKeyData, isPrivateKey: false) else {
         
            return nil
        }
        Log.d(message: "Public key \(publicKey)")
        do {
            let encryptedSecretKeyData = try TinggSecurity.asymmetricEncrypt("\(key):\(iv)", publicKey: publicKey)
            var payloadDict = [String: String]()
            payloadDict["PAYLOAD"] = encryptedPayload.base64EncodedString()
            payloadDict["SIGNATURE"] = encryptedSecretKeyData.base64EncodedString()
            let json = payloadDict.convertDictionaryToJson()
            let data = json.data(using: .utf8)
            let base64String = data?.base64EncodedString()
            Log.d(message: base64String!)
            var messageDict = [String:String]()
            messageDict["MESSAGE"] = base64String
            return messageDict
        } catch {
            print(error)
            return nil
        }
    }
    public enum RequestKey: String {
        case MSISDN
        case CLIENT_ID
        case SERVICE
        case ACCOUNT_NUMBER
        case UUID
        case OS_VERSION
        case DEVICE_NAME
        case OS_TYPE
        case APP_VERSION
        case ORIGIN
        case PARSE_INSTALLATION_ID
        case MERCHANT_DETAILS
        case PROFILE_INFO
        case API_LEVEL
        case IS_EXPLICIT
        case ACTIVATION_CODE
        case DATA_SOURCE
        case SERVICE_ID
        case BILL_ACCOUNTS
        case ACTION
        case DEFAULT_NETWORK_SERVICE_ID
        case IS_NOMINATION
        case QUESTION_ID
        case SECURITY_ANSWER
        case CARD_ALIAS
        case AMOUNT
        var str: String {
            return self.rawValue
        }
    }
}





