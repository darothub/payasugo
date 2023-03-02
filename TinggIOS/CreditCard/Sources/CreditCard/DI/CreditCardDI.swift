//
//  File.swift
//  
//
//  Created by Abdulrasaq on 26/01/2023.
//
import Core
import Foundation
@MainActor
public struct CreditCardDI {
    public init() {
        //public init
    }
    
    public static func createCreditCardUsecases() -> CreditCardUsecases {
        CreditCardUsecases(creatChannelUsecase: createCreditChannelUsecase())
    }
    public static func createCreditChannelUsecase() ->  CreateCardChannelUsecase{
        CreateCardChannelUsecase(cardRepository: createCardRepository())
    }
    
    public static func createCardRepository() ->  CardRepository{
        CardRepositoryImpl(baseRequest: .init())
    }
    public static func createCreditCardViewModel() -> CreditCardViewModel {
        CreditCardViewModel(creditCardUsecases: createCreditCardUsecases())
    }
}
