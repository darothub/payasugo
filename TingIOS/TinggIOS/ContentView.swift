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
                self.source = "Camera"
                self.showPicker.toggle()
            } label: {
                Text("Camera")
            }
            Button {
                self.source = "library"
                self.showPicker.toggle()
            } label: {
                Text("Library")
            }
        }
        .sheet(isPresented: $showPicker) {
            CameraLauncherView(
                selectedImage: self.$selectedImage,
                sourceType: .photoLibrary
            )
        }.onAppear {
            requestPermission()
        }
    }
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            print("Access \(granted)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
