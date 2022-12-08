//
//  HomeBottomNavView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 18/07/2022.
//

import SwiftUI
import Core
import Theme

/// View that host the bottom navigation for the home package
public struct HomeBottomNavView: View {
    @StateObject var hvm: HomeViewModel = HomeDI.createHomeViewModel()
    @State var showBottomSheet = true
    let heights = stride(from: 0.1, through: 1.0, by: 0.1).map { PresentationDetent.fraction($0) }

    public init() {
        // Intentionally unimplemented...modular accessibility
    }
    public var body: some View {
        GeometryReader { _ in
            TabView {
                homeView()
                    .tabItemStyle(
                        title: "Home",
                        image: Image(systemName: "house.fill")
                    )
                billView()
                    .tabItemStyle(
                        title: "Bill",
                        image:PrimaryTheme.getImage(image: .bill)
                    )
                
                Text("Group")
                    .tabItemStyle(
                        title: "Group",
                        image: PrimaryTheme.getImage(image: .group)
                    )
                Text("Explore")
                    .tabItemStyle(
                        title: "Explore",
                        image: PrimaryTheme.getImage(image: .explore)
                    )
            }
            .sheet(isPresented: $showBottomSheet) {
                Text("This app was brought to you by Hacking with Swift")
                    .presentationDetents([.medium, .large])
            }
            
        }.navigationBarBackButtonHidden(true)
      
    }
    @ViewBuilder
    func homeView() -> some View {
        VStack{
            HomeView()
                .environmentObject(hvm)
            Spacer()
        }
    }
    @ViewBuilder
    func billView() -> some View {
        BillView()
            .environmentObject(hvm)
    }
}

struct HomeBottomNavView_Previews: PreviewProvider {
    struct HBNPReviewHolder: View {
        public var body: some View {
            HomeBottomNavView()
        }
    }
    static var previews: some View {
        Text("Hello")
    }
}
