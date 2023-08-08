//
//  NavigationDrawerView.swift
//  
//
//  Created by Abdulrasaq on 25/04/2023.
//

import Foundation
import SwiftUI

public struct NavigationDrawerView<S>: View where S: Hashable {
    @Environment(\.colorScheme) var colorScheme
    private var width = UIScreen.main.bounds.width
    var navigationDrawerProtocol: NavigationMenuClick
    private var listOfMenu = [NavigationDrawerMenuItem<S>]()
    @Binding private var selectedMenuScreen: S
    @Binding private var status: DrawerStatus
    @Binding private var backgroundColor: Color
    @State private var xOffset: CGFloat = 0
    var grayColor: Color {
        colorScheme == .dark ? .gray : .gray
    }
    var whiteColor: Color {
        colorScheme == .dark ? .white : .white
    }
    private var headerItem: HeaderItem<S>
    public init(
        headerItem: HeaderItem<S>,
        listOfMenu: [NavigationDrawerMenuItem<S>],
        selectedMenuScreen: Binding<S>,
        status: Binding<DrawerStatus>,
        backgroundColor: Binding<Color>,
        navigationDrawerProtocol: NavigationMenuClick
    ) {
        self._selectedMenuScreen = selectedMenuScreen
        self._status = status
        self._backgroundColor = backgroundColor
        self.navigationDrawerProtocol = navigationDrawerProtocol
        self.listOfMenu = listOfMenu
        self.headerItem = headerItem
    }
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                NavigationDrawerHeader<S>(headerItem: headerItem, navigationDrawerProtocol: navigationDrawerProtocol)
                    .padding(.bottom, 30)
                    .padding(.leading, 25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                   
                Divider()
                getListOfMenu()
            }.frame(maxWidth: width/1.2, alignment: .leading)
                .background(backgroundColor)
            Spacer()
        }
        .offset(x: xOffset)
        .onChange(of: status) { newValue in
            handleNavigationDrawer()
        }
        .onAppear {
            xOffset = -width
        }
    }
    @ViewBuilder
    fileprivate func getListOfMenu() -> some View {
        List(0..<listOfMenu.count, id: \.self) { each in
            let menu = listOfMenu[each]
            NavigationDrawerMenu(item: menu)
                .padding(.vertical, 15)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(whiteColor)
                .padding(.horizontal, 20)
                .background(menu.screen == selectedMenuScreen ? grayColor.opacity(0.2) : whiteColor)
                .onTapGesture {
                    withAnimation {
                        selectedMenuScreen = menu.screen
                        handleNavigationDrawer()
                        navigationDrawerProtocol.onMenuClick(selectedMenuScreen)
                    }
                }
        }.listStyle(PlainListStyle())
        .padding(.top, 10)
    }
    
    fileprivate func handleNavigationDrawer() {
        withAnimation(.linear) {
            xOffset =  status == DrawerStatus.close ? -width : 0
        }
    }
}

public enum DrawerStatus {
    case open, close
}

public struct NavigationDrawerMenu<S>: View where S: Hashable {
    @State public var item: NavigationDrawerMenuItem<S>
    public init(item: NavigationDrawerMenuItem<S>) {
        self._item = State(initialValue: item)
    }
    public var body: some View {
        VStack {
            Text(item.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(item.textColor)
                .font(.caption)
        } .frame(maxWidth: .infinity, alignment: .leading)
    }
    public func getScreen() -> S {
        return item.screen
    }
}


public struct NavigationDrawerMenuItem<S> where S: Hashable {
    public let screen: S
    public let title: String
    public let textColor: Color
    public init(screen: S, title: String, textColor: Color = .black) {
        self.screen = screen
        self.title = title
        self.textColor = textColor
    }
}
struct NavigationDrawerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationDrawerTestView<Screens>()
    }
}


struct NavigationDrawerTestView<S>: View, NavigationMenuClick where S: Hashable {
    func onMenuClick<S>(_ screen: S) where S : Hashable {
        print("Menu clicked \(screen)")
    }
    
    func onHeaderClick<S>(_ screen: S) where S : Hashable {
        print("Header clicked \(screen)")
    }
    
    func onMenuClick(_ screen: Screens) {
        print("Menu clicked \(screen)")
    }
    
    @State var selectedScreen = Screens.home
    @State var status = DrawerStatus.close
    var body: some View {
        NavigationDrawerView<Screens>(headerItem: HeaderItem(destination: Screens.home), listOfMenu: [
            NavigationDrawerMenuItem(screen: Screens.buyAirtime("Airtel"), title: "Payment"),
            NavigationDrawerMenuItem(screen: Screens.intro, title: "Settings"),
            NavigationDrawerMenuItem(screen: Screens.home, title: "Support")
        ], selectedMenuScreen: $selectedScreen, status: $status,
            backgroundColor: .constant(.white),
            navigationDrawerProtocol: self
        )
        .onChange(of: selectedScreen) { newValue in
            print("NavigationDrawer \(newValue)")
        }
    }
}
struct NavigationDrawerHeader<S>: View where S: Hashable {
    var headerItem: HeaderItem = HeaderItem(destination: Screens.home as! S)
    var navigationDrawerProtocol: NavigationMenuClick
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: headerItem.profileImageUrl)) { image in
                image.resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person.fill")
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())

            }.scaleEffect(1.2)
       
            VStack(alignment: .leading) {
                Text(headerItem.name)
                    .textCase(.uppercase)
                    .foregroundColor(headerItem.nameColor)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .bold()
                Text("View profile")
                    .foregroundColor(headerItem.linkColor)
                    .font(.subheadline)
                    .onTapGesture {
                        navigationDrawerProtocol.onHeaderClick(headerItem.destination)
                    }
            }
            .padding(20)
        }
    }
}
public struct HeaderItem<S> where S: Hashable  {
    public var profileImageUrl: String
    public var name: String
    public var nameColor: Color
    public var linkColor: Color
    public var destination: S
    public init(
        profileImageUrl: String = "https://imglarger.com/Images/before-after/ai-image-enlarger-1-after-2.jpg",
        name: String = "George Mwaura",
        nameColor: Color = .black,
        linkColor: Color = .green,
        destination: S = Screens.home
                
    ) {
        self.profileImageUrl = profileImageUrl
        self.name = name
        self.nameColor = nameColor
        self.linkColor = linkColor
        self.destination = destination
    }
}

public protocol NavigationMenuClick {
    func onMenuClick<S>(_ screen: S) where S : Hashable
    func onHeaderClick<S>(_ screen: S)  where S : Hashable
}
