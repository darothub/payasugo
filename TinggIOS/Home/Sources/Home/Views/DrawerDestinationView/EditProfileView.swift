//
//  EditProfileView.swift
//  
//
//  Created by Abdulrasaq on 27/04/2023.
//
import Core
import CoreUI
import SwiftUI

struct EditProfileView: View {
    @StateObject var hvm: HomeViewModel = HomeDI.createHomeViewModel()
    @Environment(\.realmManager) var realmManager
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var profileImageURL : String = ""
    @State var profile : Profile? = nil
    @State var showErrorAlert = false
    @State var showSuccessAlert = false
    @State var isFirstNameValid = false
    @State var isLastNameValid = false
    @State var isEmailAddressValid = false
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
                TextFieldView(fieldText: $firstName, label: "", placeHolder: "First name", success: $isFirstNameValid)
                TextFieldView(fieldText: $lastName, label: "", placeHolder: "Last name", success:  $isLastNameValid)
            }
            .padding(.vertical)
            
            TextFieldView(fieldText: $email, label: "", placeHolder: "Email address", success: $isEmailAddressValid)

            
            TinggButton(buttonLabel: "Update profile") {
                updateProfile()
            }.padding(.vertical)
            Spacer()
        }
        .navigationTitle("Edit profile")
        .padding()
        .padding(.top, 50)
        .frame(maxWidth: .infinity)
        .backgroundmode(color: .white)
        .onAppear {
            profile = Observer<Profile>().getEntities().first ?? Profile()
            withAnimation {
                firstName = (profile?.firstName) ?? ""
                lastName = (profile?.lastName) ?? ""
                profileImageURL = profile?.photoURL ?? ""
                email = profile?.emailAddress ?? ""
            }
            observeUIModel()
        }
        .onChange(of: firstName, perform: { newValue in
            isFirstNameValid = newValue.isNotEmpty
        })
        .onChange(of: lastName, perform: { newValue in
            isLastNameValid = newValue.isNotEmpty
        })
        .onChange(of: email, perform: { newValue in
            isEmailAddressValid = newValue.isValidEmail()
        })
        .handleViewStatesMods(uiState: hvm.$uiModel) { content in
            log(message: content)
            realmManager.realmWrite {
                profile?.firstName = firstName
                profile?.lastName = lastName
                profile?.emailAddress = email
            }
            showSuccessAlert = true
        }
        .handleViewStates(uiModel: $hvm.uiModel, showAlert: $showErrorAlert, showSuccessAlert: $showSuccessAlert)
    }
    func updateProfile() {
        if validInputs() {
            let requestString = "\(profile?.profileID)|\(profile?.msisdn)|\(firstName)|\(lastName)|\(email)"
            hvm.updateProfile(requestString)
            return
        }
        hvm.uiModel = UIModel.error("One or two fields are invalid")
    }
    
    func validInputs() -> Bool {
        return isFirstNameValid && isLastNameValid && isEmailAddressValid
    }
    
    func observeUIModel() {
//        hvm.observeUIModel(model: hvm.$uiModel, subscriptions: &hvm.subscriptions) { content in
//    
//            realmManager.realmWrite {
//                profile?.firstName = firstName
//                profile?.lastName = lastName
//                profile?.emailAddress = email
//            }
//            showSuccessAlert = true
//        } onError: { err in
//            showErrorAlert = true
//        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
