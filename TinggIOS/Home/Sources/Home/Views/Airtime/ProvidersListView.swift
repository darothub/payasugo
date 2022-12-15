//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 14/12/2022.
//

import SwiftUI
import Core
struct ProvidersListView: View {
    @Binding var plm: ProvidersListModel
    let gridColumn = [
        GridItem(.adaptive(minimum: 110))
    ]
    var onChangeSelection: () -> Void
    var body: some View {
        VStack(alignment: .leading) {
            Text(plm.selectPaymentTitle)
                .font(.body)
                .padding(.top, 30)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(plm.details, id: \.self) { detail in
                        RectangleImageCardView(imageUrl: detail.service.serviceLogo, tag: detail.service.serviceName, selected: $plm.selectedProvider) {
                            onChangeSelection()
                            }
                            .overlay(alignment: .topTrailing) {
                                if plm.selectedProvider == detail.service.serviceName {
                                    onDefaultNetworkDetected(detail: detail)
                                }
                            }
                    }
                }
            }.showIf(.constant(plm.orientation == .horizontal))
            LazyVGrid(columns: gridColumn, spacing: 5){
                ForEach(plm.details, id: \.self) { detail in
                    RectangleImageCardView(imageUrl: detail.service.serviceLogo, tag: detail.service.serviceName, selected: $plm.selectedProvider) {
                        onChangeSelection()
                        }
                        .overlay(alignment: .topTrailing) {
                            if plm.selectedProvider == detail.service.serviceName {
                                onDefaultNetworkDetected(detail: detail)
                            }
                        }
                }
            }.showIf(.constant(plm.orientation == .grid))
        }
        .frame(maxWidth: .infinity)
        .background(.white)
    }
    func onDefaultNetworkDetected(detail: ProviderDetails) -> some View  {
        return NetworkFavouritedMarkedView().onAppear {
//            plm.selectedProvider = detail.name
            plm.canOthersPay = detail.othersCanPay
        }
    }
}

struct ProvidersListView_Previews: PreviewProvider {
    struct ProvidersListViewPreviewHolder: View {
        @State var details: [ProviderDetails] = [
            ProviderDetails(service: sampleServices[0]),
            ProviderDetails(service: sampleServices[1]),
            ProviderDetails(service: sampleServices[2]),
        ]
        var body: some View {
            ProvidersListView(plm: .constant(.init())){}
        }
    }
    static var previews: some View {
        ProvidersListViewPreviewHolder()
    }
}


public struct ProviderDetails: Hashable {
    public var service: MerchantService
    public var payer: MerchantPayer
    public var othersCanPay: Bool
    public var accountNumber: String
    public var uniqueAmount: [String]
    
    init(service: MerchantService  = sampleServices[0], payer: MerchantPayer = .init(), othersCanPay: Bool = false, accountNumber: String = "", uniqueAmount: [String] = .init()) {
        self.service = service
        self.payer = payer
        self.othersCanPay = othersCanPay
        self.accountNumber = accountNumber
        self.uniqueAmount = uniqueAmount
    }
 
}

public enum ListOrientation : Hashable, Equatable{
    case horizontal
    case grid
}
