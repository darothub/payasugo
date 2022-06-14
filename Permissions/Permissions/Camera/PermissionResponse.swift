//
//  CameraError.swift
//  Permissions
//
//  Created by Abdulrasaq on 09/06/2022.
//

import Foundation
import UIKit

public enum PermissionResponse : Int, Error, LocalizedError {
    case unavailable = 0
    case restricted = 1
    case denied = 2
    case available = 3
    
    public var errorDescription: String? {
        switch self {
        case .unavailable:
            return NSLocalizedString("There is no available camera on this device", comment: "")
        case .restricted:
            return NSLocalizedString("You are not allowed to access the camera", comment: "")
        case .denied:
            return NSLocalizedString("You have explicitly turned off your camera permission. Please open pemission/privacy/camera and grant access for this application", comment: "")
        case .available:
            break
        }
        return "Available"
    }
}


public enum PickerSourceType : String {
    case camera, library
    
    public var source: UIImagePickerController.SourceType  {
        switch self {
        case .camera:
            return UIImagePickerController.SourceType.camera
        case .library:
            return UIImagePickerController.SourceType.photoLibrary
        }
    }
}

