//
//  Models.swift
//  
//
//  Created by Abdulrasaq on 02/03/2023.
//
import Core
import Foundation

public struct SuggestedAmountModel: Hashable, Equatable {
    public var amount: String = ""
    public var historyByAccountNumber: [String] = .init()
    public var currency: String = "KES"
    public init(amount: String = "", historyByAccountNumber: [String] = .init(), currency: String="") {
        self.amount = amount
        self.historyByAccountNumber = historyByAccountNumber
        self.currency = currency
    }
}

public struct FavouriteEnrollmentModel: Hashable, Equatable {
    public var enrollments = [Enrollment]()
    public var enrollment: Enrollment = .init()
    public var accountNumber: String = ""
    public var selectedNetwork: String = ""
    public init(enrollments: [Enrollment] = [Enrollment](), enrollment: Enrollment = .init(), accountNumber: String="", selectedNetwork: String="") {
        self.enrollments = enrollments
        self.enrollment = enrollment
        self.accountNumber = accountNumber
        self.selectedNetwork = selectedNetwork
    }
}

public struct ServicesListModel: Equatable {
    public var selectedProvider: String 
    public var title: String
    public var serviceModels: [ServiceModel]
    public var orientation = ListOrientation.horizontal
    public static var phoneNumber: String = "080"
    public static var othersPhoneNumber: String = ""
    public init(title: String = "Select network provider", serviceModels: [ServiceModel] = [], selectedProvider: String  = "", orientation: ListOrientation = ListOrientation.horizontal) {
        self.selectedProvider = selectedProvider
        self.title = title
        self.serviceModels = serviceModels
        self.orientation = orientation
    }
}

public struct ServiceModel: Equatable {
    public var name: String
    public var logoUrl: String
    public var canOthersPay: Bool
    public init(name: String, logoUrl: String, canOthersPay: Bool = false) {
        self.name = name
        self.logoUrl = logoUrl
        self.canOthersPay = canOthersPay
    }
}

public struct DebitCardModel: Hashable, Equatable {
    public var cardDetails: CardDetailDTO = sampleCardDTO
    public var cardType: String = ""
    public var imageUrl: String = ""
    public var cardNumber: String = ""
    public var holderName: String = ""
    public var expDate: String = ""
    public var cvv: String = ""
    public var address: String = ""
    public init(cardDetails: CardDetailDTO=sampleCardDTO, cardType: String="", imageUrl: String="", cardNumber: String = "", holderName: String = "", expDate: String = "", cvv: String = "", address: String = "") {
        self.cardDetails = cardDetails
        self.cardType = cardType
        self.imageUrl = imageUrl
        self.cardNumber = cardNumber
        self.holderName = holderName
        self.expDate = expDate
        self.cvv = cvv
        self.address = address
    }
}

public struct DebitCardDropDownModel: Hashable, Equatable {
    public var selectedCardDetails: CardDetailDTO = sampleCardDTO
    public var cardDetails: [CardDetailDTO] = [sampleCardDTO]
    public var showDropDown = false
    public init(selectedCardDetails: CardDetailDTO=sampleCardDTO, cardDetails: [CardDetailDTO]=[sampleCardDTO], showDropDown: Bool = false) {
        self.selectedCardDetails = selectedCardDetails
        self.cardDetails = cardDetails
        self.showDropDown = showDropDown
    }
    
}

public enum ListOrientation : Hashable, Equatable{
    case horizontal
    case grid
}

