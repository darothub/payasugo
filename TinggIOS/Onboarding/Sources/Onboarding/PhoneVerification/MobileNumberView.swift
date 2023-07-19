//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 04/08/2022.
//

import SwiftUI
import Theme
/// A mobile number title text view
struct MobileNumberView: View {
    var body: some View {
        Text("Mobile Number")
            .frame(maxWidth: .infinity, alignment: .leading)
            .bold()
            .foregroundColor(PrimaryTheme.getColor(.tinggblack))
            .font(.system(size: PrimaryTheme.smallTextSize))
            
            .accessibility(identifier: "mobilenumber")
    }
}

struct MobileNumberView_Previews: PreviewProvider {
    static var previews: some View {
        MobileNumberView()
    }
}
