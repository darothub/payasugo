//
//  HomeBottomNavView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 18/07/2022.
//

import SwiftUI

struct HomeBottomNavView: View {
    var body: some View {
        GeometryReader { _ in
            TabView {
                HomeView().tabItem {
                    Label("Home", systemImage: "house")
                }
                Text("Bill").tabItem {
                    Label("Bill", systemImage: "menucard")
                }
                Text("Group").tabItem {
                    Label("Group", systemImage: "person.3")
                }
                Text("Explore").tabItem {
                    Label("Explore", systemImage: "airplane.departure")
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct HomeBottomNavView_Previews: PreviewProvider {
    static var previews: some View {
        HomeBottomNavView()
    }
}
