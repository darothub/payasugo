//
//  HomeView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 14/07/2022.
//

import SwiftUI
import Theme

struct HomeView: View {
    @StateObject var themeUtils: EnvironmentUtils = .init()
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 25) {
                    HomeTopViewDesign(geo: geo)
                    ActivateCardView(theme: themeUtils.primaryTheme, parentSize: geo) {}
                        .padding(.top, 30)
                    ActiveCategoryTabView()
                        .background(.white)
                        .shadow(radius: 5, y: 5)
                        .padding(.top, 10)
                    AddNewBillCardView()
                }
            }.ignoresSafeArea()
        }
        .background(themeUtils.primaryTheme.lightGray)
        .navigationBarHidden(true)
        .environmentObject(themeUtils)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(themeUtils: EnvironmentUtils())
    }
}
