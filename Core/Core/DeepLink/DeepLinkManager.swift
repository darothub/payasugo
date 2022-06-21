//
//  DeepLinkHandler.swift
//  Core
//
//  Created by Abdulrasaq on 20/06/2022.
//

import Foundation

public class DeepLinkManager {
    public init(){}
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
        else { return .home }
       
        return (url.host?.checkIfItsDeepLinkTarget)!
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
    
    var screenIdentifier: DeepLinkManager.DeeplinkTarget? {
      guard isDeeplink else { return nil }

      switch host {
      case "home": return .home
      case "screen": return .screen
      default: return nil
      }
    }
}
