//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//

import Foundation
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
