//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 14/09/2022.
//
import Core
import SwiftUI
import Theme

struct AllRechargeUIView: View {
    @State var selectedText = "Hello"
    @StateObject var homeViewModel = HomeDI.createHomeViewModel()
    var allRechargesData: [RechargeItem] {
        let dict = homeViewModel.allRechargePublisher
       return dict
            .keys
            .map{RechargeItem(title: $0, services: dict[$0]!)}
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack (alignment: .leading){
                Text("Add new bill")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
                SearchSection(selectedText: $selectedText)
                    .padding()
                ForEach(allRechargesData, id: \.title) { item in
                    RowView(title: item.title, itemList: item.services)
                }
                   
            }
        }.background(.gray.opacity(0.1))
    }
}

struct SearchSection: View {
    @Binding var selectedText:String
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading)
                TextField("placeHolder", text: $selectedText)
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
            Item(services: itemList)
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
    @State var services = [MerchantService]()
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(services, id: \.serviceName) { item in
                    RemoteImageCard(imageUrl: item.serviceLogo ?? "")
                        .padding(.vertical)
                }
            }

        }
    }
}
struct AllRechargeUIView_Previews: PreviewProvider {
    static var previews: some View {
        AllRechargeUIView()
    }
}

struct RechargeItem {
    let title:String
    let services: [MerchantService]
}
