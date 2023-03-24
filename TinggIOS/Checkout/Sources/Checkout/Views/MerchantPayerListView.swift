//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 15/01/2023.
//
import CoreUI
import Core
import SwiftUI

public struct MerchantPayerListView: View {
    @Binding var slm: ServicesListModel
    let gridColumn = [
        GridItem(.adaptive(minimum: 110))
    ]
    var onChangeSelection: () -> Void
    public init(slm: Binding<ServicesListModel>, onChangeSelection: @escaping () -> Void) {
        self._slm = slm
        self.onChangeSelection = onChangeSelection
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Text(slm.selectPaymentTitle)
                .font(.body)
                .padding(.top, 30)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(slm.payers, id: \.self) { payer in
                        RectangleImageCardView(imageUrl: payer.logo!, tag: payer.clientName!, selected: $slm.selectedProvider) {
                            onChangeSelection()
                            }
                            .overlay(alignment: .topTrailing) {
                                if slm.selectedProvider == payer.clientName {
                                    NetworkFavouritedMarkedView()
                                }
                            }
                    }
                }
            }.showIf(.constant(slm.orientation == .horizontal))
            LazyVGrid(columns: gridColumn, spacing: 5){
                ForEach(slm.payers, id: \.self) { payer in
                    RectangleImageCardView(imageUrl: payer.logo!, tag: payer.clientName!, selected: $slm.selectedProvider) {
                        onChangeSelection()
                        }
                        .overlay(alignment: .topTrailing) {
                            if slm.selectedProvider == payer.clientName {
                                NetworkFavouritedMarkedView()
                            }
                        }
                }
            }.showIf(.constant(slm.orientation == .grid))
        }
        .frame(maxWidth: .infinity)
        .background(.white)
    }
}
