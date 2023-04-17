//
//  KYCActionView.swift
//  
//
//  Created by Abdulrasaq on 28/03/2023.
//
import CoreUI
//import Smile_Identity_SDK
import SwiftUI


public struct KYCActionView: View {
//    public func onSuccess(tag: String, selfiePreview: UIImage?, idFrontPreview: UIImage?, idBackPreview: UIImage?) {
//        print("Taken")
//    }
//
//    public func onError(tag: String, sidError: Smile_Identity_SDK.SIDError) {
//        print("Error")
//    }
    
    @State private var selfieDataModel = ActionViewDataModel()
    @State private var idDataModel = ActionViewDataModel(image: "idDoc", title: "ID Card", actionType: .idDoc)
    @State private var test = "Hello"
//    @State private var captureManager: SIDCaptureManager?
    @State private var selectedAction: String = ""
    public init() {
        //
    }
    public var body: some View {
        NavigationView {
            VStack {
                Text("Let's verify your identity")
                    .bold()
                Text("Please provide a clear selfie a valid ID card")
                    .font(.subheadline)
                Section {
                    Group {
                        ActionView(dataModel: selfieDataModel, selectedButton: $selectedAction) {
//                            launchActionScreen(for: .SELFIE)
                        }
                        ActionView(dataModel: idDataModel, selectedButton: $selectedAction) {
//                            launchActionScreen(for: .ID_CAPTURE)
                        }
                    }
                    .shadow(radius: 2)
                }
                .padding(.top)
                Spacer()
                TinggButton(backgroundColor: .green, buttonLabel: "Next") {
                }
            }
            .padding(40)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") {
                        print("Help tapped!")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "arrow.backward")
                }
            }
        }
    }
    
//    @MainActor fileprivate func launchActionScreen(for captureType: CaptureType) {
//        let sIDSelfieCaptureConfig = SIDSelfieCaptureConfig.Builder()
//            .setManualCapture(manualCapture: true).build()
//        SIDCaptureManager.Builder(delegate: self, captureType: captureType)
//            .setSidSelfieConfig(sidSelfieConfig: sIDSelfieCaptureConfig)
//            .build().start()
//    }
}

struct ActionView: View {
    @State var dataModel: ActionViewDataModel = .init()
    @Binding var selectedButton: String
    var onClick: () -> Void = {}
    var body: some View {
        HStack {
            Image(dataModel.image)
            Text(dataModel.title)
            Spacer()
            RadioButtonView(selected: $selectedButton, id: dataModel.actionType.rawValue)
        }.padding(.vertical, 30)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(.white)
                
        )
        .onTapGesture {
            selectedButton = dataModel.actionType.rawValue
            onClick()
        }
    }
}

struct ActionViewDataModel {
    var image: String = "selfie"
    var title: String = "Selfie"
    var actionType: IDActionType = .selfie
}

enum IDActionType: String {
    case selfie, idDoc
}
struct KYCActionView_Previews: PreviewProvider {
    static var previews: some View {
        KYCActionView()
    }
}
