//
//  File.swift
//  
//
//  Created by Abdulrasaq on 12/08/2022.
//

import Foundation
import SwiftUI
// Mark:
/// An enum class that holds UI states
@MainActor
public enum UIModel: Equatable {
    nonisolated public static func == (lhs: UIModel, rhs: UIModel) -> Bool {
        switch(lhs, rhs) {
        case (.content(let lh), .content(let rh)):
            return lh.statusMessage == rh.statusMessage
            
        case (.loading, _):
            return false
        case (.error(_), _):
            return false
        case (.nothing, _):
            return false
        case (_, .loading):
            return false
        case (_, .error(_)):
            return false
        case (_, .nothing):
            return false
        }
    }
    
    public struct Content  {
        public var data: Any?
        public var statusCode: Int = 0
        public var statusMessage: String = ""
        public var showAlert = false
        public init(data: Any?, statusCode: Int, statusMessage: String, showAlert: Bool = false){
            self.statusMessage = statusMessage
            self.statusCode = statusCode
            self.data = data
            self.showAlert = showAlert
        }
        public init(statusMessage: String, showAlert: Bool = false) {
            self.statusMessage = statusMessage
            self.showAlert = showAlert
        }
        public init(data: Any?, showAlert: Bool = false){
            self.data = data
            self.showAlert = showAlert
        }
        public init(data: Any?, statusMessage: String, showAlert: Bool = false){
            self.data = data
            self.statusMessage = statusMessage
            self.showAlert = showAlert
        }
    }
    case loading
    case content(Content)
    case error(String)
    case nothing
}


