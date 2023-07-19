//
//  SupportView.swift
//  
//
//  Created by Abdulrasaq on 03/05/2023.
//
import Core
import CoreUI
import SwiftUI
import Theme
import FreshChat
import CoreNavigation
struct SupportView: View, OnSupportItemClick {
    @Environment(\.openURL) var openURL
    @Environment(\.colorScheme) var colorScheme
    @StateObject var hvm = HomeDI.createHomeViewModel()
    @EnvironmentObject private var freshchatWrapper: FreshchatWrapper
    @EnvironmentObject var navigation: NavigationManager
  
    @State var supportItems = [SupportItem]()
    @State var showSheet = false
    @State var supportPhoneNumber = ""
    @State var faq = ""
    var body: some View {
        VStack {
            List {
                ForEach(supportItems) { item in
                    SupportItemView(item: item, delegate: self)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(colorScheme == .dark ? Color.white: Color.white)
                }
            }
            .backgroundmode(color: .gray.opacity(0.1))
            .scrollContentBackground(.hidden)
        }.backgroundmode(color: .white)
        .onAppear {
            let contact = Observer<Contact>().getEntities()
            if contact.isNotEmpty() {
                supportPhoneNumber = contact[0].phone
            }
            let callSupport = SupportItem(unit: .Call_Tingg_support, ref: supportPhoneNumber)
            let chatSupport = SupportItem(unit: .Chat_Tingg_support, ref: "")
            let faqUrl = AppStorageManager.getCountriesExtraInfo()?.faqURL.toString ?? "Empty"
            let faqSupport = SupportItem(unit: .FAQ, ref: faqUrl)
            supportItems = [callSupport, chatSupport, faqSupport]
        }
        .navigationBarBackButton(navigation: navigation)
    }
    func onItemClick(_ item: SupportItem) {
        switch item.unit {
        case .Call_Tingg_support:
            callSupport(phoneNumber: item.ref)
        case .Chat_Tingg_support :
            freshchatWrapper.showFreshchat()
        default:
            showSheet = true
        }
    }
}

struct SupportItemView: View {
    let item: SupportItem
    let delegate: OnSupportItemClick
    var body: some View {
        VStack(alignment: .center) {
            switch item.unit {
            case .FAQ:
                Text(.init("[\(item.unit.id)](\(item.ref))"))
                    .padding(.vertical)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        delegate.onItemClick(item)
                    }
            default:
                Text(item.unit.id)
                    .padding(.vertical)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        delegate.onItemClick(item)
                    }
            }
            Divider()
        }
    }
}

enum SupportUnit: String, Identifiable {
    var id: String {
        self.rawValue.replace(string: "_", replacement: " ")
    }
    case Call_Tingg_support
    case Chat_Tingg_support
    case FAQ
}

protocol OnSupportItemClick {
    func onItemClick(_ item: SupportItem)
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView()
            .environmentObject(FreshchatWrapper())
    }
}

struct SupportItem : Identifiable {
    var unit: SupportUnit
    var id: String {
        unit.id
    }
    let ref: String
}
