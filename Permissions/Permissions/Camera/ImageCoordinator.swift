//
//  Cordinator.swift
//  Permissions
//
//  Created by Abdulrasaq on 09/06/2022.
//

import Foundation
import UIKit

public class ImageCoordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: CameraLauncherView
    
    init(picker:CameraLauncherView){
        self.picker = picker
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
    
}
