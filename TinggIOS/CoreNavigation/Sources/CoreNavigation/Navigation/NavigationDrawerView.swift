//
//  NavigationDrawerView.swift
//  
//
//  Created by Abdulrasaq on 25/04/2023.
//

import Foundation
import SwiftUI

public struct NavigationDrawerView: View {
    var navigationDrawerProtocol: NavigationMenuClick
    private var listOfMenu: [NavigationMenu] = []
    private var width = UIScreen.main.bounds.width
    @State private var header: AnyView =  AnyView(Text("Hello"))
    @Binding private var selectedMenuScreen: Screens
    @Binding private var status: DrawerStatus
    @State private var xOffset: CGFloat = 0
    public init(listOfMenu: [NavigationMenu], header: AnyView, selectedMenuScreen: Binding<Screens>, status: Binding<DrawerStatus>, navigationDrawerProtocol: NavigationMenuClick) {
        self._selectedMenuScreen = selectedMenuScreen
        self._status = status
        self.navigationDrawerProtocol = navigationDrawerProtocol
        self.listOfMenu = listOfMenu
        self._header = State(initialValue: header)
      
    }
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                header
                    .padding(.bottom, 30)
                    .padding(.leading, 25)
                Divider()
                List(0..<listOfMenu.count, id: \.self) { each in
                    let menu = listOfMenu[each]
                    menu
                        .padding(.vertical, 25)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            withAnimation {
                                selectedMenuScreen = menu.getScreen()
                                handleNavigationDrawer()
                                navigationDrawerProtocol.onMenuClick(selectedMenuScreen)
                            }
                            print(menu.getScreen())
                        }
                        .padding(.horizontal, 20)
                        .background(menu.getScreen() == selectedMenuScreen ? .gray.opacity(0.5) : .white)
                        
                    
                }.listStyle(PlainListStyle())
                .padding(.top, 10)
            }.frame(maxWidth: width/1.2, alignment: .leading)
                .background(.white)
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
    
    fileprivate func handleNavigationDrawer() {
        withAnimation(.linear) {
            xOffset =  status == DrawerStatus.close ? -width : 0
        }
    }
}

public enum DrawerStatus {
    case open, close
}

public struct NavigationMenu: View {
    private let screen: Screens
    let title: String
    public init(screen: Screens, title: String) {
        self.screen = screen
        self.title = title
    }
    public var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    public func getScreen() -> Screens {
        return screen
    }
}

struct NavigationDrawerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationDrawerTestView()
    }
}


struct NavigationDrawerTestView: View, NavigationMenuClick {
    func onHeaderClick<S>(_ screen: S) where S : Hashable {
        print("Header clicked \(screen)")
    }
    
    func onMenuClick(_ screen: Screens) {
        print("Menu clicked \(screen)")
    }
    
    @State var selectedScreen = Screens.home
    @State var status = DrawerStatus.close
    var body: some View {
        NavigationDrawerView(listOfMenu: [
            NavigationMenu(screen: .buyAirtime, title: "Payment"),
            NavigationMenu(screen: .intro, title: "Settings"),
            NavigationMenu(screen: .home, title: "Support")
        ], header: AnyView(NavigationHeader(navigationDrawerProtocol: self) ), selectedMenuScreen: $selectedScreen, status: $status, navigationDrawerProtocol: self)
        .onChange(of: selectedScreen) { newValue in
            print("NavigationDrawer \(newValue)")
        }
    }
}
struct NavigationHeader: View {
    var profileImageUrl: String = "https://imglarger.com/Images/before-after/ai-image-enlarger-1-after-2.jpg"
    var userName = "George Mwaura"
    var navigationDrawerProtocol: NavigationMenuClick
    var body: some View {
        HStack {
            Image(systemName: "camera.fill")
                .overlay {
                    Circle().stroke(lineWidth: 2)
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
                        navigationDrawerProtocol.onHeaderClick(Screens.home)
                    }
            }
            .padding(20)
        }
    }
}

public protocol NavigationMenuClick {
    func onMenuClick(_ screen: Screens)
    func onHeaderClick<S>(_ screen: S)  where S : Hashable
}
