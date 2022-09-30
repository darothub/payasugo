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
    @StateObject var hvm: HomeViewModel = HomeDI.createHomeViewModel()
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
        }.navigationBarBackButtonHidden(true)
        .sheet(isPresented: $hvm.gotoAllRechargesView) {
               AllRechargeUIView()
        }
        .sheet(isPresented: $hvm.buyAirtime) {
            BuyAirtimeView()
        }
        
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
