//
//  CreditCardUtil.swift
//  
//
//  Created by Abdulrasaq on 11/02/2023.
//

import CommonCrypto
import Foundation
public struct CreditCardUtil {
    public private(set) var text = "Hello, World!"
    private static let keyData     = "98fKDxx1tFniKBP4".data(using:String.Encoding.utf8)!
    private static let ivData      = "laenjci52USCpys8".data(using:String.Encoding.utf8)!

    public init() {
        //Sample
//        let message     = "5555555555554444"
//        let messageData = message.data(using:String.Encoding.utf8)!
//        let keyData     = "98fKDxx1tFniKBP4".data(using:String.Encoding.utf8)!
//        let ivData      = "laenjci52USCpys8".data(using:String.Encoding.utf8)!
//
//        let encryptedData = testCrypt(data:messageData,   keyData:keyData, ivData:ivData, operation:kCCEncrypt)
//        print(encryptedData.hexEncodedString())
//        let datas = dataWithHexString(hex: encryptedData.hexEncodedString())
//
//        let decryptedData = testCrypt(data:datas, keyData:keyData, ivData:ivData, operation:kCCDecrypt)
//        var decrypted     = String(bytes:decryptedData, encoding:String.Encoding.utf8)!
//        print(decrypted)
    }
    
    public static func encrypt(data: String) -> String {
        var original = data
        let paddedData = original.padding()
        guard let dataObject = paddedData.data(using: .utf8) else {
            fatalError("CreditCardUtil -> PaddedData can not be converted")
        }
        return encrypt(data: dataObject)
    }
    
    public static func encrypt(data: Data) -> String {
        return testCrypt(data: data, keyData: keyData, ivData: ivData, operation: kCCEncrypt).hexEncodedString()
    }
    public static func decrypt(data: String) -> String {
        let dataFromHexString = dataWithHexString(hex: data)
        let decryptedData = testCrypt(data: dataFromHexString, keyData: keyData, ivData: ivData, operation: kCCDecrypt)
        return String(bytes:decryptedData, encoding:String.Encoding.utf8)!
    }
    
    private static func testCrypt(data:Data, keyData:Data, ivData:Data, operation:Int) -> Data {
        let cryptLength  = size_t(data.count + kCCBlockSizeAES128)
        var cryptData = Data(count:cryptLength)

        let keyLength  = size_t(kCCKeySizeAES128)
        let options   = CCOptions(ccNoPadding)

        var numBytesEncrypted :size_t = 0

        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes {dataBytes in
                ivData.withUnsafeBytes {ivBytes in
                    keyData.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(operation),
                                  CCAlgorithm(kCCAlgorithmAES),
                                  options,
                                  keyBytes, keyLength,
                                  ivBytes,
                                  dataBytes, data.count,
                                  cryptBytes, cryptLength,
                                  &numBytesEncrypted)
                    }
                }
            }
        }

        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)

        } else {
            print("Error: \(cryptStatus)")
        }

        return cryptData;
    }
    private static func dataWithHexString(hex: String) -> Data {
        var hex = hex
        var data = Data()
        while(hex.count > 0) {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let c = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }

}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let hexDigits = Array((options.contains(.upperCase) ? "0123456789ABCDEF" : "0123456789abcdef").utf16)
        var chars: [unichar] = []
        chars.reserveCapacity(2 * count)
        for byte in self {
            chars.append(hexDigits[Int(byte / 16)])
            chars.append(hexDigits[Int(byte % 16)])
        }

        return String(utf16CodeUnits: chars, count: chars.count)
    }
}

extension String {
   public func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    public func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    public mutating func padding() -> String {
        let paddingChar = " "
        let size = 16
        let modulo = self.count % size
        let padLength = size - modulo
        
        for _ in 0..<padLength {
            self += paddingChar
        }
        return self
    }
}
