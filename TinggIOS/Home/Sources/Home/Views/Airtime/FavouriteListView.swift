//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 04/10/2022.
//
import Core
import SwiftUI
import Theme
struct FavouriteListView: View {
    @Binding var flvm: FavouriteEnrollmentModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("MY FAVOURITES")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(flvm.enrollments, id: \.accountNumber) { enrollment in
                        let alias = enrollment.accountAlias
                        if let name = alias {
                            VImageAndNameView(title: name.isEmpty ? "None" : name, imageUrl: "")
                                .shadow(color: .red, radius: flvm.accountNumber == enrollment.accountNumber ? 5 : 0, x: 0 , y: flvm.accountNumber == enrollment.accountNumber ? 3 : 0)
                                .onTapGesture {
                                    if let number = enrollment.accountNumber {
                                        withAnimation {
                                            flvm.accountNumber = number
                                        }
                                    }
                                }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.white)
    }
}

struct FavouriteListView_Previews: PreviewProvider {
    struct FavouriteListViewPreviewHolder: View {
        @State var selectedProvider = ""
        @State var accountNumber = ""
        var body: some View {
            FavouriteListView(flvm: .constant(.init()))
        }
    }
    static var previews: some View {
        FavouriteListViewPreviewHolder()
    }
}
