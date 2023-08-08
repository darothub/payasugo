//
//  EditProfileView.swift
//
//
//  Created by Abdulrasaq on 27/04/2023.
//
import Core
import CoreNavigation
import CoreUI
import Permissions
import SwiftUI
struct EditProfileView: View {
    @StateObject var hvm: HomeViewModel = HomeDI.createHomeViewModel()
    @EnvironmentObject var navigation: NavigationManager
    @Environment(\.realmManager) var realmManager
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var profileImageURL: String = ""
    @State var profile: Profile? = Observer<Profile>().getEntities().first
    @State var showErrorAlert = false
    @State var showSuccessAlert = false
    @State var isFirstNameValid = false
    @State var isLastNameValid = false
    @State var isEmailAddressValid = false
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var base64String: String = ""
    @State private var showPermissionAlert = false
    var body: some View {
        VStack {
            ZStack {
                Group {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    } else {
                        AsyncImage(url: URL(string: profile?.photoURL ?? "")) { image in
                            image.resizable()
                        } placeholder: {
                            Image(systemName: "photo")
                                .foregroundColor(.black)
                        }
                    }
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .scaleEffect(2)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(.white)
                        .shadow(radius: 3, x: 0, y: 0)
                )
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
                    .onTapGesture {
                        ImagePickerManager.requestPhotoLibraryPermission { permission in
                            switch permission {
                            case .unavailable:
                                log(message: "Unavailable")
                            case .restricted:
                                log(message: "Restricted")
                            case .denied:
                                showPermissionAlert = true
                            case .available:
                                isShowingImagePicker = true
                            }
                        }
                    }
            }
            HStack {
                TextFieldView(
                    fieldText: $firstName,
                    label: "", placeHolder: "First name"
                ) {
                    $0.isNotEmpty
                }
                TextFieldView(fieldText: $lastName, label: "", placeHolder: "Last name") {
                    $0.isNotEmpty
                }
            }
            .padding(.vertical)

            TextFieldView(fieldText: $email, label: "", placeHolder: "Email address") {
                $0.isValidEmail()
            }

            TinggButton(buttonLabel: "Update profile") {
                updateProfile()
            }.padding(.vertical)
            Spacer()
        }
        .navigationTitle("Edit profile")
        .padding()
        .padding(.top, 50)
        .frame(maxWidth: .infinity)
        .background(.white)
        .onAppear {
            withAnimation {
                firstName = (profile?.firstName) ?? ""
                lastName = (profile?.lastName) ?? ""
                profileImageURL = profile?.photoURL ?? ""
                email = profile?.emailAddress ?? ""
            }
        }
        .sheet(isPresented: $isShowingImagePicker, onDismiss: {
            updateProfileImage(base64String)
        }) {
            ImagePickerView(selectedImage: $selectedImage, sourceType: .library, base64String: $base64String)
        }
        .alert(isPresented: $showPermissionAlert) {
            Alert(
                title: Text("Permission Denied"),
                message: Text("Please allow access to the photo library in the Settings"),
                primaryButton: .default(Text("Settings"), action: openAppSettings),
                secondaryButton: .cancel()
            )
        }
        .handleViewStatesMods(uiState: hvm.$uiModel) { content in
            log(message: content)
            RealmManager.write {
                profile?.firstName = firstName
                profile?.lastName = lastName
                profile?.emailAddress = email
            }
        }
        .handleViewStatesMods(uiState: hvm.$photoUploadUIModel) { content in
            let data = content.data as! PhotoUploadResponse
            log(message: data)
        }
        .navigationBarBackButton(navigation: navigation)
    }

    func updateProfile() {
        if validInputs() {
            let requestString = "\(profile?.profileID)|\(profile?.msisdn)|\(firstName)|\(lastName)|\(email)"
            let request = RequestMap.Builder()
                .add(value: "", for: .PROFILE_INFO)
                .add(value: "UPDATE", for: .ACTION)
                .add(value: "2", for: .IS_NOMINATION)
                .add(value: "Y", for: .IS_EXPLICIT)
                .add(value: "", for: "WISHLIST")
                .add(value: requestString, for: "MULA_PROFILE")
                .add(value: "MCP", for: .SERVICE)
                .build()
            hvm.updateProfile(request)
            return
        }
      
    }

    func updateProfileImage(_ base64ImageString: String) {
        let request = RequestMap.Builder()
            .add(value: "", for: .PROFILE_INFO)
            .add(value: "UPDATE", for: .ACTION)
            .add(value: "2", for: .IS_NOMINATION)
            .add(value: "Y", for: .IS_EXPLICIT)
            .add(value: "", for: "WISHLIST")
            .add(value: "PHOTO", for: "UPDATE_TYPE")
            .add(value: "MCP", for: .SERVICE)
            .add(value: "Base64", for: "API_CODE")
            .add(value: base64ImageString, for: "IMAGE")
            .build()
        hvm.updateProfileImage(request)
    }

    func validInputs() -> Bool {
        if !isFirstNameValid {
            hvm.uiModel = UIModel.error("Invalid first name")
    
        } else if !isLastNameValid {
            hvm.uiModel = UIModel.error("Invalid last name")
         
        } else if !isEmailAddressValid {
            hvm.uiModel = UIModel.error("Invalid email address")
        }
        return isFirstNameValid && isLastNameValid && isEmailAddressValid
    }

    private func openAppSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
