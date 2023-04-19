//
//  VerificationPendingStateView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 18/04/2023.
//

import Foundation
import SwiftUI
import CoreUI
public struct VerificationPendingStateView: View {
    var name:String = ""
    public init(name: String) {
        self.name = name
    }
    public var body: some View {
        VStack {
            PendingImage(size: CGSize(width: 800, height: 800))
            VStack(alignment: .leading) {
                Text("Hello 🎉 \(name)")
                Text("We are still processing your documents, we will send you a notification once you're verified")
                    .padding(.top)
                    .font(.title2)
            }
        }.padding()
    }
    
    fileprivate func PendingImage(size: CGSize) -> some View {
        let url = Bundle.main.url(forResource: "pendingstateicon", withExtension: "gif")!
        return GifImage(url)
            .frame(width: size.width * 0.6, height: size.height * 0.6, alignment: .center)
    }
}
