//
//  ViewHouse.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 29/07/2022.
//

import SwiftUI
import Onboarding
import Home
import Core

struct ViewHouse: View {
    @EnvironmentObject var navigation: NavigationUtils
    @StateObject var ovm = OnboardingDI.createOnboardingViewModel()
    @State var navigate = true
    var body: some View {
        IntroView()
            .navigationBarHidden(true)
            .environmentObject(navigation)
            .environmentObject(ovm)
            .accessibility(identifier: "introview")
    }
}

struct ViewHouse_Previews: PreviewProvider {
    static var previews: some View {
        ViewHouse()
    }
}
