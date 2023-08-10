//
//  MerchantPayerListView.swift
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
    var onClick: () -> Void
    public init(slm: Binding<ServicesListModel>, onClick: @escaping () -> Void) {
        self._slm = slm
        self.onClick = onClick
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Text(slm.title)
                .font(.body)
                .padding(.top, 30)
                .foregroundColor(.black)
            ScrollView(.horizontal, showsIndicators: false) {
                horizontallistView()
            }.showIf(.constant(slm.orientation == .horizontal))
            gridView()
        }
        .frame(maxWidth: .infinity)
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
        ForEach(slm.serviceModels, id: \.logoUrl) { payer in
            let size = CGSize(width: 70, height: 55)
            RectangleImageCardView(size: size, imageUrl: payer.logoUrl, tag: payer.name, selected: $slm.selectedProvider, onClick: onClick)
                .overlay(alignment: .topTrailing) {
                    if slm.selectedProvider == payer.name {
                        NetworkFavouritedMarkedView()
                    }
                }
        }
    }
}

struct MerchantPayerListView_Previews: PreviewProvider {
    static var previews: some View {
        MerchantPayerListView(slm: .constant(.init())) {
            //
        }
    }
}
