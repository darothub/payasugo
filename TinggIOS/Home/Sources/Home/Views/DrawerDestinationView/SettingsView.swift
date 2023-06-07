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
struct SettingsView: View, OnSettingClick, OnNetweorkSelectionListener {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var hvm = HomeDI.createHomeViewModel()
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
    private var actionWordForBillReminder: String {
        optInForBillReminder ? "Disable" : "Enable"
    }
    private var actionWordForCampaignMessage: String {
        optInForCampaignMessage ? "Disable" : "Enable"
    }
    var body: some View {
        VStack {
            List {
                ForEach(settings) { setting in
                    SettingsSectionItemView(section: setting, delegate: self)
                        .listRowBackground(colorScheme == .dark ? Color.white : Color.white)
                }
            }
            .backgroundmode(color: .gray.opacity(0.1))
            .scrollContentBackground(.hidden)
        }
        .backgroundmode(color: .white)
        .onAppear {
            let allSettings = [
                SettingsSectionItem(section: SettingsSectionItem.GENERAL, items: [
                    SettingsItem(main: SettingsItem.CARD, actionInformation: "Add or Delete card"),
                    SettingsItem(main: SettingsItem.MOBILENETWORK, actionInformation: "Choose your main mobile network")
                ]),
                SettingsSectionItem(section: SettingsSectionItem.TINGPIN , items: [
                    SettingsItem(main: SettingsItem.SETPIN, actionInformation: ""),
                    SettingsItem(main: SettingsItem.CHANGEPIN, actionInformation: ""),
                    SettingsItem(main: SettingsItem.REMOVEPIN, actionInformation: ""),
                    SettingsItem(main: SettingsItem.SECURITYLEVEL, actionInformation: "Ask for PIN everytime I open the app")
                ]),
                SettingsSectionItem(section: SettingsSectionItem.NOTIFICATION, items: [
                    SettingsItem(main: SettingsItem.BILLREMINDER, actionInformation: "\(actionWordForBillReminder) receiving bill reminders", showBoolItem: true, isToggled: optInForBillReminder),
                    SettingsItem(main: SettingsItem.CAMPAIGNMESSAGE, actionInformation: "\(actionWordForCampaignMessage) receiving campaign messages", showBoolItem: true, isToggled: optInForCampaignMessage)
                ]),
                SettingsSectionItem(section: SettingsSectionItem.ACCOUNT, items: [
                    SettingsItem(main: SettingsItem.DEACTIVATEACCOUNT, actionInformation: "")
                ])
            ]
            settings.append(contentsOf: allSettings)
            phoneNumber = AppStorageManager.getPhoneNumber()
            defaultService = AppStorageManager.getDefaultNetwork() ?? .init()
            defaultServiceName = defaultService.serviceName
        }
        .customDialog(isPresented: $showNetworkList, cancelOnTouchOutside: .constant(true)) {
            DialogContentView(networkList: networkList, phoneNumber: phoneNumber, selectedNetwork: defaultServiceName, listener: self)
                .padding()
        }
        
        .handleViewStatesMods(uiState: hvm.$billReminderUIModel) { content in
            let dto = content.data as! BaseDTO
            updateStorageBillReminderContent(dto: dto)
        } action: {
            updateBillReminderItem()
        }
        .handleViewStatesMods(uiState: hvm.$campaignMessageUIModel) { content in
            let dto = content.data as! BaseDTO
            updateStorageCampaignMessageContent(dto: dto)
        } action: {
            updateCampaignMessageItem()
        }
        .handleViewStatesMods(uiState: hvm.$defaultNetworkUIModel) { content in
            log(message: content)
        } action: {
            dismissDialogView()
        }

    }
    func dismissDialogView() {
        showNetworkList = false
    }
    func onItemClick(_ item: SettingsItem) {
        switch item.main {
        case SettingsItem.MOBILENETWORK:
            showNetworks()
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
    var section: SettingsSectionItem = SettingsSectionItem(section: SettingsSectionItem.GENERAL, items: [
        SettingsItem(main: SettingsItem.CARD, actionInformation: "Add or Delete card"),
        SettingsItem(main: SettingsItem.MOBILENETWORK, actionInformation: "Choose your main mobile network")
    ])
    var delegate: OnSettingClick
    var body: some View {
        VStack(alignment: .leading) {
            Section(section.section) {
                ForEach(section.items) { item in
                    SettingsItemView(item: item, delegate: delegate)
                        .listRowSeparator(.hidden)
                }
            }.foregroundmode(color: .green)
        }
    }
}

struct SettingsItemView : View {
    @State var item: SettingsItem = SettingsItem()
    var delegate: OnSettingClick
    @State private var showActionInformation = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(item.main)
                    .font(.headline)
                    .foregroundmode(color: .black)
                Toggle("", isOn: $item.isToggled)
                    .showIf($item.showBoolItem)
            }
            Text(item.actionInformation)
                .font(.caption)
                .foregroundmode(color: .gray)
                .showIf($showActionInformation)
        }
        .padding(.vertical)
        .onAppear {
            showActionInformation = item.actionInformation.isNotEmpty
        }
        .onTapGesture {
            delegate.onItemClick(item)
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
        
    }
}


