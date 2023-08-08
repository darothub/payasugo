//
//  SettingsViewModel.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 03/08/2023.
//
import Core
import CoreUI
import Foundation
import Combine
import CoreNavigation
import Pin

@MainActor
public class SettingsViewModel: ViewModel {
    @Published public var uiModel = UIModel.nothing
    @Published var billReminderUIModel = UIModel.nothing
    @Published var defaultNetworkUIModel = UIModel.nothing
    @Published var campaignMessageUIModel = UIModel.nothing
    @Published var setNewPin = AppStorageManager.mulaPin == nil
    @Published private var optInForBillReminder = AppStorageManager.optInForBillReminder()
    @Published private var optInForCampaignMessage = AppStorageManager.optInForCampaignMessages()
    @Published var selectedPinRequestChoice = AppStorageManager.pinRequestChoice
    @Published var settings: [SettingsSectionItem] = []
    @Published public var disablePinUIModel = UIModel.nothing
    @Published public var pinRequestChoiceUIModel = UIModel.nothing
    
    var subscriptions = Set<AnyCancellable>()
    var baseRequest: TinggApiServices = BaseRequest()
    private var actionWordForBillReminder: String {
        optInForBillReminder ? "Disable" : "Enable"
    }
    private var actionWordForCampaignMessage: String {
        optInForCampaignMessage ? "Disable" : "Enable"
    }
    public static let shared = SettingsViewModel()
    
    public init() {
        //
    }
    func updateDefaultNetworkId(request: RequestMap) {
        defaultNetworkUIModel = UIModel.loading

        Task {
            do {
                let result:BaseDTO = try await baseRequest.result(request.encryptPayload()!)
                handleResultState(model: &defaultNetworkUIModel, Result.success(result) as Result<Any, Error>, showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &defaultNetworkUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }
    }

    func updateBillReminder(request: RequestMap) {
        billReminderUIModel = UIModel.loading
        Task {
            do {
                let result:BaseDTO = try await baseRequest.result(request.encryptPayload()!)
                handleResultState(model: &billReminderUIModel, Result.success(result) as Result<Any, Error>, showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &billReminderUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }
    }

    func updateCampaignMessages(request: RequestMap) {
        campaignMessageUIModel = UIModel.loading
        Task {
            do {
                let result:BaseDTO = try await baseRequest.result(request.encryptPayload()!)
                handleResultState(model: &campaignMessageUIModel, Result.success(result) as Result<Any, Error>, showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &campaignMessageUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }
    }
    func pinNotYetSet() -> Bool {
        guard  let pin: Base64String = AppStorageManager.mulaPin else {
//            uiModel = UIModel.error("Pin has not been set for this profile")
            return true
        }
        guard pin.isNotEmpty, let pinDecoded = Data(base64Encoded: pin) else {
//            uiModel = UIModel.error("Error getting pin")
            return true
        }
        do {
            guard let _: String? = try TinggSecurity.simptleDecryption(pinDecoded) else {
                return true
            }
            Log.d(message: "\(setNewPin)")
            return false
            
        } catch {
            uiModel = UIModel.error(error.localizedDescription)
            return true
        }
    }
    func populateSettings() -> [SettingsSectionItem] {
        let allSettings = [
            SettingsSectionItem(section: SettingsSectionItem.GENERAL, items: [
                SettingsItem(main: SettingsItem.CARD, actionInformation: "Add or Delete card"),
                SettingsItem(main: SettingsItem.MOBILENETWORK, actionInformation: "Choose your main mobile network")
            ]),
            SettingsSectionItem(section: SettingsSectionItem.TINGPIN , items: [
                SettingsItem(main: SettingsItem.SETPIN, actionInformation: "", isActive: setNewPin),
                SettingsItem(main: SettingsItem.CHANGEPIN, actionInformation: "", isActive: !setNewPin),
                SettingsItem(main: SettingsItem.REMOVEPIN, actionInformation: "", isActive: !setNewPin),
                SettingsItem(main: SettingsItem.SECURITYLEVEL, actionInformation: selectedPinRequestChoice, isActive: !setNewPin)
            ]),
            SettingsSectionItem(section: SettingsSectionItem.NOTIFICATION, items: [
                SettingsItem(main: SettingsItem.BILLREMINDER, actionInformation: "\(actionWordForBillReminder) receiving bill reminders", showBoolItem: true, isToggled: optInForBillReminder),
                SettingsItem(main: SettingsItem.CAMPAIGNMESSAGE, actionInformation: "\(actionWordForCampaignMessage) receiving campaign messages", showBoolItem: true, isToggled: optInForCampaignMessage)
            ]),
            SettingsSectionItem(section: SettingsSectionItem.ACCOUNT, items: [
                SettingsItem(main: SettingsItem.DEACTIVATEACCOUNT, actionInformation: "")
            ])
        ]
        return allSettings
    }
    public func disablePin(request: RequestMap) {
        disablePinUIModel = UIModel.loading
        Task {
            do {
                let result:BaseDTO = try await baseRequest.result(request.encryptPayload()!)
                handleResultState(model: &disablePinUIModel, (Result.success(result) as Result<Any, Error>), showAlertOnSuccess: true)
                AppStorageManager.mulaPin = ""
            } catch {
                handleResultState(model: &disablePinUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }
    }
    
    public func updatePinRequestChoice(request: RequestMap) {
        pinRequestChoiceUIModel = UIModel.loading
        Task {
            do {
                let result:BaseDTO = try await baseRequest.result(request.encryptPayload()!)
                handleResultState(model: &pinRequestChoiceUIModel, (Result.success(result) as Result<Any, Error>), showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &pinRequestChoiceUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }
    }
    public func onFinishPinInput(_ pin: String, callback: (String) -> Void) {
        guard let mulaPin: Base64String =  AppStorageManager.mulaPin else {
            return
        }
        guard mulaPin.isNotEmpty else {
            return
        }
        guard let mulaPinData = Data(base64Encoded: mulaPin) else {
            return
        }
        do {
            guard let decryptedPin: String? = try TinggSecurity.simptleDecryption(mulaPinData), pin == decryptedPin else {
                uiModel = UIModel.error("Invalid pin")
                return
            }
            callback(mulaPin)
            
        } catch {
            uiModel = UIModel.error(error.localizedDescription)
        }
    }
    /// Handle result
    public func handleResultState<T, E>(model: inout UIModel, _ result: Result<T, E>, showAlertOnSuccess: Bool = false) where E: Error {
        switch result {
        case let .failure(apiError):
            model = UIModel.error((apiError as! ApiError).localizedString)
            return
        case let .success(data):
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

