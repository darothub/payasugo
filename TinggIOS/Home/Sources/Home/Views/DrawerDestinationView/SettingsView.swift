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
                }
            }
        }.onAppear {
            let allSettings = [
                SettingsSectionItem(section: "General", items: [
                    SettingsItem(main: "Cards", actionInformation: "Add or Delete card"),
                    SettingsItem(main: "Mobile Network", actionInformation: "Choose your main mobile network")
                ]),
                SettingsSectionItem(section: "Tingg PIN setting", items: [
                    SettingsItem(main: "Set PIN", actionInformation: ""),
                    SettingsItem(main: "Change PIN", actionInformation: ""),
                    SettingsItem(main: "Remove PIN", actionInformation: ""),
                    SettingsItem(main: "Security level", actionInformation: "Ask for PIN everytime I open the app")
                ]),
                SettingsSectionItem(section: "Notification", items: [
                    SettingsItem(main: "Bill reminder", actionInformation: "\(actionWordForBillReminder) receiving bill reminders", showBoolItem: true, isToggled: optInForBillReminder),
                    SettingsItem(main: "Campaign messages", actionInformation: "\(actionWordForCampaignMessage) receiving campaign messages", showBoolItem: true, isToggled: optInForCampaignMessage)
                ]),
                SettingsSectionItem(section: "Account", items: [
                    SettingsItem(main: "Deactivate account", actionInformation: "")
                ])
            ]
            settings.append(contentsOf: allSettings)
            phoneNumber = AppStorageManager.getPhoneNumber()
            defaultService = AppStorageManager.getDefaultNetwork() ?? .init()
            defaultServiceName = defaultService.serviceName
        }
        .customDialog(isPresented: $showNetworkList, cancelOnTouchOutside: .constant(true)) {
            DialogContentView(networkList: networkList, phoneNumber: phoneNumber, selectedNetwork: defaultServiceName, listner: self)
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
            showNetworkList = false
        }

    }
    func dismissDialogView() {
        showNetworkList = false
    }
    func onItemClick(_ item: SettingsItem) {
        switch item.main {
        case "Mobile Network":
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
    func onSubmit(selected: String) {
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
        //
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
    var section: SettingsSectionItem = SettingsSectionItem(section: "General", items: [
        SettingsItem(main: "Cards", actionInformation: "Add or Delete card"),
        SettingsItem(main: "Mobile Network", actionInformation: "Choose your main mobile network")
    ])
    var delegate: OnSettingClick
    var body: some View {
        VStack(alignment: .leading) {
            Section(section.section) {
                ForEach(section.items) { item in
                    SettingsItemView(item: item, delegate: delegate)
                        .listRowSeparator(.hidden)
                }
            }
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
                Toggle("", isOn: $item.isToggled)
                    .showIf($item.showBoolItem)
            }
            Text(item.actionInformation)
                .font(.caption)
                .foregroundColor(.gray)
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
}
struct SettingsItem: Identifiable {
    var main: String = "Main"
    var actionInformation: String = ""
    var showBoolItem: Bool = false
    var isToggled: Bool = false
    var id: String =  UUID().uuidString
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

struct DialogContentView: View {
    @State var networkList: [NetworkItem] = [
        NetworkItem(imageUrl: "", networkName: "Airtel", selectedNetwork: "Airtel")
    ]
    @State var phoneNumber: String = "090000000000"
    @State var selectedNetwork: String = "MTN"
    var listner: OnNetweorkSelectionListener
    var body: some View {
        VStack {
            Text("Select mobile network")
            Group {
                Text("Please select the mobile network that")
                + Text(" \(phoneNumber)").foregroundColor(.green)
                + Text(" belongs to")
            }.multilineTextAlignment(.center)
                .font(.caption)
            Divider()
            ForEach(networkList) { network  in
                NetworkSelectionRowView(item: network, selectedNetwork: $selectedNetwork)
                    .listRowInsets(EdgeInsets())
                    .showIfNot(.constant(network.networkName.isEmpty))
            }
            Text("No network available")
                .showIf(.constant(networkList.isEmpty))
            TinggButton(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Done"
            ) {
                listner.onSubmit(selected: selectedNetwork)
            }
        }
    }
}

struct NetworkSelectionRowView: View {
    @State var item: NetworkItem = .init()
    @Binding var selectedNetwork: String
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: item.imageUrl)) { image in
                    image.resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding()
                } placeholder: {
                    Image(systemName: "camera.fill")
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding()
                }
                Text(item.networkName)
                Spacer()
                RadioButtonView(selected: $selectedNetwork, id: item.id)
            }
            Divider()
        }
    }
}

struct NetworkItem: Identifiable {
    var id: String {
        networkName
    }
    var imageUrl: String = "https://1000logos.net/wp-content/uploads/2018/01/Airtel-Logo.png"
    var networkName: String = ""
    var selectedNetwork: String = ""
}

protocol OnNetweorkSelectionListener {
    func onSubmit(selected: String)
    func onDismiss()
}


