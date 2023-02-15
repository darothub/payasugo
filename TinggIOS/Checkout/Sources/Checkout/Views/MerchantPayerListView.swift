//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 15/01/2023.
//
import Common
import Core
import SwiftUI

public struct MerchantPayerListView: View {
    @Binding var plm: ProvidersListModel
    let gridColumn = [
        GridItem(.adaptive(minimum: 110))
    ]
    var onChangeSelection: () -> Void
    public init(plm: Binding<ProvidersListModel>, onChangeSelection: @escaping () -> Void) {
        self._plm = plm
        self.onChangeSelection = onChangeSelection
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Text(plm.selectPaymentTitle)
                .font(.body)
                .padding(.top, 30)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(plm.details, id: \.self) { detail in
                        RectangleImageCardView(imageUrl: detail.payer.logo!, tag: detail.payer.clientName!, selected: $plm.selectedProvider) {
                            onChangeSelection()
                            }
                            .overlay(alignment: .topTrailing) {
                                if plm.selectedProvider == detail.payer.clientName {
                                    onDefaultNetworkDetected(detail: detail)
                                }
                            }
                    }
                }
            }.showIf(.constant(plm.orientation == .horizontal))
            LazyVGrid(columns: gridColumn, spacing: 5){
                ForEach(plm.details, id: \.self) { detail in
                    RectangleImageCardView(imageUrl: detail.payer.logo!, tag: detail.payer.clientName!, selected: $plm.selectedProvider) {
                        onChangeSelection()
                        }
                        .overlay(alignment: .topTrailing) {
                            if plm.selectedProvider == detail.payer.clientName {
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
        return NetworkFavouritedMarkedView().body.onAppear {
            plm.canOthersPay = detail.othersCanPay
        }
    }
}
