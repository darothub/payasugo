//
//  NewView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 28/03/2023.
//

//import SmileIdentity

import CoreUI
import CreditCard
import SwiftUI

struct NewView: View {
    var body: some View {
        VStack {
            VirtualCardActionView(name: "Paul")
        }
    }
    //                    CaptureIDView().edgesIgnoringSafeArea(.all)
}




struct NewView_Previews: PreviewProvider {
    static var previews: some View {
        NewView()
    }
}
