//
//  CameraError.swift
//  Permissions
//
//  Created by Abdulrasaq on 09/06/2022.
//

import Foundation
import UIKit

enum CameraError : Error {
    case unavailable, restricted, denied(String)
    
    var errorDescription: String {
        switch self {
        case .unavailable:
            return NSLocalizedString("There is no available camera on this device", comment: "")
        case .restricted:
            return NSLocalizedString("You are not allowed to access the camera", comment: "")
        case .denied(let productname):
            return NSLocalizedString("You have explicitly turned off your camera permission. Please open pemission/privacy/camera and grant access for \(productname) application", comment: "")
        }
    }
}

public enum PickerSourceType {
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
