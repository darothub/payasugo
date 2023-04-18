//
//  NewView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 28/03/2023.
//

//import SmileIdentity
import Core
import CoreUI
import CreditCard
import SwiftUI

struct NewView: View {
    var body: some View {
        VStack(alignment: .leading) {
            VirtualCardHomeView(balance: "2400000", currency: "N", showManageCardLabel: true)
        }
      
    }
    //                    CaptureIDView().edgesIgnoringSafeArea(.all)
}

struct NewView_Previews: PreviewProvider {
    static var previews: some View {
        NewView()
    }
}
