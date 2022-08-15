//
//  File.swift
//  
//
//  Created by Abdulrasaq on 12/08/2022.
//

import Foundation
import SwiftUI
// Mark:
public enum UIModel {
    public struct Content  {
        public var data: Any?
        public var statusCode: Int
        public var statusMessage: String
        public init(data: Any?, statusCode: Int, statusMessage: String){
            self.statusMessage = statusMessage
            self.statusCode = statusCode
            self.data = data
        }
    }
    case loading
    case content(Content)
    case error(String)
    case nothing
}


