//
//  Base64String.swift
//  
//
//  Created by Abdulrasaq on 28/07/2023.
//

import Foundation
public typealias Base64String = String

extension Base64String {
    public func decodeToLiteralString() -> String? {
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
}
