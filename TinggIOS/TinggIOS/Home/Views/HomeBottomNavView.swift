//
//  HomeBottomNavView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 18/07/2022.
//

import Bills
import SwiftUI
import Core
import CoreUI
import CoreNavigation
import Theme
import FreshChat
import Checkout
import Permissions

/// View that host the bottom navigation for the home package
public struct HomeBottomNavView: View, NavigationMenuClick {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var  hvm: HomeViewModel
    @EnvironmentObject var checkout: CheckoutViewModel
    @EnvironmentObject var contactViewModel: ContactViewModel
    @EnvironmentObject private var freshchatWrapper: FreshchatWrapper
    public static var HOME = "Home"
    public static var BILL = "Bill"
    public static var GROUP = "Group"
    public static var CARDS = "Cards"
    @State var colorTint:Color = .blue
    @State var profileImage = ""
    @State var name = ""
    @State var selectedNavigationScreen = HomeScreen.home("", Tab.first)
    @State var drawerStatus = DrawerStatus.close
    @State private var selectedTab: String = ""
    @State private var showTermsAndPrivacyPolicyDialog = false
    let menu =  [
        NavigationDrawerMenuItem(screen: HomeScreen.paymentOptions, title: "Payment"),
        NavigationDrawerMenuItem(screen: HomeScreen.settings, title: "Settings"),
        NavigationDrawerMenuItem(screen: HomeScreen.support, title: "Support"),
        NavigationDrawerMenuItem(screen: HomeScreen.about, title: "About")
    ]
    var headerItem: HeaderItem<HomeScreen> {
        HeaderItem(
            profileImageUrl: profileImage,
            name: name,
            destination: HomeScreen.profile
        )
    }
    @State private var billViewTab: Tab = .second
    public init(selectedTab: String = HomeBottomNavView.HOME, billViewTab: Tab = .second) {
        self._selectedTab = State(initialValue: selectedTab)
        self._billViewTab = State(initialValue: billViewTab)
    }
    public var body: some View {
        GeometryReader { _ in
            TabView(selection: $selectedTab) {
                homeView()
                    .backgroundmode(color: .white)
                    .tabItemStyle(
                        title: HomeBottomNavView.HOME,
                        image: Image(systemName: "house.fill")
                    ).tag(HomeBottomNavView.HOME)
                    
                BillView(selectedTab: billViewTab)
                    .backgroundmode(color: .gray)
                    .tabItemStyle(
                        title: HomeBottomNavView.BILL,
                        image:PrimaryTheme.getImage(image: .bill)
                    ).tag(HomeBottomNavView.BILL)
                
                Text(HomeBottomNavView.GROUP)
                    .backgroundmode(color: .gray)
                    .tabItemStyle(
                        title: HomeBottomNavView.GROUP,
                        image: PrimaryTheme.getImage(image: .group)
                    ).tag(HomeBottomNavView.GROUP)
                Text(HomeBottomNavView.CARDS)
                    .backgroundmode(color: .gray)
                    .tabItemStyle(
                        title: HomeBottomNavView.CARDS,
                        image: Image(systemName: "creditcard")
                    ).tag(HomeBottomNavView.CARDS)
            }
            .overlay {
              
                NavigationDrawerView<HomeScreen>(
                    headerItem: headerItem,
                    listOfMenu: menu,
                    selectedMenuScreen: $selectedNavigationScreen,
                    status: $drawerStatus,
                    backgroundColor: .constant(.white),
                    navigationDrawerProtocol: self
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            showTermsAndPrivacyPolicyDialog = !AppStorageManager.acceptedTermsAndCondition
            Task {
                let profile = hvm.getProfile()
                profileImage = (profile.photoURL)!
                name = "\(String(describing: profile.firstName ?? "")) \(String(describing: profile.lastName ?? ""))"
            }
            let _ = AppScheduler.Builder()
                .setTimeInterval(time: SystemUpdateUsecase.FSU_REFRESH_TIME)
                .setRequest {
                    await hvm.fetchSystemUpdate()
                }
                .build()
                .startScheduledRequest()
        }
        .customDialog(isPresented: $showTermsAndPrivacyPolicyDialog, cancelOnTouchOutside: .constant(false)) {
            TermAndConditiomDialogView(isPresented: $showTermsAndPrivacyPolicyDialog)
        }
    }
    @ViewBuilder
    func homeView() -> some View {
        VStack{
            HomeView(drawerStatus: $drawerStatus)
                .environmentObject(checkout)
                .environmentObject(hvm)
                .environmentObject(freshchatWrapper)
                .environmentObject(contactViewModel)
                .environmentObject(navigation)
                
            Spacer()
        }
    }
    fileprivate func handleNavigationDrawer() {
        drawerStatus = .close
    }
    public func onMenuClick<S>(_ screen: S) where S : Hashable {
        drawerStatus = .close
        navigation.navigateTo(screen: screen)
    }
    public func onHeaderClick<S>(_ screen: S) where S : Hashable {
        drawerStatus = .close
        navigation.navigateTo(screen: screen)
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
            .environmentObject(HomeDI.createHomeViewModel())
            .environmentObject(NavigationManager())
            .environmentObject(FreshchatWrapper())
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

