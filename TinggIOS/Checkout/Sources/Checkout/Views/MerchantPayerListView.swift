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
                horizontallistView()
            }.showIf(.constant(slm.orientation == .horizontal))
            gridView()
        }
        .frame(maxWidth: .infinity)
        .background(.white)
    }
    @ViewBuilder
    fileprivate func horizontallistView() -> some View {
        HStack {
          listView()
        }
    }
    @ViewBuilder
    fileprivate func gridView() -> some View {
        LazyVGrid(columns: gridColumn, spacing: 5){
           listView()
        }.showIf(.constant(slm.orientation == .grid))
    }
    @ViewBuilder
    fileprivate func listView() -> some View {
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
}
