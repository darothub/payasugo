//
//  FreshchatWrapper.swift
//  
//
//  Created by Abdulrasaq on 03/07/2023.
//

import Foundation
import FreshchatSDK

public class FreshchatWrapper: ObservableObject {
    @Published var isFreshchatVisible = false

    public init() {
        Freshchat.sharedInstance().setUser(self.createFreshchatUser())
    }

    private func createFreshchatUser() -> FreshchatUser {
        let freshchatUser = FreshchatUser.sharedInstance()
        return freshchatUser
    }

    public func showFreshchat() {
        Freshchat.sharedInstance().showConversations(self.topViewController()!)
    }

    private func topViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        guard let window = windowScene?.windows.first(where: { $0.isKeyWindow }) else { return nil }
        guard var topViewController = window.rootViewController else { return nil }

        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }

        return topViewController
    }
}
