//
//  CaptureViewController.swift
//  
//
//  Created by Abdulrasaq on 29/03/2023.
//

import Foundation
import Smile_Identity_SDK
import SwiftUI
import UIKit


public class SelfieCaptureViewController: UIViewController, CaptureSelfieDelegate {
    public func onComplete(previewUIImage: UIImage?) {
        //
    }
    
    public func onError(sidError: Smile_Identity_SDK.SIDError) {
        //
    }
    
    public func onFaceStateChanged(faceState: Int) {
        //
    }
    
    @IBOutlet weak var preview: VideoPreviewView!
    @IBOutlet weak var btnManualCapture: UIButton!
    var captureSelfie : CaptureSelfie?
    public override func viewWillAppear(_ animated: Bool) {
        SelfieCaptureConfig.setMaxFrameTimeout( maxFrameTimeout : 200 )
        captureSelfie = CaptureSelfie()
        captureSelfie?.setup(captureSelfieDelegate: self, previewView: preview, useFrontCamera: true, doFlashScreenOnShutter: true)
    }
    public override func viewDidAppear(_ animated: Bool) {
        captureSelfie?.start( screenRect: self.view.bounds, userTag: "Selfie" )
        btnManualCapture.isHidden = false
    }
    public override func viewWillDisappear(_ animated: Bool) {
        guard captureSelfie != nil else {
              return; }
          captureSelfie!.stop()
    }
    public override func viewDidLoad() {
        btnManualCapture.isHidden = true
    }
    @IBAction func btnManualCaptureClick(_ sender: UIButton) {
        print("Manual")
        captureSelfie?.manualCapture( isManualCapture:true )
    }
}


public struct CaptureSelfieView: UIViewControllerRepresentable {
    public init () {
        //
    }
    public func makeUIViewController(context: Context) -> UIViewController {
        let storyBoard = UIStoryboard(name: "SelfieCapture", bundle: Bundle.module)
        let controller = storyBoard.instantiateViewController(withIdentifier: "Selfie")
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
}

