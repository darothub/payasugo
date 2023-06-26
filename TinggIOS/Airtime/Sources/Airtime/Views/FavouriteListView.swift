//
//  FavouriteListView.swift
//  
//
//  Created by Abdulrasaq on 04/10/2022.
//
import CoreUI
import Core
import SwiftUI
import Theme
import Checkout
struct FavouriteListView: View {
    @Binding var fem: FavouriteEnrollmentModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("MY FAVOURITES")
                .font(.subheadline)
                .foregroundColor(.black)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(fem.enrollments, id: \.accountNumber) { enrollment in
                        showImageAndName(enrollment)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.white)
    }
    @ViewBuilder
    private func showImageAndName(_ enrollment: Enrollment) -> some View {
        let name = enrollment.accountAlias
        if name.isNotEmpty {
            VImageAndNameView(title: name.isEmpty ? "None" : name, imageUrl: "", useInitials: true)
                .shadow(color: .red, radius: fem.accountNumber == enrollment.accountNumber ? 5 : 0, x: 0 , y: fem.accountNumber == enrollment.accountNumber ? 3 : 0)
                .scaleEffect(0.7)
                .onTapGesture {
                    withAnimation {
                        fem.enrollment = enrollment
                        fem.accountNumber = enrollment.accountNumber
                    }
                }
        }
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
