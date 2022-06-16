//
//  ContentView.swift
//  TingIOS
//
//  Created by Abdulrasaq on 25/05/2022.
//

import AVFoundation
import Combine
import Permissions
import SwiftUI

struct ContentView: View {
    @State var showPicker = false
    @State private var selectedImage: UIImage?
    @State var photoSourceType: PickerSourceType?
    @StateObject var cameraManager: ImagePickerManager = ImagePickerManager.shared
    @StateObject var contactPermission = ContactPermission()
    @StateObject var locationManager = LocationManager.shared
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
            Button("Location") {
                locationManager.requestLocationPermission()
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
        .alert(isPresented: self.$locationManager.locationPermissionDeniedOrRestricted) {
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
