//
//  NavigationUtils.swift
//  
//
//  Created by Abdulrasaq on 17/10/2022.
//

import Foundation
import SwiftUI

public typealias NavigationHome = String
public typealias Settings = String
/// An util class for handling navigation stack
public class NavigationManager: NavigationProtocol {
    @Published public private(set) var  navigationStack = NavigationPath()
    private let navigationHome: NavigationHome = "Home"
    private let settings: Settings = "Settings"
    @Published private var homeView: AnyView?
    public static var shared = NavigationManager()
    let queue = DispatchQueue(label: "com.tinggios.concurrentQueue", attributes: .concurrent)

    public init() {
       //
    }
    
    public func navigateTo<S: Hashable>(screen: S) {
        navigationStack.append(screen)
    }
    
    public func goBack() {
        navigationStack.removeLast()
    }
    public func goBackStep(_ steps: Int) {
        navigationStack.removeLast(steps)
    }
    public func getNavigationStack() -> Binding<NavigationPath> {
       return Binding {
            self.navigationStack
        } set: { value in
            self.queue.sync(flags: .barrier) {
                self.navigationStack = value
            }
        }

    }
    public func setHomeView(view: AnyView) {
        homeView = view
    }
    public func getHomeView() -> AnyView {
        guard let view = homeView else {
           return AnyView(Text("Home view not set"))
        }
        return view
    }
    public func goHome() {
        navigationStack.append(navigationHome)
    }
    public func goToSettings() {
        navigationStack.append(settings)
    }
}

public protocol NavigationProtocol: ObservableObject {
    func navigateTo<S: Hashable>(screen: S)
    func goBack()
    func setHomeView(view: AnyView)
    func getHomeView() -> AnyView
    func goHome()
}
