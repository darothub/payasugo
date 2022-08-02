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
    @State var listOfServices = [MerchantService]()
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Text("Quick Top up")
                    .font(.system(size: PrimaryTheme.mediumTextSize))
                Text("Recharge or pay instantly")
                    .font(.system(size: PrimaryTheme.smallTextSize))
                ScrollView(.horizontal, showsIndicators: false){
                    HStack {
                        ForEach(listOfServices, id: \.id) { service in
                            QuickTopupCard(imageUrl: service.serviceLogo!)
                                .padding(.vertical)
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .shadow(radius: 3, x: 0, y: 3)
            )
        }
    }
}

struct QuickTopupView_Previews: PreviewProvider {
    static var previews: some View {
        QuickTopupView(listOfServices: services)
    }
}

var services: [MerchantService] {
    [MerchantService(), MerchantService(), MerchantService()]
}
