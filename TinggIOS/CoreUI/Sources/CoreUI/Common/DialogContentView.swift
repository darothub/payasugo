//
//  DialogContentView.swift
//  
//
//  Created by Abdulrasaq on 09/05/2023.
//

import Foundation
import SwiftUI
public struct DialogContentView: View {
    @State var networkList: [NetworkItem] = []
    @State var phoneNumber: String = "090000000000"
    @State var selectedServiceName: String = "MTN"
    @State private var buttonLabel: String = "Done"
    @State private var isNetworkListEmpty = false
    var listener: OnDefaultServiceSelectionListener
    public init(networkList: [NetworkItem], phoneNumber: String = "090000000000", selectedServiceName: String = "MTN", listener: OnDefaultServiceSelectionListener) {
        self._networkList = State(initialValue: networkList)
        self._phoneNumber = State(initialValue: phoneNumber)
        self._selectedServiceName = State(initialValue: selectedServiceName)
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
            Text("You have no service yet")
                .showIf($isNetworkListEmpty)
            ForEach(networkList) { network in
                NetworkSelectionRowView(item: network, selectedNetwork: $selectedServiceName)
                    .listRowInsets(.none)
                    .listRowSeparator(.hidden)
                    .showIfNot(.constant(network.networkName.isEmpty))
            }
            .listStyle(PlainListStyle())
            .background(Color.white)
            .scrollContentBackground(.hidden)
            TinggButton(
                backgroundColor: .green,
                buttonLabel: buttonLabel
            ) {
                if networkList.isEmpty {
                    listener.onDismiss()
                } else {
                    listener.onSubmitDefaultService(selected: selectedServiceName)
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
        VStack(alignment: .center) {
            HStack {
                ResponsiveImageCardView(imageUrl: $item.imageUrl, y: 0, bgShape: .circular)
                Text(item.networkName)
                    .foregroundColor(.black)
                    .font(.subheadline)
                Spacer()
                RadioButtonView(selected: $selectedNetwork, id: item.id)
                    .scaleEffect(0.7, anchor: .center)
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

public protocol OnDefaultServiceSelectionListener {
    func onSubmitDefaultService(selected: String)
    func onDismiss()
}
