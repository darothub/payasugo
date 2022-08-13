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

public struct ImageLauncherView {
    
    @Binding public var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    @Binding public var sourceType: PickerSourceType?
    
    public init(selectedImage: Binding<UIImage?>, sourceType: Binding<PickerSourceType?>){
        self._selectedImage = selectedImage
        self._sourceType = sourceType
    }
}


extension ImageLauncherView : UIViewControllerRepresentable {
    public func makeUIViewController(context: Context) -> some UIViewController {
        let cameraLauncher = UIImagePickerController()
        if let sourceType = sourceType {
            cameraLauncher.sourceType = sourceType.source
        }
        cameraLauncher.delegate = context.coordinator
        return cameraLauncher
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Intentionally unimplemented...
    }
    
    public func makeCoordinator() -> ImageCoordinator {
        return ImageCoordinator(pickerManager: self)
    }
    
}
