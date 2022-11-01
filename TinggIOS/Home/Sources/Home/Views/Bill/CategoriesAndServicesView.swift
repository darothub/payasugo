//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 14/09/2022.
//
import Core
import SwiftUI
import Theme

struct CategoriesAndServicesView: View {
    @State var searchText = ""
    @State var searching = false
    @StateObject var homeViewModel = HomeDI.createHomeViewModel()
    @State var allRechargesData: [RechargeItem] = [RechargeItem]()
    @State var searchResult : [RechargeItem] = [RechargeItem]()
    fileprivate func searchService(_ newValue: String) -> [RechargeItem] {
        return allRechargesData
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
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack (alignment: .leading) {
                Text("Add new bill")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
                SearchSection(searchText: $searchText)
                    .padding()
                    .onChange(of: searchText, perform: onSearch(text:))
                ForEach(searching ? searchResult : allRechargesData, id: \.title) { item in
                    RowView(title: item.title, itemList: item.services)
                }
            }
        }.onAppear {
            let dict = homeViewModel.allRechargePublisher
            allRechargesData = dict.keys
                .sorted(by: <)
                .map{RechargeItem(title: $0, services: dict[$0]!)}
        }
        .background(.gray.opacity(0.1))
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
struct RowView: View {
    @State var title = "Title"
    @State var itemList = [MerchantService]()
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: PrimaryTheme.mediumTextSize))
                .foregroundColor(.black)
                .textCase(.uppercase)
            RowBody(services: itemList)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.white)
                .shadow(radius: 3, x: 0, y: 3)
        )
    }
}

struct RowBody: View {
    @State var services = [MerchantService]()
    let gridColumn = [
        GridItem(.adaptive(minimum: 90))
    ]
    var body: some View {
        LazyVGrid(columns: gridColumn, spacing: 0){
            ForEach(services, id: \.serviceName) { item in
                if let name = item.serviceName, let logo = item.serviceLogo {
                    Item(name: name, logo: logo)
                }
            }
        }
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
    static var previews: some View {
        CategoriesAndServicesView()
    }
}

struct RechargeItem {
    let title:String
    let services: [MerchantService]
}
