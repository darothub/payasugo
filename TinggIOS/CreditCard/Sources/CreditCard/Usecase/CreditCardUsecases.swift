//
//  File.swift
//  
//
//  Created by Abdulrasaq on 26/01/2023.
//

import Core
import Foundation
public class CreditCardUsecases {
    let creatChannelUsecase: CreateCardChannelUsecase
    public init(creatChannelUsecase: CreateCardChannelUsecase) {
        self.creatChannelUsecase = creatChannelUsecase
    }
    
    public func createCardChannel(tinggRequest: RequestMap) async throws -> CreateCardChannelResponse {
        try await creatChannelUsecase(tinggRequest: tinggRequest)
    }
}
