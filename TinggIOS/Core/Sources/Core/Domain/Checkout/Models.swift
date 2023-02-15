//
//  File.swift
//  
//
//  Created by Abdulrasaq on 14/12/2022.
//

import Foundation

public struct SuggestedAmountModel: Hashable, Equatable {
    public var amount: String = ""
    public var historyByAccountNumber: [String] = .init()
    public var currency: String = ""
    public init(amount: String = "", historyByAccountNumber: [String]=[], currency: String="") {
        self.amount = amount
        self.historyByAccountNumber = historyByAccountNumber
        self.currency = currency
    }
}

public struct FavouriteEnrollmentModel: Hashable, Equatable {
    public var enrollments = [Enrollment]()
    public var accountNumber: String = ""
    public var selectedNetwork: String = ""
    public init(enrollments: [Enrollment] = [Enrollment](), accountNumber: String="", selectedNetwork: String="") {
        self.enrollments = enrollments
        self.accountNumber = accountNumber
        self.selectedNetwork = selectedNetwork
    }
}

public struct ProvidersListModel: Hashable, Equatable {
    public var selectedProvider: String = ""
    public var details: [ProviderDetails] = .init()
    public var selectPaymentTitle = "Select network provider"
    public var canOthersPay: Bool = false
    public var orientation = ListOrientation.horizontal
    public init(selectedProvider: String="", details: [ProviderDetails]=[], selectPaymentTitle: String = "Select network provider", canOthersPay: Bool=false, orientation: ListOrientation = ListOrientation.horizontal) {
        self.selectedProvider = selectedProvider
        self.details = details
        self.selectPaymentTitle = selectPaymentTitle
        self.canOthersPay = canOthersPay
        self.orientation = orientation
    }
}

public struct ServicesDialogModel: Hashable, Equatable {
    public var phoneNumber: String = "080"
    public var airtimeServices = [MerchantService]()
    public var selectedButton: String = ""
    public init(phoneNumber: String="", airtimeServices: [MerchantService] = [MerchantService](), selectedButton: String="") {
        self.phoneNumber = phoneNumber
        self.airtimeServices = airtimeServices
        self.selectedButton = selectedButton
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

public struct ProviderDetails: Hashable {
    public var service: MerchantService
    public var payer: MerchantPayer
    public var othersCanPay: Bool
    public var accountNumber: String
    public var uniqueAmount: [String]
    
    public init(service: MerchantService  = sampleServices[0], payer: MerchantPayer = .init(), othersCanPay: Bool = false, accountNumber: String = "", uniqueAmount: [String] = .init()) {
        self.service = service
        self.payer = payer
        self.othersCanPay = othersCanPay
        self.accountNumber = accountNumber
        self.uniqueAmount = uniqueAmount
    }
 
}
public enum ListOrientation : Hashable, Equatable{
    case horizontal
    case grid
}

