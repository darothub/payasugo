//
//  File.swift
//  
//
//  Created by Abdulrasaq on 17/01/2023.
//

import Foundation
import CommonCrypto
public func cardCheck(number: String) -> Bool {
    if number.count < 16 {
        return false
    }
    var sum = 0
    let digitStrings = number.reversed().map { String($0) }
    for n in 0..<digitStrings.count {
        let j = digitStrings[n]
        let k = Int("\(j)")
        
        if n%2 != 0 {
            if let l = k {
                var m = l*2
                if m > 9 {
                    m = (m % 10) + 1
                }
                sum = sum + m
            }
        } else {
            sum = sum + k!
        }
    }
    
    let result = sum % 10 == 0
    return result
}

public func getMonthFromExpiryDate(expDate: String) -> Int {
    if expDate.count < 2 { return 0 }
    if let month = Int(expDate.prefix(2)) {
        return month
    }
    return 0
}
public func getYearFromExpiryDate(expDate: String) -> Int {
    if expDate.count < 5 { return 0 }
    if let month = Int(expDate.suffix(2)) {
        return month
    }
    return 0
}

public func isExpiryDateValid(expDate: String) -> Bool {
    if expDate.count < 2 { return false }
    let df = DateFormatter()
    df.dateFormat = "MM/yy"
    if let fullExpiryDate = df.date(from: expDate) {
        return fullExpiryDate > Date()
    }
    return false
}


public struct AES {

    // MARK: - Value
    // MARK: Private
    private let key: Data
    private let iv: Data


    // MARK: - Initialzier
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }
    
        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }
    
    
        self.key = keyData
        self.iv  = ivData
    }
    public init?() {
        self.init(key: "98fKDxx1tFniKBP4", iv: "laenjci52USCpys8")
    }

    public static func encrypt(data: String) -> String {
        let aes256 = AES()
        return (aes256?.encrypt(string: data)?.base64EncodedString())!
    }
    public static func decrypt(data: Data?) -> String {
        let aes256 = AES()
        if let d = data {
            return (aes256?.decrypt(data: d))!
        }
        return ""
    }

    // MARK: - Function
    // MARK: Public
    private func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }

    private func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }

    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }
    
        let cryptLength = data.count + key.count
        var cryptData   = Data(count: cryptLength)
    
        var bytesLength = Int(0)
    
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                    CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), CCOptions(kCCOptionPKCS7Padding), keyBytes.baseAddress, key.count, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }
    
        
        guard Int32(status) == Int32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }
    
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}
