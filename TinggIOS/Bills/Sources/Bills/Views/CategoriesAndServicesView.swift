//
//  CategoriesAndServicesView.swift
//  
//
//  Created by Abdulrasaq on 14/09/2022.
//
import Core
import SwiftUI
import Theme
import CoreUI
import CoreNavigation
import Checkout

public struct CategoriesAndServicesView: View {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    @State private var searchText = ""
    @State private var searching = false
    @State private var searchResult : [TitleAndListItem] = [TitleAndListItem]()
    @State private var navigateToBillForm = false
    @State private var bills: BillDetails = BillDetails(service: .init(), info: .init())
    @State var categoryNameAndServices: [TitleAndListItem] = [TitleAndListItem]()
    var quickTopUpListener: ServicesListener
    public init(categoryNameAndServices: [TitleAndListItem], quickTopUpListener: ServicesListener) {
        self._categoryNameAndServices = State(initialValue: categoryNameAndServices)
        self.quickTopUpListener = quickTopUpListener
    }
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack (alignment: .leading) {
                Text("Add new bill")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
                SearchSection(searchText: $searchText)
                    .padding()
                    .onChange(of: searchText, perform: onSearch(text:))
                ColumnBody(categoryNameAndServices: $categoryNameAndServices, searchResult: $searchResult, searching: $searching, onclick: onServiceClicked(_:))
            }
        }
        .background(.white.opacity(0.9))
        .navigationBarBackButton(navigation: navigation)
        

    }
    fileprivate func searchService(_ newValue: String) -> [TitleAndListItem] {
        return categoryNameAndServices
            .filter({ rechargeItem in
                let items = rechargeItem.services.contains { service in
                    service.serviceName.lowercased().contains(newValue.lowercased())
                }
                return items
            })
    }
    fileprivate func onServiceClicked(_ service: MerchantService) {
        checkoutVm.toCheckout(service) { billDetails, toCheckout in
            checkoutVm.showView = false
            if service.isABundleService {
                checkoutVm.showBundles = true
                let model = BundleModel(service: service)
                checkoutVm.bundleModel = model
                return
            }
            if service.isAirtimeService {
                quickTopUpListener.onQuicktop(serviceName: service.serviceName)
                return
            }
            navigation.navigateTo(screen: BillsScreen.fetchbillView(billDetails))
        }
    }
    fileprivate func onSearch(text: String) {
        searching = !text.isEmpty
        searchResult = searchService(text)
    }
}

struct SearchSection: View {
    @Binding var searchText:String
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading)
                    .foregroundColor(.gray)
                TextField("Search here", text: $searchText)
                    .padding([.horizontal, .vertical], 15)
                    .font(.caption)
                    .foregroundColor(.black)
                
            } .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 0.0)
            )  .background(.white)
            Image(systemName: "plus")
                .padding()
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 0.0)
                )  .background(.white)
        }
    }
}

struct ColumnBody: View {
    @Binding var categoryNameAndServices: [TitleAndListItem]
    @Binding var searchResult : [TitleAndListItem]
    @Binding var searching: Bool
    var onclick: (MerchantService) -> Void
    var body: some View {
        ForEach(searching ? searchResult : categoryNameAndServices, id: \.title) { item in
            RowView(title: .constant(item.title), itemList: .constant(item.services), onclick: onclick)
                .showIf(.constant(!item.services.isEmpty))
        }
    }
}

struct RowView: View {
    @Binding var title: String
    @Binding var itemList: [MerchantService]
    var onclick: (MerchantService) -> Void
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: PrimaryTheme.mediumTextSize))
                .foregroundColor(.black)
                .textCase(.uppercase)
            ServicesGridView(services: $itemList, showTitle: true){ service in
                onclick(service)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.white)
                .shadow(radius: 3, x: 0, y: 3)
        )
    }
}


struct Item: View {
    var name: String = ""
    var logo: String = ""
    var body: some View {
        VStack {
            IconImageCardView(imageUrl: logo, bgShape: .rectangular)
                .padding(.vertical)
            Text(name)
                .font(.caption)
                .foregroundColor(.black)
        }
    }
}

struct CategoriesAndServicesView_Previews: PreviewProvider {
    struct CategoriesAndServicesViewHolder: View, ServicesListener {
        func onQuicktop(serviceName: String) {
            //
        }
        
        @State var bill = BillDetails(service: .init(), info: .init())
        var body: some View {
            CategoriesAndServicesView(categoryNameAndServices: [TitleAndListItem](), quickTopUpListener: self)
                .environmentObject(CheckoutDI.createCheckoutViewModel())
                .environmentObject(NavigationManager.shared)
        }
    }
    static var previews: some View {
        CategoriesAndServicesViewHolder()
    }
}


