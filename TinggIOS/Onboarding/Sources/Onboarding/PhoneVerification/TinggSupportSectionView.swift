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
    var geometry: GeometryProxy
    @Binding var showSupportTeamContact: Bool
    var body: some View {
        Button {
            showSupportTeamContact.toggle()
        } label: {
            HStack(alignment: .center) {
                Image(systemName: "phone.circle.fill")
                    .foregroundColor(Color.green)
                Text("CONTACT TINGG SUPPORT TEAM")
            }
            .frame(width: geometry.size.width)
            .font(.system(size: PrimaryTheme.smallTextSize))
        }.padding(.horizontal, 50)
            .frame(width: geometry.size.width)
    }
}

struct TinggSupportSectionView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            TinggSupportSectionView(geometry: geo, showSupportTeamContact: .constant(true))
        }
    }
}
