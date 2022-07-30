//
//  HomeBottomNavView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 18/07/2022.
//

import SwiftUI
import Core
import Theme
public struct HomeBottomNavView: View {
    @Binding var profile: Profile
    @Binding var processedCategories: [[Categorys]]
    @Binding var quickTopups: [MerchantService]
    public init(profile: Binding<Profile>, categories: Binding<[[Categorys]]>, quickTopups: Binding<[MerchantService]>) {
        _profile = profile
        _processedCategories = categories
        _quickTopups = quickTopups
    }
    public var body: some View {
        GeometryReader { _ in
            TabView {
                HomeView(profile: profile, processedCategories: processedCategories, quickTopups: quickTopups)
                    .tabItem {
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
    struct HBNPReviewHolder : View {
        @State var profile: Profile = previewProfile
        @State var processedCategories:[[Categorys]] = previewProcessedCategories
        @State var quickTopups: [MerchantService] = services
        public var body: some View {
            HomeBottomNavView(profile: $profile, categories: $processedCategories, quickTopups: $quickTopups)
        }
    }
    static var previews: some View {
        HBNPReviewHolder()
    }
}
