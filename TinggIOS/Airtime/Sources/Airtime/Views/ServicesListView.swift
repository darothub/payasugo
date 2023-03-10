//
//  ServicesListView.swift
//  
//
//  Created by Abdulrasaq on 14/12/2022.
//
import Common
import Core
import SwiftUI
import Checkout
struct ServicesListView: View {
    @Binding var slm: ServicesListModel
    let gridColumn = [
        GridItem(.adaptive(minimum: 110))
    ]
    var onChangeSelection: () -> Void
    var body: some View {
        VStack(alignment: .leading) {
            Text(slm.selectPaymentTitle)
                .font(.body)
                .padding(.top, 30)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(slm.services, id: \.hubServiceID) { service in
                        RectangleImageCardView(imageUrl: service.serviceLogo, tag: service.serviceName, selected: $slm.selectedProvider) {
                            onChangeSelection()
                            }
                            .overlay(alignment: .topTrailing) {
                                if slm.selectedProvider == service.serviceName {
                                    NetworkFavouritedMarkedView()
                                }
                            }
                    }
                }
            }.showIf(.constant(slm.orientation == .horizontal))
            LazyVGrid(columns: gridColumn, spacing: 5){
                ForEach(slm.services, id: \.hubServiceID) { service in
                    RectangleImageCardView(imageUrl: service.serviceLogo, tag: service.serviceName, selected: $slm.selectedProvider) {
                        onChangeSelection()
                        }
                        .overlay(alignment: .topTrailing) {
                            if slm.selectedProvider == service.serviceName {
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

struct ServicesListView_Previews: PreviewProvider {
    struct ServicesListViewPreviewHolder: View {
        var body: some View {
            ServicesListView(slm: .constant(.init())){}
        }
    }
    static var previews: some View {
        ServicesListViewPreviewHolder()
    }
}





