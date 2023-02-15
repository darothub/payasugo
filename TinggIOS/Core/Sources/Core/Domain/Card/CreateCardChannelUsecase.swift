//
//  File.swift
//  
//
//  Created by Abdulrasaq on 25/01/2023.
//

import Foundation
@MainActor
public class CreateCardChannelUsecase {
    private let cardRepository: CardRepository
    /// ``CreateCardChannelUsecase`` initialiser
    /// - Parameter cardRepository: ``CardRepositoryImpl``
    public init (cardRepository: CardRepository) {
        self.cardRepository = cardRepository
    }
    /// A call as function to get country dialcode and country code
    /// - Returns: return as dictionary of  ``BaseDTO`` ``
    public func callAsFunction(tinggRequest: RequestMap) async throws -> CreateCardChannelResponse {
        try await cardRepository.createCardChannel(tinggRequest: tinggRequest)
    }
}
