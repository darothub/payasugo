//
//  File.swift
//  
//
//  Created by Abdulrasaq on 15/12/2022.
//
import Combine
import Core
import Foundation

class BuyAirtimeViewModel: ObservableObject {
    @Published public var suggestedAmountModel: SuggestedAmountModel = .init()
    @Published public var favouriteEnrollmentListModel: FavouriteEnrollmentModel = .init()
    @Published public var providersListModel: ProvidersListModel = .init()
    @Published public var servicesDialogModel: ServicesDialogModel = .init()
    @Published public var dcm: DebitCardModel = .init()
    @Published public var dcddm: DebitCardDropDownModel = .init()
    @Published public var showCardOptions: Bool = false
    public init() {
        //
    }
}


struct SuggestedAmountModel: Hashable, Equatable {
    var amount: String = ""
    var historyByAccountNumber: [String] = .init()
}

struct FavouriteEnrollmentModel: Hashable, Equatable {
    var enrollments = [Enrollment]()
    var accountNumber: String = ""
    var selectedNetwork: String = ""
}

struct ProvidersListModel: Hashable, Equatable {
    var selectedProvider: String = ""
    var details: [ProviderDetails] = .init()
    var selectPaymentTitle = "Select network provider"
    var canOthersPay: Bool = false
    var orientation = ListOrientation.horizontal
}

struct ServicesDialogModel: Hashable, Equatable {
    var phoneNumber: String = "080"
    var airtimeServices = [MerchantService]()
    var selectedButton: String = ""
}

struct DebitCardModel: Hashable, Equatable {
    var cardDetails: CardDetailDTO = sampleCardDTO
    var cardType: String = ""
    var imageUrl: String = ""
}

struct DebitCardDropDownModel: Hashable, Equatable {
    var selectedCardDetails: CardDetailDTO = sampleCardDTO
    var cardDetails: [CardDetailDTO] = [sampleCardDTO, sampleCardDTO2, sampleCardDTO3]
    var showDropDown = false
}
