//
//  Cordinator.swift
//  Permissions
//
//  Created by Abdulrasaq on 09/06/2022.
//

import Foundation
import UIKit

public class ImageCoordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var pickerManager: ImageLauncherView
    
    init(pickerManager:ImageLauncherView){
        self.pickerManager = pickerManager
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.pickerManager.selectedImage = selectedImage
        self.pickerManager.isPresented.wrappedValue.dismiss()
    }
    
}