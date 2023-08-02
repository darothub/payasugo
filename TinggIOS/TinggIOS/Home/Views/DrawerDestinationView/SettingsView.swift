//
//  SettingsView.swift
//  
//
//  Created by Abdulrasaq on 02/05/2023.
//
import Core
import CoreUI
import SwiftUI
import Theme
import CoreNavigation
import Pin
struct SettingsView: View, OnSettingClick, OnNetweorkSelectionListener, OnSuccessfulPINActionListener {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var hvm = HomeDI.createHomeViewModel()
    @EnvironmentObject var navigation: NavigationManager
    @State private var settings: [SettingsSectionItem] = []
    @State private var list:[String] = ["Hello", "Hi"]
    @State private var showNetworkList = false
    @State private var networkList: [NetworkItem] = []
    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false
    @State private var defaultService: MerchantService = .init()
    @State private var defaultServiceName = ""
    @State private var phoneNumber: String = ""
    @State private var message: String = ""
    @State private var optInForBillReminder = AppStorageManager.optInForBillReminder()
    @State private var optInForCampaignMessage = AppStorageManager.optInForCampaignMessages()
    @State var pin = ""
    @State var showPinDialog = false
    @State var showPinAlert = false
    @State var showPinRequestChoiceDialog = false
    @State var selectedPinRequestChoice: String = ""
    @State var nextActionForPin = ""
    private var actionWordForBillReminder: String {
        optInForBillReminder ? "Disable" : "Enable"
    }
    private var actionWordForCampaignMessage: String {
        optInForCampaignMessage ? "Disable" : "Enable"
    }
    var body: some View {
        VStack {
            List {
                ForEach($hvm.settings, id: \.id) { $sectionedSetting in
                    SettingsSectionItemView(section: $sectionedSetting, delegate: self)
                        .listRowBackground(colorScheme == .dark ? Color.white : Color.white)
                }
            }
            .backgroundmode(color: .gray.opacity(0.1))
            .scrollContentBackground(.hidden)
        }
        .backgroundmode(color: .white)
        .onAppear {
            checkIfPinIsSet()
            hvm.$setNewPin.sink { newValue in
                hvm.settings = hvm.populateSettings()
                hvm.selectedPinRequestChoice = AppStorageManager.pinRequestChoice
                log(message: "Pin is set \(newValue)")
            }.store(in: &hvm.subscriptions)
          
            phoneNumber = AppStorageManager.getPhoneNumber()
            defaultService = AppStorageManager.getDefaultNetwork() ?? .init()
            defaultServiceName = defaultService.serviceName
        }
        .customDialog(isPresented: $showNetworkList, cancelOnTouchOutside: .constant(true)) {
            DialogContentView(networkList: networkList, phoneNumber: phoneNumber, selectedServiceName: defaultServiceName, listener: self)
                .padding()
        }
        .customDialog(isPresented: $showPinDialog, cancelOnTouchOutside: .constant(true)) {
            EnterPinDialogView(pin: pin, next: nextActionForPin, listener: self)
        }
        .customDialog(isPresented: $showPinRequestChoiceDialog, cancelOnTouchOutside: .constant(true)) {
            SelectPinRequestTypeView(pinRequestChoice: $hvm.selectedPinRequestChoice) { choice in
                showPinRequestChoiceDialog = false
                showPinDialog = true
                nextActionForPin = "UPDATE_CHOICE"
            } onClickLater: {
                showPinRequestChoiceDialog = false
            }
        }

        .alert(isPresented: $showPinAlert) {
            Alert(
                title: Text("Clear Old PIN and Information?").font(.headline),
                message: Text("When you Reset Tingg PIN , your saved card(s) alias will also be reset.").font(.caption),
                primaryButton: .default(Text("OK"), action: {
                    print("OK tapped")
                    showPinDialog = true
                    showPinAlert = false
                    nextActionForPin = "DISABLE"
                }),
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
        .onChange(of: selectedPinRequestChoice){ newValue  in
            log(message: newValue)
        }
        .handleUIState(uiState: $hvm.billReminderUIModel) { content in
            let dto = content.data as! BaseDTO
            updateStorageBillReminderContent(dto: dto)
        } action: {
            updateBillReminderItem()
        }
        .handleUIState(uiState: $hvm.campaignMessageUIModel, showAlertonSuccess: true) { content in
            let dto = content.data as! BaseDTO
            updateStorageCampaignMessageContent(dto: dto)
        } action: {
            updateCampaignMessageItem()
        }
        .handleUIState(uiState: $hvm.defaultNetworkUIModel, showAlertonSuccess: true) { content in
            log(message: content)
        } action: {
            dismissDialogView()
        }
        .handleUIState(uiState: $hvm.disablePinUIModel, showAlertonSuccess: true) { content in
            log(message: "Pin disable request")
        } action: {
            hvm.setNewPin = true
            hvm.selectedPinRequestChoice = ""
            hvm.settings = hvm.populateSettings()
            showPinDialog = false
        }
        .handleUIState(uiState: $hvm.pinRequestChoiceUIModel, showAlertonSuccess: true) { content in
            log(message: "Pin update request")
        } action: {
            AppStorageManager.pinRequestChoice = hvm.selectedPinRequestChoice
            hvm.settings = hvm.populateSettings()
            showPinDialog = false
        }
        .handleUIState(uiState: $hvm.uiModel, showAlertonSuccess: true)
        .navigationBarBackButton(navigation: navigation)
    }
    func dismissDialogView() {
        showNetworkList = false
    }
    func checkIfPinIsSet() {
        guard  let pin: Base64String = AppStorageManager.mulaPin else {
            return
        }
        guard pin.isNotEmpty, let pinDecoded = Data(base64Encoded: pin) else {
           return
        }
        do {
            guard let pinString: String? = try TinggSecurity.simptleDecryption(pinDecoded) else {
                return
            }
            hvm.setNewPin = !((pinString?.isNotEmpty) != nil)
        } catch {
            hvm.uiModel = UIModel.error(error.localizedDescription)
        }
    }
    func otpSuccessful(_ otp: String, next: String) {
        switch next {
        case "DISABLE":
            onOTPComplete(otp) { mulaPin in
                let request = RequestMap.Builder()
                    .add(value: "DISABLE_PIN", for: .ACTION)
                    .add(value: "MPM", for: .SERVICE)
                    .add(value: mulaPin, for: "MULA_PIN")
                    .build()
                hvm.disablePin(request: request)
            }
        case "UPDATE_CHOICE":
            onOTPComplete(otp) { mulaPin in
                let request = RequestMap.Builder()
                    .add(value: "UPDATE_PIN_REQUEST_TYPE", for: .ACTION)
                    .add(value: "MPM", for: .SERVICE)
                    .add(value: mulaPin, for: "MULA_PIN")
                    .build()
                hvm.updatePinRequestChoice(request: request)
            }
        default:
            log(message: "Default")
        }
    }
    func onOTPComplete(_ otp: String, callback: (String) -> Void) {
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
            guard let pin: String? = try TinggSecurity.simptleDecryption(mulaPinData) else {
                return
            }
            if otp == pin {
                callback(mulaPin)
            } else {
                hvm.uiModel = UIModel.error("Invalid pin")
            }
            
        } catch {
            hvm.uiModel = UIModel.error(error.localizedDescription)
        }
    }
    func onItemClick(_ item: SettingsItem) {
        switch item.main {
        case SettingsItem.MOBILENETWORK:
            showNetworks()
        case SettingsItem.SETPIN:
            navigation.navigateTo(screen: PinScreen.pinView)
        case SettingsItem.CHANGEPIN, SettingsItem.REMOVEPIN:
           showPinAlert = true
        case SettingsItem.SECURITYLEVEL:
            showPinRequestChoiceDialog = true
        default:
            showNetworkList = false
        }
    }
    func showNetworks() {
        showNetworkList = true
        let airtimeServices = Observer<MerchantService>().getEntities().filter { $0.isAirtimeService }
        networkList = airtimeServices.map { service in
            NetworkItem(
                imageUrl: service.serviceLogo,
                networkName: service.serviceName,
                selectedNetwork: service.serviceName
            )
        }
    }
    func onToggle(_ item: inout SettingsItem) {
        let option = item.isToggled ? "Y" : "N"
        let request = RequestMap.Builder()
            .add(value: option, for: "CAN_REMIND")
            .add(value: true, for: "IS_LIVE_API")
            .add(value: "OON", for: .SERVICE)
        if item.actionInformation.contains("Disable") {
            item.actionInformation = item.actionInformation.replacingOccurrences(of: "Disable", with: "Enable")
        } else {
            item.actionInformation = item.actionInformation.replacingOccurrences(of: "Enable", with: "Disable")
        }
        if item.main == "Bill reminder" {
            let req = request
                .add(value: "OPT_OUT_BILL_REMINDERS", for: .ACTION)
                .build()
            hvm.updateBillReminder(request: req)
        } else {
            let req = request
                .add(value: "OPT_OUT_CAMPAIGN_MESSAGES", for: .ACTION)
                .build()
            hvm.updateCampaignMessages(request: req)
        }
      
    }
    func onServiceSubmission(selected: String) {
        let service = Observer<MerchantService>().getEntities().first { serv in
            serv.serviceName == selected
        }
        if let s = service {
            defaultService = s
            let request = RequestMap.Builder()
                .add(value: s.hubServiceID.convertStringToInt(), for: "DEFAULT_NETWORK_SERVICE_ID")
                .add(value: "UPN", for: .SERVICE)
                .build()
            hvm.updateDefaultNetworkId(request: request)
        }
    }
    
    func onDismiss() {
        dismissDialogView()
    }
    private func updateStorageBillReminderContent(dto: BaseDTO) {
        if dto.statusCode == 200 && dto.statusMessage.contains("opted in"){
            optInForBillReminder = true
            AppStorageManager.setOptForBillReminder(value: optInForBillReminder)
        } else {
            optInForBillReminder = false
            AppStorageManager.setOptForBillReminder(value: optInForBillReminder)
        }
    }
    private func updateStorageCampaignMessageContent(dto: BaseDTO) {
        if dto.statusCode == 200 && dto.statusMessage.contains("opted in") {
            optInForCampaignMessage = true
            AppStorageManager.setOptForCampaignMessages(value: true)
        } else {
            optInForCampaignMessage = false
            AppStorageManager.setOptForCampaignMessages(value: optInForCampaignMessage)
        }
    }
    
    private func updateBillReminderItem() {
        if let index = settings.firstIndex(where: { section in
            section.section == "Notification"
        }){
            var s =  settings[index].items[0]
            s.id = UUID().uuidString
            s.actionInformation = "\(actionWordForBillReminder) receiving bill reminders"
            s.isToggled = optInForBillReminder
            settings[index].items[0] = s
        }
    }
    private func updateCampaignMessageItem() {
        if let index = settings.firstIndex(where: { section in
            section.section == "Notification"
        }){
            var s =  settings[index].items[1]
            s.id = UUID().uuidString
            s.actionInformation = "\(actionWordForCampaignMessage) receiving campaign messages"
            s.isToggled = optInForCampaignMessage
            settings[index].items[1] = s
        }
    }
}

struct SettingsSectionItemView: View {
    @Binding var section: SettingsSectionItem
    var delegate: OnSettingClick
    var body: some View {
        VStack(alignment: .leading) {
            Section(section.section) {
                ForEach($section.items, id: \.id) { item in
                    SettingsItemView(item: item, delegate: delegate)
                        .listRowSeparator(.hidden)
                }
            }.foregroundmode(color: .green)
        }
    }
}

struct SettingsItemView : View {
    @Binding var item: SettingsItem
    var delegate: OnSettingClick
    @State private var showActionInformation = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(item.main)
                    .font(.subheadline)
                    .foregroundmode(color: item.isActive ? .black : .gray)
                    
