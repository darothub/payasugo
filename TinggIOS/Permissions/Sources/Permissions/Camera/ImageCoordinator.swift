//
//  Cordinator.swift
//  Permissions
//
//  Created by Abdulrasaq on 09/06/2022.
//

import Foundation
import UIKit

public class ImageCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var pickerManager: ImagePickerView

    init(pickerManager: ImagePickerView) {
        self.pickerManager = pickerManager
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        pickerManager.selectedImage = selectedImage
        pickerManager.base64String = base64String(from: selectedImage)
        pickerManager.isPresented.wrappedValue.dismiss()
    }

    private func base64String(from image: UIImage) -> String {
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            return imageData.base64EncodedString()
        }
        return ""
    }
}
