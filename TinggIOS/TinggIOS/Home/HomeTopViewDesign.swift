//
//  HomeTopViewDesign.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//

import SwiftUI
import Theme
struct HomeTopViewDesign: View {
    @EnvironmentObject var themeUtils: EnvironmentUtils
    var geo: GeometryProxy
    var body: some View {
        VStack {
            ProfileImageAndHelpIconView()
                .padding(.top, 30)
            Text("Welcome back, user")
                .foregroundColor(.white)
                .font(.system(size: themeUtils.primaryTheme.smallTextSize))
            Text("What would you like to do?")
                .foregroundColor(.white)
                .font(.system(size: themeUtils.primaryTheme.largeTextSize))
        }
        .background(
            UtilViews.topBackgroundDesign(height: geo.size.height * 0.4,
                color: themeUtils.primaryTheme.secondaryColor)
        )

    }
}

struct HomeTopViewDesign_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {geo in
            HomeTopViewDesign(geo: geo)
                .environmentObject(EnvironmentUtils())
        }
    }
}