                Toggle("", isOn: $item.isToggled)
                    .showIf($item.showBoolItem)
            }
            Text(item.actionInformation)
                .font(.caption)
                .foregroundmode(color: .gray)
                .showIf($showActionInformation)
        }
        .padding(.vertical, 10)
        .onAppear {
            showActionInformation = item.actionInformation.isNotEmpty
        }
        .onTapGesture {
            if item.isActive {
                delegate.onItemClick(item)
            }
        }
        .onChange(of: item.isToggled) { newValue in
            delegate.onToggle(&item)
        }
    }
}

struct SettingsSectionItem: Identifiable {
    let section: String
    var items: [SettingsItem]
    var id: String {
        section
    }
    static var GENERAL = "General"
    static var NOTIFICATION = "Notification"
    static var TINGPIN = "Ting PIN setting"
    static var ACCOUNT = "Account"
}
struct SettingsItem: Identifiable {
    var main: String = "Main"
    var actionInformation: String = ""
    var showBoolItem: Bool = false
    var isToggled: Bool = false
    var id: String =  UUID().uuidString
    var isActive = true
    
    static var CARD = "Cards"
    static var MOBILENETWORK = "Mobile Network"
    static var SETPIN = "Set PIN"
    static var CHANGEPIN = "Change PIN"
    static var REMOVEPIN = "Remove PIN"
    static var SECURITYLEVEL = "Security level"
    static var BILLREMINDER = "Bill reminder"
    static var CAMPAIGNMESSAGE = "Campaign messages"
    static var DEACTIVATEACCOUNT = "Deactivate account"
}

protocol OnSettingClick {
    func onItemClick(_ item: SettingsItem)
    func onToggle(_ item: inout SettingsItem)
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(NavigationManager())
    }
}


