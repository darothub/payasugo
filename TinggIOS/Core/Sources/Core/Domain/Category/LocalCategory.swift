//
//  File.swift
//  
//
//  Created by Abdulrasaq on 27/07/2022.
//

import SwiftUI
import Core
public class LocalCategory: ObservableObject {
    @Published var realmManager: RealmManager
    public init(realmManager: RealmManager) {
        self.realmManager = realmManager
    }
}
