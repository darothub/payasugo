//
//  UtilTestViews.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 26/06/2022.
//

import SwiftUI
import Theme

struct UtilViews: View {
    var theme = PrimaryTheme()
    var backgroundColor = Color.red
    var buttonLabel = "Get started"
    var action = {}
    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                Text(buttonLabel)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(backgroundColor)
                    .cornerRadius(10)
                    .padding(30)
            }
        }
    }
}

struct UtilTestViews_Previews: PreviewProvider {
    static var previews: some View {
        UtilViews()
    }
}

extension UtilViews {
    static func button(backgroundColor:Color = Color.red, buttonLabel:String = "Get started", action:@escaping ()->Void) -> some View {
        Button {
            action()
        } label: {
            Text(buttonLabel)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(backgroundColor)
                .cornerRadius(10)
                .padding(30)
        }
    }
}
