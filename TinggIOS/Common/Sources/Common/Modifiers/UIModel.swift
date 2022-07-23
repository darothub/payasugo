//
//  File.swift
//  
//
//  Created by Abdulrasaq on 22/07/2022.
//

import SwiftUI
import Core
import Domain

public enum UIModel {
    
    public class Content<T: BaseDTOprotocol> : ObservableObject {
        @State public var data: T
        public init(data: T) {
            self.data = data
        }
    }
    case loading
    case content(BaseDTOprotocol)
    case error(String)
    case nothing
}
