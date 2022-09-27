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
    @State var selectedButton:String = ""
    @State var phoneNumber = "080600885192"
    @StateObject var hvm = HomeDI.createHomeViewModel()
    var services: [MerchantService] {
        let service1 = MerchantService()
        service1.serviceName = "Airtel"
        let service2 = MerchantService()
        service2.serviceName = "Safaricom"
        return [service1, service2]
    }
    var body: some View {
        VStack {
            Text("Buy Airtime")
        }
        .onAppear {
            print("DefaultNetWork \(defaultNetworkServiceId)")
            hvm.showNetworkList = defaultNetworkServiceId != nil
        }
        .customDialog(isPresented: $hvm.showNetworkList) {
            DialogContentView(
                phoneNumber: phoneNumber,
                airtimeServices: hvm.airTimeServices,
                selectedButton: $selectedButton
            )
            .padding(20)
            .environmentObject(hvm)
        }
    }
}

struct DialogContentView: View {
    var phoneNumber: String = "080"
    var airtimeServices = [MerchantService]()
    @State var imageUrl: String = ""
    @Binding var selectedButton:String
    @EnvironmentObject var hvm: HomeViewModel
    var body: some View {
        VStack {
            Text("Select mobile network")
            Group {
                Text("Please select the mobile network that")
                + Text(" \(phoneNumber)").foregroundColor(.green)
                + Text(" belongs to")
            }.multilineTextAlignment(.center)
                .font(.caption)
            Divider()
            ForEach(airtimeServices, id: \.serviceName) { service in
                NetworkSelectionRowView(
                    imageUrl: service.serviceLogo,
                    networkName: service.serviceName,
                    selectedButton: $selectedButton
                )
            }
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Done"
            ) {
                hvm.showNetworkList = false
            }
        }
    }
}

struct NetworkSelectionRowView: View {
    @State var imageUrl: String = ""
    @State var networkName: String = "Airtel"
    @Binding var selectedButton:String
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
            Spacer()
            RadioButtonView(selected: $selectedButton, id: networkName)
        }
    }
}

struct BuyAirtimeView_Previews: PreviewProvider {
    static var previews: some View {
        BuyAirtimeView()
    }
}
