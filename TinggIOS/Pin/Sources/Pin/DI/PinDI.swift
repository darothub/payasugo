//
//  File.swift
//  
//
//  Created by Abdulrasaq on 19/01/2023.
//
import Core
import Foundation
@MainActor
public struct PinDI {
    public init() {
        //public init
    }
    public static func createCardRepository() -> CardRepository {
        CardRepositoryImpl(baseRequest: .init())
    }
    
    public static func createCardPinUsecase() -> CreatePinUsecase {
        CreatePinUsecase(cardRepository: createCardRepository())
    }
    public static func createPinUsecase() -> PinUsecase {
        PinUsecase(createCardPinUsecase: createCardPinUsecase())
    }
    public static func createPinViewModel() -> PinViewModel {
        PinViewModel(usecase: createPinUsecase())
    }
}
