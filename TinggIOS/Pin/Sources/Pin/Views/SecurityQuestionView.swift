//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 10/01/2023.
//
import Common
import Core
import SwiftUI

public struct SecurityQuestionView: View {
    @EnvironmentObject var navigation: NavigationUtils
    @StateObject var pinVm: PinViewModel = PinDI.createPinViewModel()
    @State private var screenAdvice = Properties.securityQuestionAdvice
    @State private var questions:[String] = []
    @State private var buttonBgColor: Color = .gray.opacity(0.5)
    @State private var questionObjects: [SecurityQuestion] = .init()
    @State private var showAlert = false
    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false
    @State private var showingDropDown = false
    @Binding var answer: String
    @Binding var selectedQuestion:String
    public init(selectedQuestion: Binding<String>, answer: Binding<String>
    ) {
        self._selectedQuestion = selectedQuestion
        self._answer = answer
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Text(screenAdvice)
            DropDownView(selectedText: $selectedQuestion, dropDownList: $questions, showDropDown: $showingDropDown)
            TextFieldView(fieldText: $answer, label: "", placeHolder: "Answer")
                .showIfNot($showingDropDown)
            Spacer()
            button(backgroundColor: buttonBgColor, buttonLabel: "Continue", padding: 0) {
                if buttonBgColor == .green {
                    let id = getQuestionId(question: selectedQuestion)
                    let request = RequestMap.Builder()
                        .add(value: "CREATE", for: .ACTION)
                        .add(value: "MPM", for: .SERVICE)
                        .add(value: id, for: .QUESTION_ID)
                        .add(value: CreditCardUtil.encrypt(data: answer), for: .SECURITY_ANSWER)
                        .build()
                    pinVm.createCardPin(tinggRequest: request)
                    pinVm.observeUIModel(model: pinVm.$uiModel, subscriptions: &pinVm.subscriptions) { content in
                        showSuccessAlert = true
                    } onError: { err in
                        showErrorAlert = true
                    }
                }
            } .handleViewStates(uiModel: $pinVm.uiModel, showAlert: $showErrorAlert, showSuccessAlert: $showSuccessAlert, onSuccessAction: navigateToCardDetailsView)
        }
        .padding()
        .padding(.top)
        .navigationTitle("Security questions")
        .onAppear {
            questionObjects = Observer<SecurityQuestion>().getEntities()
            questions = questionObjects.map{$0.question}
         
        }
        .onChange(of: answer) { newValue in
            if !newValue.isEmpty && !selectedQuestion.isEmpty {
                buttonBgColor = .green
            } else {
                buttonBgColor = .gray.opacity(0.5)
            }
        }
       
    
    }
    func getQuestionId(question: String) -> String {
        if let id =  questionObjects.first(where: { $0.question == question })?.questionID {
            return id
        }
        return ""
    }
    func navigateToCardDetailsView() {
        navigation.navigationStack.append(.cardDetailsView)
    }
}

struct SecurityQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        SecurityQuestionView(selectedQuestion: .constant("Q"), answer: .constant("A"))
            .environmentObject(NavigationUtils())
    }
}
