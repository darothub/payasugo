//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 04/08/2022.
//

import SwiftUI
import Theme
struct MobileNumberView: View {
    var body: some View {
        Text("Mobile Number")
            .bold()
            .foregroundColor(PrimaryTheme.getColor(.tinggblack))
            .font(.system(size: PrimaryTheme.smallTextSize))
            .padding(.leading, PrimaryTheme.largePadding)
            .accessibility(identifier: "mobilenumber")
    }
}

struct MobileNumberView_Previews: PreviewProvider {
    static var previews: some View {
        MobileNumberView()
    }
}
