//
//  HomeTopViewDesign.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//
import Core
import RealmSwift
import SwiftUI
import Theme

struct HomeTopViewDesign: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var geo: GeometryProxy
    var body: some View {
        VStack {
            ProfileImageAndHelpIconView(imageUrl: homeViewModel.getProfile().photoURL!)
                .padding(.top, 30)
            Text("Welcome back, \(homeViewModel.getProfile().firstName!)")
                .foregroundColor(.white)
                .font(.system(size: PrimaryTheme.smallTextSize))
            Text("What would you like to do?")
                .foregroundColor(.white)
                .font(.system(size: PrimaryTheme.largeTextSize))
        }
        .environmentObject(homeViewModel)
        .background(
            topBackgroundDesign(
                height: geo.size.height * 0.4,
                color: PrimaryTheme.getColor(.secondaryColor)
            )
        )
    }
}

struct HomeTopViewDesign_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {geo in
            HomeTopViewDesign(geo: geo)
                .environmentObject(HomeViewModel())
        }
    }
}
