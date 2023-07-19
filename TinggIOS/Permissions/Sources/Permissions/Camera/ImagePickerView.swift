//
//  CameraLauncherView.swift
//  Permissions
//
//  Created by Abdulrasaq on 09/06/2022.
//


import AVFoundation
import PhotosUI
import UIKit
import SwiftUI

public struct ImagePickerView {
    
    @Binding public var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    public var sourceType: PickerSourceType?
    @Binding var base64String: String
    public init(selectedImage: Binding<UIImage?>, sourceType: PickerSourceType, base64String: Binding<String>){
        self._selectedImage = selectedImage
        self.sourceType = sourceType
        self._base64String = base64String
    }
}


extension ImagePickerView : UIViewControllerRepresentable {
    public func makeUIViewController(context: Context) -> some UIViewController {
        let imagePickerController = UIImagePickerController()
        if let sourceType = sourceType {
            imagePickerController.sourceType = sourceType.source
        }
        imagePickerController.delegate = context.coordinator
        return imagePickerController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
    
    public func makeCoordinator() -> ImageCoordinator {
        return ImageCoordinator(pickerManager: self)
    }
    
}
