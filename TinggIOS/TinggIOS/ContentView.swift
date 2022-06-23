//
//  ContentView.swift
//  TingIOS
//
//  Created by Abdulrasaq on 25/05/2022.
//

import AVFoundation
import Combine
import Core
import Permissions
import SwiftUI

struct ContentView: View {
    @State var showPicker = false
    @State private var selectedImage: UIImage?
    @State var photoSourceType: PickerSourceType?
    @StateObject var cameraManager: ImagePickerManager = ImagePickerManager.shared
    @StateObject var contactPermission = ContactPermission()
    @StateObject var locationManager = LocationManager.shared
    @StateObject var deeplinkManager = DeepLinkManager()
    var body: some View {
        VStack {
            switch deeplinkManager.target {
            case .screen :
                Text("This is screen")
            case .checkout:
                Text("This is checkout")
            default:
                homeView()
            }
        }
        .sheet(isPresented: $showPicker ) {
            ImageLauncherView(
                selectedImage: self.$selectedImage,
                sourceType: $photoSourceType)
        }.onOpenURL(perform: { url in
            deeplinkManager.target = deeplinkManager.manage(url: url)
            print("urlscheme \(String(describing: url.scheme)) host \(deeplinkManager.target.rawValue)")
        })
        .alert(isPresented: self.$locationManager.locationPermissionDeniedOrRestricted) {
            Alert(
                title: Text("TITLE"),
                message: Text("Please go to Settings and turn on the permissions"),
                primaryButton: .cancel(Text("Cancel")),
                secondaryButton: .default(Text("Settings"),
                    action: {if let url = URL(string:
                        UIApplication.openSettingsURLString),
                        UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }))
        }
    }
    @ViewBuilder
    func homeView() -> some View {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
