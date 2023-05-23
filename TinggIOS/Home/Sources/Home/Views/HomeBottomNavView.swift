//
//  HomeBottomNavView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 18/07/2022.
//

import SwiftUI
import Core
import CoreUI
import CoreNavigation
import Theme

/// View that host the bottom navigation for the home package
public struct HomeBottomNavView: View, NavigationMenuClick {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var hvm: HomeViewModel = HomeDI.createHomeViewModel()
    @EnvironmentObject var navigation: NavigationUtils
    
    let heights = stride(from: 0.1, through: 1.0, by: 0.1).map { PresentationDetent.fraction($0) }

    var profileImageURL : String {
        hvm.getProfile()?.photoURL ?? ""
    }
    var name : String {
        "\(String(describing: hvm.getProfile()?.firstName ?? "")) \(String(describing: hvm.getProfile()?.lastName ?? ""))"
    }
    @State var selectedNavigationScreen = HomeScreen.none
    @State var drawerStatus = DrawerStatus.close
    @State private var showBottomSheet = true
    public init() {
        // Intentionally unimplemented...modular accessibility
    }
    public var body: some View {
        GeometryReader { _ in
            TabView {
                homeView()
                    .backgroundmode(color: .white)
                    .onTapGesture {
                        drawerStatus = .open
                    }
                    .tabItemStyle(
                        title: "Home",
                        image: Image(systemName: "house.fill")
                    )
                billView()
                    .backgroundmode(color: .gray)
                    .tabItemStyle(
                        title: "Bill",
                        image:PrimaryTheme.getImage(image: .bill)
                    )
                
                Text("Group")
                    .backgroundmode(color: .gray)
                    .tabItemStyle(
                        title: "Group",
                        image: PrimaryTheme.getImage(image: .group)
                    )
                Text("Cards")
                    .backgroundmode(color: .gray)
                    .tabItemStyle(
                        title: "Cards",
                        image: Image(systemName: "creditcard")
                    )
            }
        }
     
        .navigationDestination(for: HomeScreen.self, destination: { screen in
            switch screen {
            case .profile:
                EditProfileView()
            case .paymentOptions:
                PaymentOptionsView()
            case .settings:
                SettingsView()
            case .support:
                SupportView()
            case .about:
                AboutView()
            default:
                HomeView(drawerStatus: $drawerStatus)
            }
        })
        .overlay {
            let headerItem = HeaderItem(
                profileImageUrl: profileImageURL,
                name: name,
                destination: HomeScreen.profile
            )
            let menu =  [
                NavigationDrawerMenuItem(screen: HomeScreen.paymentOptions, title: "Payment"),
                NavigationDrawerMenuItem(screen: HomeScreen.settings, title: "Settings"),
                NavigationDrawerMenuItem(screen: HomeScreen.support, title: "Support"),
                NavigationDrawerMenuItem(screen: HomeScreen.about, title: "About")
            ]
            NavigationDrawerView<HomeScreen>(
                headerItem: headerItem,
                listOfMenu: menu,
                selectedMenuScreen: $selectedNavigationScreen,
                status: $drawerStatus,
                backgroundColor: .constant(.white),
                navigationDrawerProtocol: self
            )
        }
        .navigationBarBackButtonHidden(true)
    }
    @ViewBuilder
    func homeView() -> some View {
        VStack{
            HomeView(drawerStatus: $drawerStatus)
                .environmentObject(hvm)
            Spacer()
        }
    }
    @ViewBuilder
    func billView() -> some View {
        BillView()
            .environmentObject(hvm)
    }
    fileprivate func handleNavigationDrawer() {
        drawerStatus = .close
    }
    public func onMenuClick(_ screen: Screens) {
        drawerStatus = .close
        navigation.navigationStack.append(screen)
    }
    public func onMenuClick<S>(_ screen: S) where S : Hashable {
        drawerStatus = .close
        navigation.navigationStack.append(screen)
    }
    public func onHeaderClick<S>(_ screen: S) where S : Hashable {
        drawerStatus = .close
        navigation.navigationStack.append(screen)
    }
}

struct HomeBottomNavView_Previews: PreviewProvider {
    struct HBNPReviewHolder: View {
        public var body: some View {
            HomeBottomNavView()
        }
    }
    static var previews: some View {
        HBNPReviewHolder()
    }
}

struct NavigationHeader: View {
    var profileImageUrl: String = "https://imglarger.com/Images/before-after/ai-image-enlarger-1-after-2.jpg"
    var userName = "George Mwaura"
    var navigationDrawerProtocol: NavigationMenuClick
    var body: some View {
        HStack {
            IconImageCardView(imageUrl: profileImageUrl, radius: 0, scaleEffect: 1.8, x: 0, y: 0, bgShape: .circular)
                .overlay {
                    Circle().stroke(lineWidth: 2)
                        .foregroundColor(.green)
                }.scaleEffect(1.2)
       
            VStack(alignment: .leading) {
                Text(userName)
                    .textCase(.uppercase)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .bold()
                Text("View profile")
                    .foregroundColor(.green)
                    .font(.subheadline)
                    .onTapGesture {
                        navigationDrawerProtocol.onHeaderClick(HomeScreen.profile)
                    }
            }
            .padding(20)
        }
    }
}

