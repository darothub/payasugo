//
//  File.swift
//  
//
//  Created by Abdulrasaq on 16/01/2023.
//

import Foundation
@MainActor
public class CreatePinUsecase {
    private let cardRepository: CardRepository
    /// ``CreatePinUsecase`` initialiser
    /// - Parameter cardRepository: ``CardRepositoryImpl``
    public init (cardRepository: CardRepository) {
        self.cardRepository = cardRepository
    }
    /// A call as function to get country dialcode and country code
    /// - Returns: return as dictionary of  ``BaseDTO`` ``
    public func callAsFunction(tinggRequest: RequestMap) async throws -> BaseDTO {
        try await cardRepository.createPin(tinggRequest: tinggRequest)
    }
}
