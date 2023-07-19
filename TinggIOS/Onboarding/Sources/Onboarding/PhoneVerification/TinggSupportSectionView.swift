//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 04/08/2022.
//
import Core
import SwiftUI
import Theme
/// Support option for user
/// Part of the ``PhoneNumberValidationView``
struct TinggSupportSectionView: View {
    @Binding var showSupportTeamContact: Bool
    var body: some View {
        VStack {
            Button {
                showSupportTeamContact.toggle()
            } label: {
                HStack(alignment: .center) {
                    Image(systemName: "phone.circle.fill")
                        .foregroundColor(Color.green)
                    Text("CONTACT TINGG SUPPORT TEAM")
                }
                .font(.caption)
            }
        }

    }
}

struct TinggSupportSectionView_Previews: PreviewProvider {
    static var previews: some View {
        TinggSupportSectionView(showSupportTeamContact: .constant(true))
    }
}
