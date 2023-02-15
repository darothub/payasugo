//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 06/02/2023.
//
import Common
import SwiftUI

public struct CardWebView: View {
    @EnvironmentObject var creditCardVm: CreditCardViewModel
    @State public var htmlString = ""
    public init(htmlString: String = "") {
        self._htmlString = State(initialValue: htmlString)
    }
    public var body: some View {
        HTMLView(url: htmlString, webViewUIModel: creditCardVm.uiModel)
    }
    
}

struct CardWebView_Previews: PreviewProvider {
    static var previews: some View {
        CardWebView()
    }
}
