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


public final class ImagePickerManager :  ObservableObject {
   
        
    public static func requestCameraPermission(onSuccess: @escaping (Bool) -> Void) throws {
        try checkCameraAvailability()
        AVCaptureDevice.requestAccess(for: .video) { granted in
            onSuccess(granted)
        }
    }
    
    public static func requestPhotoLibraryPermission(onCompletion: @escaping (PermissionResponse) -> Void){
        let photos = PHPhotoLibrary.authorizationStatus()
               if photos == .notDetermined {
                   PHPhotoLibrary.requestAuthorization({status in
                       switch status {
                       case .restricted:
                           onCompletion(PermissionResponse.restricted)
                       case .denied :
                           onCompletion(PermissionResponse.denied)
                       default:
                           onCompletion(PermissionResponse.available)
                       }
                   })
               } else if photos == .authorized {
                   onCompletion(PermissionResponse.available)
               }
    }
    
    public static func getCameraAuthorizationState() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    private static func checkCameraAvailability() throws {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            switch getCameraAuthorizationState() {
            case .denied :
                throw PermissionResponse.denied
            case .restricted:
                throw PermissionResponse.restricted
            default:
                break
            }
        }
        else{
            throw PermissionResponse.unavailable
        }
    }
    
}
