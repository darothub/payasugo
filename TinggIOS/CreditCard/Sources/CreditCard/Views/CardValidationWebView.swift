//
//  CardValidationWebView.swift
//
//
//  Created by Abdulrasaq on 05/08/2023.
//
import CoreUI
import SwiftUI

struct CardValidationWebView: View {
    @EnvironmentObject var creditCardVm: CreditCardViewModel
    @State private var htmlString = ""
    var body: some View {
        VStack {
            Text("Coming soon")
        }
//        HTMLView(
//            url: htmlString,
//            webViewUIModel: creditCardVm.uiModel,
//            didFinish: { url in
//                handleWebViewFinishEvent(url: url)
//            }, onTryAgain: {
//                submitCardDetails()
//            }
//        ).showIf($showWebView)
    }
}

#Preview {
    CardValidationWebView()
}
