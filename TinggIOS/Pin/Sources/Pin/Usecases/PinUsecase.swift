//
//  File.swift
//  
//
//  Created by Abdulrasaq on 19/01/2023.
//

import Core
@MainActor
public class PinUsecase {
    private var createCardPinUsecase: CreatePinUsecase
    
    public init(createCardPinUsecase: CreatePinUsecase) {
        self.createCardPinUsecase = createCardPinUsecase
    }
    
    func createCardPin(tinggRequest: RequestMap) async throws -> BaseDTO {
       try await createCardPinUsecase(tinggRequest: tinggRequest)
    }
}
