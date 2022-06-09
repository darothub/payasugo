//
//  CameraLauncherView.swift
//  Permissions
//
//  Created by Abdulrasaq on 09/06/2022.
//

import Foundation
import UIKit
import SwiftUI

public struct CameraLauncherView : UIViewControllerRepresentable {
    
    @Binding public var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    public var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    public init(selectedImage: Binding<UIImage?>, sourceType: UIImagePickerController.SourceType){
        self._selectedImage = selectedImage
        
        self.sourceType = sourceType
    }

    
    public func makeUIViewController(context: Context) -> some UIViewController {
        let cameraLauncher = UIImagePickerController()
        cameraLauncher.sourceType = self.sourceType
        cameraLauncher.delegate = context.coordinator
        return cameraLauncher
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    public func makeCoordinator() -> ImageCoordinator {
        return ImageCoordinator(picker: self)
    }
}
