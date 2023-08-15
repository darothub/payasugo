//
//  TermAndConditiomDialogView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 14/08/2023.
//
import Core
import CoreUI
import SwiftUI
import Theme
struct TermAndConditiomDialogView: View {
    @Binding var isPresented: Bool
    @StateObject private var hvm = HomeDI.createHomeViewModel()
    @State private var hasReadTermsAndPolicy = false
    @State private var showWebView = false
    @State private var url: URL = URL(string: "https://www.google.com")!
    @State private var tacVersion = 0
    var activeCountry: CountriesInfoDTO {
        AppStorageManager.getCountry()!
    }

    var body: some View {
        ZStack {
            VStack {
                Text(AppStorageManager.termsAncConditionMessage)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.subheadline)
                TinggButton(backgroundColor: PrimaryTheme.getColor(.primaryColor), buttonLabel: "Read updated terms", padding: 10, textPadding: 10) {
                    url = URL(string: (activeCountry.tacURL)!)!
                    withAnimation {
                        showWebView = true
                    }
                }
                TinggButton(backgroundColor: PrimaryTheme.getColor(.primaryColor), buttonLabel: "Read updated privacy policy", padding: 10, textPadding: 10) {
                    url = URL(string: (activeCountry.privacyPolicyURL)!)!
                    withAnimation {
                        showWebView = true
                    }
                }
                HStack {
                    CheckBoxView(checkboxChecked: $hasReadTermsAndPolicy)
                    Text("I have read and accepted")
                        .font(.subheadline)
                    Spacer()
                }

                TinggOutlineButton(backgroundColor: Color.clear, buttonLabel: "Continue") {
                    if hasReadTermsAndPolicy {
                        let profile = Observer<Profile>().getEntities().first!
                        tacVersion = profile.acceptedTacVersion == 0 ? 1 : profile.acceptedTacVersion!
                        let request = RequestMap.Builder()
                            .add(value: "\(tacVersion)", for: "TAC_VERSION")
                            .add(value: "MTAC", for: .SERVICE)
                            .build()
                        log(message: request)
                        hvm.handleTermsAndConditionAcceptance(request: request)
                    } else {
                        hvm.uiModel = UIModel.error("You must accept the updated terms to proceed!")
                    }
                }
                TinggOutlineButton(backgroundColor: Color.clear, buttonLabel: "Quit app") {
                    exit(0)
                }
            }.padding(30)
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showWebView = false
                        }
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                    })
                }
                WebView(url: url, webViewUIModel: $hvm.uiModel)
            }
            .showIf($showWebView)
        }
        .handleViewStatesMods(uiState: hvm.$uiModel) { content in
            let data = content.data as! BaseDTO
            if data.statusCode == 200 {
                let profile = Observer<Profile>().getEntities().first!
                RealmManager.write {
                    profile.acceptedTacVersion = tacVersion
                }
                AppStorageManager.acceptedTermsAndCondition = true
            }
        } action: {
            withAnimation {
                isPresented = false
            }
        }
    }
}


#Preview {
    TermAndConditiomDialogView(isPresented: .constant(false))
}
