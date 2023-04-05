//
//  IDCaptureViewController.swift
//  
//
//  Created by Abdulrasaq on 30/03/2023.
//

import Foundation
import Smile_Identity_SDK
import SwiftUI
import UIKit

public class IDCaptureViewController: UIViewController, CaptureIDCardDelegate {
    
    @IBOutlet weak var sidSmartCardView: SIDSmartCardView!
    
    public func onSmartCardViewFrontComplete(previewUIImage: UIImage, faceFound: Bool) {
        //
    }
    
    public func onSmartCardViewBackComplete(previewUIImage: UIImage) {
        //
    }
    
    public func onSmartCardViewError(sidError: Smile_Identity_SDK.SIDError) {
        //
    }
    
    public func onSmartCardViewClosed() {
        //
    }
    
    public override func viewDidLoad() {
      super.viewDidLoad()
        sidSmartCardView.setup(captureIDCardDelegate: self, userTag:"ID")
    }
    
    
}

public struct CaptureIDView: UIViewControllerRepresentable {
    public init () {
        //
    }
    public func makeUIViewController(context: Context) -> UIViewController {
        let storyBoard = UIStoryboard(name: "IDCapture", bundle: Bundle.module)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ID")
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
}
