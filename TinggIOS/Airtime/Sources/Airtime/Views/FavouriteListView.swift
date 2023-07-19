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
    @Binding var currentPhoneNumber: String
    @Binding var beneficiaries: [PreviousBeneficiaryModel]
    @State var isSelectedBeneficiary = false
    var body: some View {
        VStack(alignment: .leading) {
            Text("MY FAVOURITES")
                .font(.subheadline)
                .foregroundColor(.black)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(beneficiaries, id: \.id) { beneficiary in
                        showImageAndName(beneficiary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.white)
    }
    @ViewBuilder
    private func showImageAndName(_ enrollment: PreviousBeneficiaryModel) -> some View {
        let name = enrollment.name
        if name.isNotEmpty {
            VImageAndNameView(title: name.isEmpty ? "NA" : name, imageUrl: "", useInitials: true)
                .shadow(color: .red, radius: isSelectedBeneficiary ? 5 : 0, x: 0 , y: isSelectedBeneficiary ? 3 : 0)
                .scaleEffect(0.7)
                .onTapGesture {
                    withAnimation {
                        currentPhoneNumber = enrollment.phoneNumber
                    }
                }
                .onAppear {
                    isSelectedBeneficiary = currentPhoneNumber == enrollment.phoneNumber
                }

        }
    }
}

struct FavouriteListView_Previews: PreviewProvider {
    struct FavouriteListViewPreviewHolder: View {
 
        var body: some View {
            FavouriteListView(currentPhoneNumber: .constant(""), beneficiaries: .constant([]))
        }
    }
    static var previews: some View {
        FavouriteListViewPreviewHolder()
    }
}



