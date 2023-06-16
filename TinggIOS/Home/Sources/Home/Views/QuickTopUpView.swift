//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 30/07/2022.
//

import SwiftUI
import Theme
import Core
import CoreUI
struct QuickTopupView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State var airtimeServices = [MerchantService]()
    @State var show = true
    var onclick: (MerchantService) -> Void
    var body: some View {
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
        .showIf($show)
        .backgroundmode(color: .white)
        .onAppear {
            homeViewModel.getQuickTopups()
        }
        .handleViewStatesMods(uiState: homeViewModel.$quickTopUIModel) { content in
            let services = content.data as? [MerchantService]
            withAnimation {
                airtimeServices = services ?? []
                show = airtimeServices.isNotEmpty()
            }
          
        }
    }
    @ViewBuilder
    fileprivate func quickTopViewBody(airtimeServices: [MerchantService]) -> some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(airtimeServices, id: \.id) { service in
                    IconImageCardView(imageUrl: service.serviceLogo, bgShape: .rectangular)
                        .padding(.vertical)
                        .onTapGesture {
                            onclick(service)
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
            QuickTopupView(airtimeServices: sampleServices) { s in
                //TODO
            }
        }
    }
    static var previews: some View {
        QuickTopupViewPreview()
            .environmentObject(HomeDI.createHomeViewModel())
    }
}

