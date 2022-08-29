//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 30/07/2022.
//

import SwiftUI
import Theme
import Core
struct QuickTopupView: View {
//    @EnvironmentObject var hvm: HomeViewModel
    var airtimeServices = [MerchantService]()
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Quick Top up")
                    .font(.system(size: PrimaryTheme.mediumTextSize))
                    .foregroundColor(.black)
                Text("Recharge or pay instantly")
                    .font(.system(size: PrimaryTheme.smallTextSize))
                    .foregroundColor(.black)
                quickTopViewBody(airtimeServices: airtimeServices)
               
            }
            .padding()
        }
    }
    @ViewBuilder
    fileprivate func quickTopViewBody(airtimeServices: [MerchantService]) -> some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(airtimeServices, id: \.id) { service in
                    RemoteImageCard(imageUrl: service.serviceLogo!)
                        .padding(.vertical)
                }
            }

        }
    }
}

struct QuickTopupView_Previews: PreviewProvider {
    static var previews: some View {
        QuickTopupView(airtimeServices: services)
    }
}

var services: [MerchantService] {
    [MerchantService(), MerchantService(), MerchantService()]
}
