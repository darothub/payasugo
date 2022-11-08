//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 14/09/2022.
//
import Core
import SwiftUI
import Theme
import Common

public struct CategoriesAndServicesView: View {
    @State var searchText = ""
    @State var searching = false
    @State var categoryNameAndServices: [TitleAndListItem] = [TitleAndListItem]()
    @State var searchResult : [TitleAndListItem] = [TitleAndListItem]()
    @State var navigateToBillForm = false
    @State var bills: BillDetails = BillDetails(service: .init(), info: .init())
    @EnvironmentObject var hvm: HomeViewModel
    public init(categoryNameAndServices: [TitleAndListItem]) {
        self._categoryNameAndServices = State(initialValue: categoryNameAndServices)
//        self.bills = bills
       
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
                ColumnBody(categoryNameAndServices: $categoryNameAndServices, searchResult: $searchResult, searching: $searching, nominations: .constant(hvm.nominationInfo.getEntities()), bills: $bills, onclick: .constant({ service in
                    if let bills = hvm.handleServiceAndNominationFilter(service: service, nomination: hvm.nominationInfo.getEntities()) {
//                        self.bills = bills
                    }
                }))
            }
        }
        .background(.gray.opacity(0.1))
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
    @Binding var nominations: [Enrollment]
    @Binding var bills: BillDetails
    @Binding var onclick: (MerchantService) -> Void
    var body: some View {
        ForEach(searching ? searchResult : categoryNameAndServices, id: \.title) { item in
            RowView(title: .constant(item.title), itemList: .constant(item.services), onclick: $onclick)
        }
    }
}

struct RowView: View {
    @Binding var title: String
    @Binding var itemList: [MerchantService]
    @Binding var onclick: (MerchantService) -> Void
    @EnvironmentObject var hvm: HomeViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: PrimaryTheme.mediumTextSize))
                .foregroundColor(.black)
                .textCase(.uppercase)
            ServicesGridView(services: itemList, showTitle: true){ service in
                print("Service")
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
            RemoteImageCard(imageUrl: logo)
                .padding(.vertical)
            Text(name)
                .font(.caption)
                .foregroundColor(.black)
        }
    }
}

struct CategoriesAndServicesView_Previews: PreviewProvider {
    struct CategoriesAndServicesViewHolder: View {
        @State var bill = BillDetails(service: .init(), info: .init())
        var body: some View {
            CategoriesAndServicesView(categoryNameAndServices: [TitleAndListItem]())
                .environmentObject(HomeDI.createHomeViewModel())
        }
    }
    static var previews: some View {
        CategoriesAndServicesViewHolder()
            
    }
}

