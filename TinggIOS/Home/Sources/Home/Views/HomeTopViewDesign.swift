//
//  HomeTopViewDesign.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//
import Core
import SwiftUI
import Theme

struct HomeTopViewDesign: View {
    var parentSize: GeometryProxy
    @State var profile: Profile = .init()
    var body: some View {
        VStack {
            ProfileImageAndHelpIconView(imageUrl: profile.photoURL!)
                .padding(.top, 30)
            Text("Welcome back, \(profile.firstName!)")
                .foregroundColor(.white)
                .font(.system(size: PrimaryTheme.smallTextSize))
            Text("What would you like to do?")
                .foregroundColor(.white)
                .font(.system(size: PrimaryTheme.largeTextSize))
        }
        .background(
            topBackgroundDesign(
                height: parentSize.size.height * 0.4,
                color: PrimaryTheme.getColor(.secondaryColor)
            )
        )
    }
}

struct HomeTopViewDesign_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            HomeTopViewDesign(parentSize: geo, profile: previewProfile)
        }
    }
}
var previewProfile: Profile {
    let prof = Profile()
    prof.firstName = "Test"
    prof.photoURL = ""
    return prof
}
