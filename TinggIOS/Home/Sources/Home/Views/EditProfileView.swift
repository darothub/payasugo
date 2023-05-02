//
//  EditProfileView.swift
//  
//
//  Created by Abdulrasaq on 27/04/2023.
//
import CoreUI
import SwiftUI

struct EditProfileView: View {
    @StateObject var hvm: HomeViewModel = HomeDI.createHomeViewModel()
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var profileImageURL : String = ""
    var body: some View {
        VStack {
            ZStack {
                ResponsiveImageCardView(
                    imageUrl: $profileImageURL,
                    radius: 0,
                    scaleEffect: 1.8,
                    x: 0,
                    y: 0,
                    bgShape: .circular
                ).scaleEffect(2)
                .alignmentGuide(HorizontalAlignment.center) { d in
                    d[.leading] - 10
                }
                .alignmentGuide(VerticalAlignment.center) { d in
                    d[.bottom] + 20
                }
                Image(systemName: "pencil")
                    .padding(5)
                    .background(.white)
                    .clipShape(Circle())
                    .scaleEffect(1.5)
                    .foregroundColor(.green)
                    .shadow(radius: 1)
            }
            HStack {
                TextFieldView(fieldText: $firstName, label: "", placeHolder: "First name")
                TextFieldView(fieldText: $lastName, label: "", placeHolder: "Last name")
            }
            .padding(.vertical)
            
            TextFieldView(fieldText: $email, label: "", placeHolder: "Email address")
            
            TinggButton(buttonLabel: "Update profile") {
                //TODO
            }.padding(.vertical)
            Spacer()
        }
        .navigationTitle("Edit profile")
        .padding()
        .padding(.top, 50)
        .onAppear {
            let profile = hvm.getProfile()
            withAnimation {
                firstName = (profile?.firstName) ?? ""
                lastName = (profile?.lastName) ?? ""
                profileImageURL = profile?.photoURL ?? ""
                email = profile?.emailAddress ?? ""
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
