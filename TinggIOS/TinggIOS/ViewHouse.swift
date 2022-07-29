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
    @State var navigate = true
    var body: some View {
        NavigationLink(destination: destination, isActive: $navigate) {
            IntroView()
                .environmentObject(navigation)
        }
    }
    @ViewBuilder
    var destination: some View {
        switch navigation.rooms {
        case .phone:
            PhoneNumberValidationView()
        case .home:
            HomeBottomNavView()
        case .intro:
            IntroView()
                .environmentObject(navigation)
        }
    }
}

struct ViewHouse_Previews: PreviewProvider {
    static var previews: some View {
        ViewHouse()
    }
}
