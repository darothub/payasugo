//
//  HomeView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 14/07/2022.
//


import Core
import Combine
import SwiftUI
import Theme

struct HomeView: View {
    @EnvironmentObject var hvm: HomeViewModel
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 25) {
                    HomeTopViewDesign(parentSize: geo)
                    ActivateCardView(parentSize: geo) {}
                    ActiveCategoryTabView()
                        .background(.white)
                        .shadow(radius: 0, y: 3)
                        .padding(.top, 10)
                    QuickTopupView()
                }.background(
                    RoundedRectangle(cornerRadius: 0)
                        .frame(height: geo.size.height * 0.3)
                        .foregroundColor(.white)
                )
                .environmentObject(hvm)
            }.ignoresSafeArea()
        }
        .background(PrimaryTheme.getColor(.cellulantLightGray))
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}
