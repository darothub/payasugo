//
//  ServicesListView.swift
//  
//
//  Created by Abdulrasaq on 14/12/2022.
//
import CoreUI
import Core
import SwiftUI
import Checkout
struct ServicesListView: View {
    @Binding var slm: ServicesListModel
    let gridColumn = [
        GridItem(.adaptive(minimum: 110))
    ]
    var onClick: () -> Void
    var body: some View {
        VStack(alignment: .leading) {
            Text(slm.title)
                .font(.body)
                .padding(.top, 30)
                .foregroundColor(.black)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    showListOfServices(model: slm)
                }
            }.showIf(.constant(slm.orientation == .horizontal))
            LazyVGrid(columns: gridColumn, spacing: 5){
                showListOfServices(model: slm)
            }.showIf(.constant(slm.orientation == .grid))
        }
        .frame(maxWidth: .infinity)
        .background(.white)
    }
    @ViewBuilder
    private func showListOfServices(model slm: ServicesListModel) -> some View {
        ForEach(slm.serviceModels, id: \.logoUrl) { service in
            RectangleImageCardView(imageUrl: service.logoUrl, tag: service.name, selected: $slm.selectedProvider, onClick: onClick) 
                .overlay(alignment: .topTrailing) {
                    if slm.selectedProvider == service.name {
                        NetworkFavouritedMarkedView()
                    }
                }
        }
    }
}

struct ServicesListView_Previews: PreviewProvider {
    struct ServicesListViewPreviewHolder: View {
        var body: some View {
            ServicesListView(slm: .constant(.init())){
                //TODO
            }
        }
    }
    static var previews: some View {
        ServicesListViewPreviewHolder()
    }
}





