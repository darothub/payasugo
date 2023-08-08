//
//  File.swift
//  
//
//  Created by Abdulrasaq on 25/01/2023.
//
import Combine
import CoreUI
import Core
import Foundation
import Alamofire
@MainActor
public class CreditCardViewModel: ViewModel {
//    @Published public var slm: ServicesListModel = .init()
//    @Published public var sam: SuggestedAmountModel = .init()
//    @Published public var fem: FavouriteEnrollmentModel = .init()
//    @Published public var dcm: DebitCardModel = .init()
//    @Published public var dcddm: DebitCardDropDownModel = .init()
    @Published public var cardDetails: CardDetails = .init()
    @Published public var showCardOptions: Bool = false
    @Published public var showCheckOutView: Bool = false
    @Published public var service: MerchantService = sampleServices[0]
    @Published public var isSomeoneElsePaying: Bool = false
    @Published public var selectedMerchantPayerName: String = ""
    @Published public var addNewCard = false
    @Published public var uiModel = UIModel.nothing
    @Published public var showAlert = false
    @Published public var pinPermission: String = ""
    @Published public var pin: String = ""
    @Published public var confirmPin: String = ""
    @Published public var createdPin = false
    @Published public var showCardPinView = false
    @Published public var pinIsCreated: Bool = false
    @Published public var showSecurityQuestionView = false
    @Published public var questions:[String] = .init()
    @Published public var selectedQuestion:String = ""
    @Published public var answer:String = ""
    @Published public var subscriptions = Set<AnyCancellable>()
    @Published public var currentPaymentProvider: MerchantPayer = .init()
    @Published public var merchantPayers: [MerchantPayer] = Observer<MerchantPayer>().getEntities()
    public var cards: [Card] = Observer<Card>().getEntities()
    @Published var cardList: [CardDetails] = []
    
    let creditCardUsecases: CreditCardUsecases
    let tinggApiServices: TinggApiServices = BaseRequest.shared
    
    public init( creditCardUsecases: CreditCardUsecases) {
        self.creditCardUsecases = creditCardUsecases
    }
    
    public func createCreditCardChannel(tinggRequest: RequestMap) async throws  {
        uiModel = UIModel.loading
        do {
            let success = try await creditCardUsecases.createCardChannel(tinggRequest: tinggRequest)
            handleResultState(model: &uiModel, Result.success(success) as Result<Any, Error>)
        } catch {
            handleResultState(model: &uiModel, Result.failure(error as! ApiError) as Result<BaseDTO, ApiError>)
        }
       
    }
    public func populateSavedCards() -> [CardDetails] {
        return cards.compactMap { card in
            let merchantPayer = merchantPayers.first { $0.hubClientID == card.payerClientID }
            guard let merchantPayer = merchantPayer else {
                return nil
            }
            let cardPan = "\(card.cardAlias ?? "0000")"
            var cardDetails = CardDetails(imageUrl: merchantPayer.logo ?? "", cardNumber: cardPan)
            cardDetails.isActive = card.isActive()
            cardDetails.merchantPayer = merchantPayer
            cardDetails.cardType = card.cardType ?? ""
            return cardDetails
        }
    }
    func validatePin(pin: String) -> Bool {
        guard  let mulapinBase64String: Base64String = AppStorageManager.mulaPin else {
//            uiModel = UIModel.error("Pin has not been set for this profile")
            return false
        }
        guard mulapinBase64String.isNotEmpty, let pinDecoded = Data(base64Encoded: mulapinBase64String) else {
//            uiModel = UIModel.error("Error getting pin")
            return false
        }
        do {
            guard let mulaPin: String? = try TinggSecurity.simptleDecryption(pinDecoded) else {
                return false
            }
            return mulaPin == pin
            
        } catch {
            uiModel = UIModel.error(error.localizedDescription)
            return false
        }
    }
    public func validateUser(request: RequestMap) {
        uiModel = UIModel.loading
        Task {
            do {
                let success: BaseDTO = try await tinggApiServices.result(request.encryptPayload()!)
                handleResultState(model: &uiModel, Result.success(success) as Result<Any, Error>)
                
            } catch {
                handleResultState(model: &uiModel, Result.failure(error as! ApiError) as Result<BaseDTO, ApiError>)
            }
        }
    }
    public func deleteCardRequest(request: RequestMap) {
        uiModel = UIModel.loading
        Task {
            do {
                let success: BaseDTO = try await tinggApiServices.result(request.encryptPayload()!)
                handleResultState(model: &uiModel, Result.success(success) as Result<Any, Error>, showAlertOnSuccess: true)
                
            } catch {
                handleResultState(model: &uiModel, Result.failure(error as! ApiError) as Result<BaseDTO, ApiError>)
            }
        }
    }
    /// Handle result
    public func handleResultState<T, E>(model: inout UIModel, _ result: Result<T, E>, showAlertOnSuccess: Bool = false) where E : Error {
        switch result {
        case .failure(let apiError):
            model = UIModel.error((apiError as! ApiError).localizedString)
            return
        case .success(let data):
            var content: UIModel.Content
            if let d = data as? BaseDTOprotocol {
                content = UIModel.Content(data: data, statusMessage: d.statusMessage, showAlert: showAlertOnSuccess)
            } else {
                content = UIModel.Content(data: data, showAlert: showAlertOnSuccess)
            }
            model = UIModel.content(content)
            return
        }
    }
}
