//
//  ContentView.swift
//  TingIOS
//
//  Created by Abdulrasaq on 25/05/2022.
//

import AVFoundation
import SwiftUI
import Permissions

struct ContentView: View {
    @State var showPicker = false
    @State private var selectedImage: UIImage?
    @State var photoSourceType: PickerSourceType?
    @StateObject var cameraManager: ImagePickerManager = ImagePickerManager.shared
    @StateObject var contactPermission = ContactPermission()
    var body: some View {
        VStack {
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 300, height: 300)
            } else {
                Image(systemName: "snow")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 300, height: 300)
            }
            Button("Camera") {
//                do {
//                    try cameraManager.requestCameraPermission { granted in
//                        if granted {
//                            photoSourceType = .camera
//                            self.showPicker.toggle()
//                        }
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
                contactPermission.requestAccess()
//                Task.init{
//                    await ContactManager.shared.fetchContacts { contact in
//                        print("contacts \(contact.givenName)")
//                    }
//                }
            }
            Button("Library") {
                cameraManager.requestPhotoLibraryPermission { error in
                    if error == .available {
                        photoSourceType = .library
                        self.showPicker.toggle()
                        print(error.localizedDescription)
                    } else {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .sheet(isPresented: $showPicker ) {
            ImageLauncherView(
                selectedImage: self.$selectedImage,
                sourceType: $photoSourceType)
        }
        .alert(isPresented: self.$contactPermission.invalidPermission) {
          Alert(
            title: Text("TITLE"),
            message: Text("Please go to Settings and turn on the permissions"),
            primaryButton: .cancel(Text("Cancel")),
            secondaryButton: .default(Text("Settings"), action: {
              if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
              }
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
