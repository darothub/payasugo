//
//  HomeView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 14/07/2022.
//

import SwiftUI
import Core
import Theme

struct HomeView: View {
    @State var profile: Profile = .init()
    @State var processedCategories:[[Categorys]] = [[]]
    @State var quickTopups: [MerchantService] = .init()
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 25) {
                    HomeTopViewDesign(parentSize: geo, profile: profile)
                    ActivateCardView(parentSize: geo) {}
                    ActiveCategoryTabView(processedCategories: processedCategories)
                        .background(.white)
                        .shadow(radius: 0, y: 3)
                        .padding(.top, 10)
                    QuickTopupView(listOfServices: quickTopups)
                }.background(
                    RoundedRectangle(cornerRadius: 0)
                        .frame(height: geo.size.height * 0.3)
                        .foregroundColor(.white)
                )
            }.ignoresSafeArea()
        }
        .background(PrimaryTheme.getColor(.cellulantLightGray))
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(profile: previewProfile, processedCategories: previewProcessedCategories, quickTopups: services)
    }
}
