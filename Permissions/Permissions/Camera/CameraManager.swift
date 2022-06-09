//
//  CameraManager.swift
//  Permissions
//
//  Created by Abdulrasaq on 09/06/2022.
//

import AVFoundation
import Foundation
import SwiftUI

public final class CameraManager : UIViewControllerRepresentable {
    @Published var isCameraAvailable : Bool = false
    var cameraLauncherView: CameraLauncherView
    var appName:String?
    @Environment(\.presentationMode) var isPresented
    public init (cameraLauncherView: CameraLauncherView, appName:String?) {
        self.cameraLauncherView = cameraLauncherView
        self.appName = appName
        checkSourceTypeAndValidate()
    }
    
    
    func checkSourceTypeAndValidate() {
        requestCameraPermission()
    }
    public func requestCameraPermission(){
        AVCaptureDevice.requestAccess(for: .video) { granted in
            self.isCameraAvailable = granted
            if granted && self.cameraLauncherView.sourceType.source == .camera {
                try! self.checkCameraAvailability()
            }
        }
    }
    
    public func getCameraAuthorizationState() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    public func checkCameraAvailability() throws {
        if UIImagePickerController.isSourceTypeAvailable(self.cameraLauncherView.sourceType.source) {
            switch getCameraAuthorizationState() {
            case .denied :
                throw CameraError.denied(self.appName ?? "this")
            case .restricted:
                throw CameraError.restricted
            default:
                break
            }
        }
        else{
            throw CameraError.unavailable
        }
    }
    public func makeUIViewController(context: Context) -> some UIViewController {
        let cameraLauncher = UIImagePickerController()
        cameraLauncher.sourceType = self.cameraLauncherView.sourceType.source
        cameraLauncher.delegate = context.coordinator
        return cameraLauncher
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    public func makeCoordinator() -> ImageCoordinator {
        return ImageCoordinator(pickerManager: self)
    }
}
