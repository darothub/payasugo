//
//  File.swift
//  
//
//  Created by Abdulrasaq on 13/12/2022.
//

import Foundation
import SwiftUI
public struct RealmManagerKey: EnvironmentKey {
    public static let defaultValue: RealmManager = RealmManager()
}

public extension EnvironmentValues {
    var realmManager: RealmManager {
        get { self[RealmManagerKey.self] }
        set { self[RealmManagerKey.self] = newValue }
    }
}

extension View {
    public func realmManager(_ realmManager: RealmManager) -> some View {
        environment(\.realmManager, realmManager)
    }
}
