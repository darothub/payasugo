//
//  SupportView.swift
//  
//
//  Created by Abdulrasaq on 03/05/2023.
//
import Core
import CoreUI
import SwiftUI

struct SupportView: View, OnSupportItemClick {
    @Environment(\.openURL) var openURL
    @StateObject var hvm = HomeDI.createHomeViewModel()
    @State var supportItems = [SupportItem]()
    @State var showSheet = false
    @State var supportPhoneNumber = ""
    @State var faq = ""
    var body: some View {
        List {
            ForEach(supportItems) { item in
                SupportItemView(item: item, delegate: self)
                    .listRowInsets(EdgeInsets())
            }
        }.listStyle(GroupedListStyle())
        .onAppear {
            let contact = Observer<Contact>().getEntities()
            if contact.isNotEmpty() {
                supportPhoneNumber = Observer<Contact>().getEntities()[0].phone
            }
            let callSupport = SupportItem(unit: .Call_Tingg_support, ref: supportPhoneNumber)
            let chatSupport = SupportItem(unit: .Chat_Tingg_support, ref: "")
            supportItems.append(callSupport)
            supportItems.append(chatSupport)
            if let faqUrl = AppStorageManager.getCountriesExtraInfo()?.faqURL.toString {
                let faqSupport = SupportItem(unit: .FAQ, ref: faqUrl)
                supportItems.append(faqSupport)
            }
        }
  
    }
    func onItemClick(_ item: SupportItem) {
        switch item.unit {
        case .Call_Tingg_support:
            callSupport(phoneNumber: item.ref)
        default:
            showSheet = true
        }
    }
    fileprivate func callSupport(phoneNumber: String) {
        let tel = "tel://"
        let formattedPhoneNumber = tel+phoneNumber
        guard let url = URL(string: formattedPhoneNumber) else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
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
    }
}

struct SupportItem : Identifiable {
    var unit: SupportUnit
    var id: String {
        unit.id
    }
    let ref: String
}
