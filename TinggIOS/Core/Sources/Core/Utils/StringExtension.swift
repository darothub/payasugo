//
//  StringExtension.swift
//
//
//  Created by Abdulrasaq on 28/07/2023.
//

import Foundation
extension String {
    public func convertToBase64String() -> String? {
        if let inputData = self.data(using: .utf8) {
            return inputData.base64EncodedString()
        }
        return nil
    }
    public func decodeFromeBase64StringToOriginal() -> String? {
        if let decodedData = Data(base64Encoded: self) {
            if let originalString = String(data: decodedData, encoding: .utf8) {
                return originalString
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    public func applyPattern(pattern: String = "#### #### #### ####", replacmentCharacter: Character = "#") -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    public func applyDatePattern(pattern: String = "##/##", replacmentCharacter: Character = "#") -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }

    public func convertStringToInt() -> Int {
        let floatValue = Float(self)
        let intAmount = Int(floatValue ?? 0.0)
        return intAmount
    }
    public var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    public func isValidEmail() -> Bool {
        guard let regex = try? NSRegularExpression(pattern: "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$", options: .caseInsensitive) else {
            return false
        }
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    public func checkStringForPatterns(pattern: String) -> Bool {
        do {
            let regex = try Regex(pattern)
            let match = self.firstMatch(of: regex)
            let result = match?.output.last?.value
            return result != nil
        } catch {
            print("Regex error: \(error)")
            return false
        }
    }
    public func validateWithRegex(_ regex: String) -> Bool {
        let tester = NSPredicate(format:"SELF MATCHES %@", regex)
        return tester.evaluate(with: self)
    }
}
