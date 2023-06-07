//
//  DialogContentView.swift
//  
//
//  Created by Abdulrasaq on 09/05/2023.
//

import Foundation
import SwiftUI
public struct DialogContentView: View {
    @State var networkList: [NetworkItem] = [
        NetworkItem(imageUrl: "", networkName: "Airtel", selectedNetwork: "Airtel")
    ]
    @State var phoneNumber: String = "090000000000"
    @State var selectedNetwork: String = "MTN"
    @State private var buttonLabel: String = "Done"
    @State private var isNetworkListEmpty = false
    var listener: OnNetweorkSelectionListener
    public init(networkList: [NetworkItem], phoneNumber: String = "090000000000", selectedNetwork: String = "MTN", listener: OnNetweorkSelectionListener) {
        self._networkList = State(initialValue: networkList)
        self._phoneNumber = State(initialValue: phoneNumber)
        self._selectedNetwork = State(initialValue: selectedNetwork)
        self.listener = listener
    }
    public var body: some View {
        VStack {
            Text("Select mobile network")
            Group {
                Text("Please select the mobile network that\n")
                    .foregroundColor(.black)
                + Text("\(phoneNumber)").foregroundColor(.green)
                + Text(" belongs to")
                    .foregroundColor(.black)
            }
            .multilineTextAlignment(.center)
            .font(.caption)
            Divider()
            List {
                ForEach(networkList) { network  in
                    NetworkSelectionRowView(item: network, selectedNetwork: $selectedNetwork)
                        .listRowInsets(EdgeInsets())
                        .showIfNot(.constant(network.networkName.isEmpty))
                }
            }
            .listStyle(PlainListStyle())
            .background(Color.white)
            .scrollContentBackground(.hidden)
            Text("You have no service yet")
                .showIf($isNetworkListEmpty)
            TinggButton(
                backgroundColor: .green,
                buttonLabel: buttonLabel
            ) {
                if networkList.isEmpty {
                    listener.onDismiss()
                } else {
                    listener.onServiceSubmission(selected: selectedNetwork)
                }
            }
        }
        .background(.white)
        .onAppear {
            buttonLabel = networkList.isEmpty ? "Dismiss" : buttonLabel
            isNetworkListEmpty = networkList.isEmpty
        }
    }
}

public struct NetworkSelectionRowView: View {
    @State var item: NetworkItem = .init()
    @Binding var selectedNetwork: String
    public init(item: NetworkItem, selectedNetwork: Binding<String>) {
        self._item = State(initialValue: item)
        self._selectedNetwork = selectedNetwork
    }
    public var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: item.imageUrl)) { image in
                    image.resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding()
                } placeholder: {
                    ProgressView()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding()
                }
                Text(item.networkName)
                    .foregroundColor(.black)
                Spacer()
                RadioButtonView(selected: $selectedNetwork, id: item.id)
            }.background(.white)
            Divider()
        }.background(.white)
    }
}

public struct NetworkItem: Identifiable {
    public var id: String {
        networkName
    }
    public var imageUrl: String = "https://1000logos.net/wp-content/uploads/2018/01/Airtel-Logo.png"
    public var networkName: String = ""
    public var selectedNetwork: String = ""
    public init(
        imageUrl: String = "https://1000logos.net/wp-content/uploads/2018/01/Airtel-Logo.png",
        networkName: String = "",
        selectedNetwork: String = ""
    ) {
        self.imageUrl = imageUrl
        self.networkName = networkName
        self.selectedNetwork = selectedNetwork
    }
}

public protocol OnNetweorkSelectionListener {
    func onServiceSubmission(selected: String)
    func onDismiss()
}
