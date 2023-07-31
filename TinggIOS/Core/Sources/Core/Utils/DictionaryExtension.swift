//
//  DictionaryExtension.swift
//  
//
//  Created by Abdulrasaq on 28/07/2023.
//

import Foundation
extension Dictionary {
    public func convertDictionaryToJson() -> String {
        var resultString = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                resultString = jsonString
            }
        } catch {
            return resultString
        }
        return resultString
    }
}
