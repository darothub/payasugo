//
//  FavouriteListView.swift
//  
//
//  Created by Abdulrasaq on 04/10/2022.
//
import Core
import SwiftUI
import Theme
struct FavouriteListView: View {
    @Binding var fem: FavouriteEnrollmentModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("MY FAVOURITES")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(fem.enrollments, id: \.accountNumber) { enrollment in
                        let alias = enrollment.accountAlias
                        if let name = alias {
                            VImageAndNameView(title: name.isEmpty ? "None" : name, imageUrl: "")
                                .shadow(color: .red, radius: fem.accountNumber == enrollment.accountNumber ? 5 : 0, x: 0 , y: fem.accountNumber == enrollment.accountNumber ? 3 : 0)
                                .onTapGesture {
                                    withAnimation {
                                        fem.enrollment = enrollment
                                        fem.accountNumber = enrollment.accountNumber
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
        @State var fem: FavouriteEnrollmentModel = .init()
        var body: some View {
            FavouriteListView(fem: $fem)
        }
    }
    static var previews: some View {
        FavouriteListViewPreviewHolder()
    }
}
