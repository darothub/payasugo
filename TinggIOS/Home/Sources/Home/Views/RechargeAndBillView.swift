//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 15/08/2022.
//

import SwiftUI
import Theme
import Core
struct RechargeAndBillView: View {
    @EnvironmentObject var hvm: HomeViewModel
    let gridColumn = [
        GridItem(.adaptive(minimum: 90))
    ]
    var body: some View {
        Section {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Recharge & Bill payment")
                            .font(.system(size: PrimaryTheme.mediumTextSize))
                        Text("Recharge or pay for")
                            .font(.system(size: PrimaryTheme.smallTextSize))
                        Spacer()
                    }
                    Spacer()
                    Group {
                        Text("See all")
                            .font(.system(size: PrimaryTheme.smallTextSize))
                        Image(systemName: "chevron.right")
                    }
                }
                LazyVGrid(columns: gridColumn, spacing: 0){
                    ForEach(hvm.rechargeAndBill, id: \.id) { service in
                        RemoteImageCard(imageUrl: service.serviceLogo!)
                            .padding(.vertical)
                            .animation(.easeInOut, value: service.id)
                    }
                }
                
            }
        }.padding()
    }
}

struct RechargeAndBillView_Previews: PreviewProvider {
    static var previews: some View {
        RechargeAndBillView()
            .environmentObject(HomeDI.createHomeViewModel())
    }
}
