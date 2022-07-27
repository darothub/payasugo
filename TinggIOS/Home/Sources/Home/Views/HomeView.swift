//
//  HomeView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 14/07/2022.
//

import SwiftUI
import Theme

struct HomeView: View {
    @StateObject var homeViewModel: HomeViewModel = .init()
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 25) {
                    HomeTopViewDesign(geo: geo)
                    ActivateCardView(parentSize: geo) {}
                    ActiveCategoryTabView()
                        .background(.white)
                        .shadow(radius: 0, y: 3)
                        .padding(.top, 10)
                    AddNewBillCardView()
                }.background(
                    RoundedRectangle(cornerRadius: 0)
                        .frame(height: geo.size.height * 0.3)
                        .foregroundColor(.white)
                )
                .environmentObject(homeViewModel)
            }.ignoresSafeArea()
        }
        .background(PrimaryTheme.getColor(.cellulantLightGray))
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
