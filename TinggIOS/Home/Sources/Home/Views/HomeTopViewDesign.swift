//
//  HomeTopViewDesign.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//
import Common
import Core
import SwiftUI
import Theme

struct HomeTopViewDesign: View {
    var parentSize: GeometryProxy
    @EnvironmentObject var hvm: HomeViewModel
    var body: some View {
        VStack {
            ProfileImageAndHelpIconView(imageUrl: hvm.profile.photoURL!)
                .padding(.top, 30)
            Text("Welcome back, \(hvm.profile.firstName!)")
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
            HomeTopViewDesign(parentSize: geo)
                .environmentObject(HomeDI.createHomeViewModel())
        }
    }
}
var previewProfile: Profile {
    let prof = Profile()
    prof.firstName = "Test"
    prof.photoURL = ""
    return prof
}
