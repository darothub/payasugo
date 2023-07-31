//
//  ArrayExtension.swift
//  
//
//  Created by Abdulrasaq on 28/07/2023.
//

import Foundation
extension Array {
    public func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
    
    public func isNotEmpty() -> Bool {
        return !self.isEmpty
    }
}
