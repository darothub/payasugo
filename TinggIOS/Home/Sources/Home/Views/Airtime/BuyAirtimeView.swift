//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 27/09/2022.
//
import Common
import Core
import SwiftUI
import Theme

struct BuyAirtimeView: View {
    @AppStorage(Utils.defaultNetworkServiceId) var defaultNetworkServiceId: String?
    @State var showDialog = false
    var body: some View {
        VStack {
            Text("Buy Airtime")
        }
        .onAppear {
            print("DefaultNetWork \(defaultNetworkServiceId)")
            showDialog = defaultNetworkServiceId != nil
        }
        .customDialog(isPresented: $showDialog) {
            Text("Dialog here")
        }
    }
}

struct DialogContentView: View {
    var phoneNumber: String = "080"
    var body: some View {
        VStack {
            Text("Select mobile network")
            Text("Please select the mobile network that \(phoneNumber) belongs to")
            Divider()
        }
    }
}
enum Choice {
    case one, two, three
}
struct NetworkRowView: View {
    @State var imageUrl: String = ""
    @State var networkName: String = "Airtel"
    @State var selected = true
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding()
            } placeholder: {
                PrimaryTheme.getImage(image: .tinggIcon)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding()
            }
            Text(networkName)
            Picker(selection: $selected, label: Text("Select an option:")) {
                     Text("One").tag(Choice.one)
                     Text("Two").tag(Choice.two)
                     Text("Three").tag(Choice.three)
                 }
        }
    }
}

struct BuyAirtimeView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkRowView()
    }
}
