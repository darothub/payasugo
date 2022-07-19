//
//  HomeBottomNavView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 18/07/2022.
//

import SwiftUI
import Theme
struct HomeBottomNavView: View {
    var body: some View {
        GeometryReader { _ in
            TabView {
                HomeView().tabItem {
                    Label {
                        Text("Home")
                    } icon: {
                        PrimaryTheme.getImage(image: .home)
                            .renderingMode(.template)
                            .foregroundColor(PrimaryTheme.getColor(.cellulantRed))
                    }
                }
                Text("Bill").tabItem {
                    Label {
                        Text("Bill")
                    } icon: {
                        PrimaryTheme.getImage(image: .bill)
                            .renderingMode(.template)
                            .foregroundColor(PrimaryTheme.getColor(.cellulantRed))
                    }

                }
                Text("Group").tabItem {
                    Label {
                        Text("Group")
                    } icon: {
                        PrimaryTheme.getImage(image: .group)
                    }
                }
                Text("Explore").tabItem {
                    Label {
                        Text("Explore")
                    } icon: {
                        PrimaryTheme.getImage(image: .explore)
                            .renderingMode(.template)
                            .foregroundColor(PrimaryTheme.getColor(.cellulantRed))
                    }
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
