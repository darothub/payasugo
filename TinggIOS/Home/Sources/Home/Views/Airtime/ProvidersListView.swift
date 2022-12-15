//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 14/12/2022.
//

import SwiftUI

struct ProvidersListView: View {
    @Binding var selectedProvider: String
    @Binding var details: [ProviderDetails]
    @State var selectPaymentTitle = "Select network provider"
    @Binding var canOthersPay: Bool
    @State var orientation = ListOrientation.horizontal
    let gridColumn = [
        GridItem(.adaptive(minimum: 110))
    ]
    var onChangeSelection: () -> Void
    var body: some View {
        VStack(alignment: .leading) {
            Text(selectPaymentTitle)
                .font(.body)
                .padding(.top, 30)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(details, id: \.self) { detail in
                        RectangleImageCardView(imageUrl: detail.logo, tag: detail.name, selected: $selectedProvider) {
                            onChangeSelection()
                            }
                            .overlay(alignment: .topTrailing) {
                                if selectedProvider == detail.name {
                                    onDefaultNetworkDetected(detail: detail)
                                }
                            }
                    }
                }
            }.showIf(.constant(orientation == .horizontal))
            LazyVGrid(columns: gridColumn, spacing: 5){
                ForEach(details, id: \.self) { detail in
                    RectangleImageCardView(imageUrl: detail.logo, tag: detail.name, selected: $selectedProvider) {
                        onChangeSelection()
                        }
                        .overlay(alignment: .topTrailing) {
                            if selectedProvider == detail.name {
                                onDefaultNetworkDetected(detail: detail)
                            }
                        }
                }
            }.showIf(.constant(orientation == .grid))
        }
        .frame(maxWidth: .infinity)
        .background(.white)
    }
    func onDefaultNetworkDetected(detail: ProviderDetails) -> some View  {
        return NetworkFavouritedMarkedView().onAppear {
            selectedProvider = detail.name
            canOthersPay = detail.othersCanPay
        }
    }
}

struct ProvidersListView_Previews: PreviewProvider {
    struct ProvidersListViewPreviewHolder: View {
        @State var defaultNetworkId = ""
        @State var details: [ProviderDetails] = [
            ProviderDetails(logo: "https://play-lh.googleusercontent.com/gpVc8uC8x1M5d7Lmw0HtZIy2tF5aIWYctIQuZd406Nw8Sn7tl_MysEqEsOqHbqLvazg", name: "Quick"),
            ProviderDetails(logo: "https://play-lh.googleusercontent.com/gpVc8uC8x1M5d7Lmw0HtZIy2tF5aIWYctIQuZd406Nw8Sn7tl_MysEqEsOqHbqLvazg", name: "Quicku"),
            ProviderDetails(logo: "https://play-lh.googleusercontent.com/gpVc8uC8x1M5d7Lmw0HtZIy2tF5aIWYctIQuZd406Nw8Sn7tl_MysEqEsOqHbqLvazg", name: "Quickus"),
            ProviderDetails(logo: "https://play-lh.googleusercontent.com/gpVc8uC8x1M5d7Lmw0HtZIy2tF5aIWYctIQuZd406Nw8Sn7tl_MysEqEsOqHbqLvazg", name: "Quickuss")
        ]
        @State var selectedProvider = ""
        var body: some View {
            ProvidersListView(selectedProvider: $selectedProvider, details: $details, canOthersPay: .constant(true)){}
        }
    }
    static var previews: some View {
        ProvidersListViewPreviewHolder()
    }
}


public struct ProviderDetails: Hashable {
    public var logo: String
    public var name: String
    public var othersCanPay: Bool = false
    public init(logo: String, name: String, othersCanPay: Bool = false) {
        self.logo = logo
        self.name = name
        self.othersCanPay = othersCanPay
    }
}

public enum ListOrientation : Hashable, Equatable{
    case horizontal
    case grid
}
