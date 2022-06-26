//
//  DeepLinkHandler.swift
//  Core
//
//  Created by Abdulrasaq on 20/06/2022.
//
// swiftlint:disable all
import Foundation

public class DeepLinkManager: ObservableObject {
    @Published public var target: DeeplinkTarget = .home
    public init() {}
    public enum DeeplinkTarget: String, Equatable {
        case home
        case screen
        case checkout
    }
    public class DeepLinkConstants {
        static let scheme = "tinggios"
    }
    public func manage(url: URL) -> DeeplinkTarget {
        guard url.scheme == DeepLinkConstants.scheme
        else {
            return target
        }
        target = (url.host?.checkIfItsDeepLinkTarget)!
        return target
    }
}

extension String {
    var checkIfItsDeepLinkTarget : DeepLinkManager.DeeplinkTarget? {
        guard let target = DeepLinkManager.DeeplinkTarget.init(rawValue: self) else {
            return DeepLinkManager.DeeplinkTarget.home
        }
        return target
    }
}

extension URL {
    var isDeeplink: Bool {
        return scheme == DeepLinkManager.DeepLinkConstants.scheme
    }
}
