//
//  SecurityQuestionView.swift
//  
//
//  Created by Abdulrasaq on 10/01/2023.
//
import CoreUI
import CoreNavigation
import Core
import SwiftUI

public struct SecurityQuestionView: View {
    @EnvironmentObject var navigation: NavigationManager
    @StateObject var pinVm: PinViewModel = PinDI.createPinViewModel()
    @State private var screenAdvice = PinConstants.securityQuestionAdvice
    @State private var questions:[String] = []
    @State private var buttonBgColor: Color = .gray.opacity(0.5)
    @State private var questionObjects: [SecurityQuestion] = .init()
    @State private var showAlert = false
    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false
    @State private var showingDropDown = false
    @State var answer: String = ""
    @State var selectedQuestion:String = ""
    @State var outlineColor:Color = .black
    var pin: String
    public init(pin: String = "") {
        self.pin = pin
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Text(screenAdvice)
                .font(.caption)
            DropDownView(selectedText: $selectedQuestion, dropDownList: $questions, showDropDown: $showingDropDown, outlineColor: $outlineColor, maxHeight: .infinity)
            TextFieldView(fieldText: $answer, label: "", placeHolder: "Answer") { answer in
                answer.isNotEmpty
            }
            .showIfNot($showingDropDown)
            Spacer()
            TinggButton(backgroundColor: buttonBgColor, buttonLabel: "Continue", padding: 0) {
                if buttonBgColor == .green {
                    do {
                        guard let encryptedAnswerData = try TinggSecurity.simpleEncryption(answer),
                              let encryptedPin = try TinggSecurity.simpleEncryption(pin)
                        else {
                            return
                        }
                        let answerInBase64String = encryptedAnswerData.base64EncodedString()
                        let id = getQuestionId(question: selectedQuestion)
                        let request = RequestMap.Builder()
                            .add(value: "CREATE", for: .ACTION)
                            .add(value: "MPM", for: .SERVICE)
                            .add(value: id, for: .QUESTION_ID)
                            .add(value: answerInBase64String, for: .SECURITY_ANSWER)
                            .add(value: encryptedPin.base64EncodedString(), for:  "MULA_PIN")
                            .build()
                        AppStorageManager.securityAnswer = answerInBase64String
                        AppStorageManager.securityQuestion = selectedQuestion
                        AppStorageManager.mulaPin = encryptedPin.base64EncodedString()
                        pinVm.createCardPin(tinggRequest: request)
                    } catch {
                        pinVm.uiModel = UIModel.error(error.localizedDescription)
                    }
                 
                }
            }
        }
        .padding()
        .padding(.top)
        .navigationTitle("Security questions")
        .onAppear {
            questionObjects = Observer<SecurityQuestion>().getEntities()
            questions = questionObjects.map{$0.question}
            outlineColor = selectedQuestion.isEmpty ? outlineColor : .green
        }
        .onChange(of: selectedQuestion) { newValue in
            outlineColor = newValue.isEmpty ? outlineColor : .green
        }
        .onChange(of: answer) { newValue in
            if !newValue.isEmpty && !selectedQuestion.isEmpty {
                buttonBgColor = .green
            } else {
                buttonBgColor = .gray.opacity(0.5)
            }
        }
        .handleUIState(uiState: $pinVm.uiModel, showAlertonSuccess: true) { content in
            log(message: content)
        } onFailure: { str in
            //Restore old value
            AppStorageManager.pinRequestChoice = pinVm.pinRequestChoice
        } action: {
            navigation.goBackStep(2)
        }
        
    
    }
    func getQuestionId(question: String) -> String {
        if let id =  questionObjects.first(where: { $0.question == question })?.questionID {
            return id
        }
        return ""
    }
    func navigateToCardDetailsView() {
        navigation.navigateTo(screen:  Screens.cardDetailsView(nil, nil))
    }
}

struct SecurityQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        SecurityQuestionView()
            .environmentObject(NavigationManager())
            .environmentObject(PinDI.createPinViewModel())
    }
}
