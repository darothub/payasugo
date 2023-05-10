//
//  CoreDI.swift
//  
//
//  Created by Abdulrasaq on 08/05/2023.
//

import Foundation
public struct CoreDI {
    public static func createSendRequest(baseRequest: BaseRequest) -> SendRequest {
        SendRequest(baseRequest: BaseRequest())
    }
    
}
