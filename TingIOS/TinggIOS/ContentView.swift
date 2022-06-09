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
    @State var source = "Camera"
    @State private var selectedImage: UIImage?
    @State var photoSourceType = PickerSourceType.library
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
            Button {
                self.photoSourceType = PickerSourceType.camera
                self.showPicker.toggle()
            } label: {
                Text("Camera")
            }
            Button {
                self.photoSourceType = PickerSourceType.library
                self.showPicker.toggle()
            } label: {
                Text("Library")
            }
        }
        .sheet(isPresented: $showPicker) {
            let clv = CameraLauncherView(
               selectedImage: self.$selectedImage,
               sourceType: $photoSourceType)
            CameraManager(cameraLauncherView: clv, appName: "TinggIOS")
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
