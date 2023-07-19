//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 30/07/2022.
//
import Checkout
import Permissions
import CoreNavigation
import SwiftUI
import Theme
import Core
import CoreUI
public struct QuickTopupView: View {
    @StateObject private var airtimeViewModel: BuyAirtimeViewModel = AirtimeDI.createBuyAirtimeVM()
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var contactViewModel: ContactViewModel
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    @State private var airtimeServices = sampleServices
    @State private var show = true
    @State private var isLoading = false
 
    public init() {
       //
    }
    public var body: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Quick Top up")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .bold()
                Text("Recharge or pay instantly")
                    .font(.caption2)
                    .foregroundColor(.black)
                quickTopViewBody(airtimeServices: airtimeServices)
               
            }
            
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation {
                airtimeServices = airtimeViewModel.getQuickTopups()
                show = airtimeServices.isNotEmpty()
            }
        }
        .backgroundmode(color: .white)
        .padding()
        .shadowBackground()
        .showIf($show)
    }
    @ViewBuilder
    fileprivate func quickTopViewBody(airtimeServices: [MerchantService]) -> some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(airtimeServices, id: \.id) { service in
                    IconImageCardView(imageUrl: service.serviceLogo, bgShape: .rectangular)
                        .padding(.vertical)
                        .onTapGesture {
                            navigation.navigateTo(screen: BuyAirtimeScreen.buyAirtime(service.serviceName))
                        }
                }
            }    .padding(5)

        }
    }
}

protocol OnQuickTopClick {
    func onItemClick(service: MerchantService)
}
struct QuickTopupView_Previews: PreviewProvider {
    struct QuickTopupViewPreview: View, OnQuickTopClick{
        func onItemClick(service: Core.MerchantService) {
            //TODO
        }
        
        var body: some View {
            QuickTopupView()
        }
    }
    static var previews: some View {
        QuickTopupViewPreview()
            .environmentObject(CheckoutDI.createCheckoutViewModel())
            .environmentObject(ContactViewModel())
            .environmentObject(NavigationManager())
    }
}

