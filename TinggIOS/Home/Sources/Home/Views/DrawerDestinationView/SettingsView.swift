//
//  SettingsView.swift
//  
//
//  Created by Abdulrasaq on 02/05/2023.
//

import SwiftUI

struct SettingsView: View, OnSettingClick {
    @State var settings: [SettingsSectionItem] = []
    var body: some View {
        VStack {
            List {
                ForEach(settings) { setting in
                    SettingsSectionItemView(section: setting, delegate: self)
                }
            }
        }.onAppear {
            settings = [
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
                    SettingsItem(main: "Bill reminder", actionInformation: "Disable receiving bill reminders", showBoolItem: true, isToggled: true),
                    SettingsItem(main: "Campaign messages", actionInformation: "Disable receiving campaign messages", showBoolItem: true, isToggled: true)
                ]),
                SettingsSectionItem(section: "Account", items: [
                    SettingsItem(main: "Deactivate account", actionInformation: "")
                ])
            ]
        }
    }
    func onItemClick(_ item: SettingsItem) {
        log(message: item)
    }
    func onToggle(_ item: inout SettingsItem) {
        if item.actionInformation.contains("Disable") {
            item.actionInformation = item.actionInformation.replacingOccurrences(of: "Disable", with: "Enable")
        } else {
            item.actionInformation = item.actionInformation.replacingOccurrences(of: "Enable", with: "Disable")
        }
        log(message: item)
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
    let items: [SettingsItem]
    var id: String {
        section
    }
}
struct SettingsItem: Identifiable {
    var main: String = "Main"
    var actionInformation: String = ""
    var showBoolItem: Bool = false
    var isToggled: Bool = false
    var id: String {
        main
    }
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

