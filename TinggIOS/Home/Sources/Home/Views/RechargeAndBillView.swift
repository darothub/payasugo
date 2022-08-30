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
                heading()
                viewBody()
            }
        }.padding()
    }
    @ViewBuilder
    fileprivate func heading() -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Recharge & Bill payment")
                    .font(.system(size: PrimaryTheme.mediumTextSize))
                    .foregroundColor(.black)
                Text("Recharge or pay for")
                    .font(.system(size: PrimaryTheme.smallTextSize))
                    .foregroundColor(.black)
                Spacer()
            }
            Spacer()
            Group {
                Text("See all")
                    .font(.system(size: PrimaryTheme.smallTextSize))
                    .foregroundColor(.black)
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
            }
        }
    }
    @ViewBuilder
    fileprivate func viewBody() -> some View {
        LazyVGrid(columns: gridColumn, spacing: 0){
            ForEach(hvm.rechargeAndBill, id: \.id) { service in
                RemoteImageCard(imageUrl: service.serviceLogo!)
                    .padding(.vertical)
                    .animation(.easeInOut, value: service.id)
            }
        }
    }
}

struct RechargeAndBillView_Previews: PreviewProvider {
    static var previews: some View {
        RechargeAndBillView()
            .environmentObject(HomeDI.createHomeViewModel())
    }
}
