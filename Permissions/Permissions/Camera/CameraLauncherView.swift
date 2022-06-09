//
//  CameraLauncherView.swift
//  Permissions
//
//  Created by Abdulrasaq on 09/06/2022.
//

import Foundation
import UIKit
import SwiftUI

public struct CameraLauncherView  {
    
    @Binding public var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
//    public var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding public var sourceType: PickerSourceType
    
    public init(selectedImage: Binding<UIImage?>, sourceType: Binding<PickerSourceType>){
        self._selectedImage = selectedImage
        self._sourceType = sourceType
    }

    
//    public func makeUIViewController(context: Context) -> some UIViewController {
//        let cameraLauncher = UIImagePickerController()
//        cameraLauncher.sourceType = self.sourceType
//        return cameraLauncher
//    }
//
//    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
//
//    public func makeCoordinator() -> ImageCoordinator {
//        return ImageCoordinator(picker: self)
//    }
}
