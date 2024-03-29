//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 04/08/2022.
//

import SwiftUI
import Theme
/// Displays a verification advice to the user
struct VerificationCodeAdviceTextView: View {
    var body: some View {
        Text("We'll send verification code to this number")
            .frame(maxWidth: .infinity, alignment: .leading)
            .bold()
            .font(.system(size: PrimaryTheme.smallTextSize))
            .foregroundColor(PrimaryTheme.getColor(.tinggblack))
    }
}

struct VerificationCodeAdviceTextView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCodeAdviceTextView()
    }
}
