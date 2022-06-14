//
//  CameraManager.swift
//  Permissions
//
//  Created by Abdulrasaq on 09/06/2022.
//

import AVFoundation
import Foundation
import PhotosUI
import SwiftUI


public final class CameraManager :  ObservableObject {
    @Published var isCameraAvailable : Bool = false
    @Published public var cameraLauncherView: CameraLauncherView?
    var appName:String = "this"
    @Environment(\.presentationMode) var isPresented
    public static let shared = CameraManager(appName: "TinggIOS")
    public init () {}
    
    public convenience init(appName:String){
        self.init()
        self.appName = appName
    }
    
        
    public func requestCameraPermission(onSuccess: @escaping (Bool) -> Void) throws {
        try checkCameraAvailability()
        AVCaptureDevice.requestAccess(for: .video) { granted in
            onSuccess(granted)
        }
    }
    
    public func requestPhotoLibraryPermission(onCompletion: @escaping (CameraError) -> Void){
        let photos = PHPhotoLibrary.authorizationStatus()
               if photos == .notDetermined {
                   PHPhotoLibrary.requestAuthorization({status in
                       switch status {
                       case .restricted:
                           onCompletion(CameraError.restricted)
                       case .denied :
                           onCompletion(CameraError.denied)
                       default:
                           onCompletion(CameraError.available)
                       }
                   })
               } else if photos == .authorized {
                   onCompletion(CameraError.available)
               }
    }
    
    public func getCameraAuthorizationState() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    public func checkCameraAvailability() throws {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            switch getCameraAuthorizationState() {
            case .denied :
                throw CameraError.denied
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
    
}
