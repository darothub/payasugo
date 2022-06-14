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
    @StateObject var cameraManager: CameraManager = CameraManager.shared
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
                do {
                    try cameraManager.requestCameraPermission { granted in
                        if granted {
                            photoSourceType = .camera
                            self.showPicker.toggle()
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
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
            CameraLauncherView(
                selectedImage: self.$selectedImage,
                sourceType: $photoSourceType)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
