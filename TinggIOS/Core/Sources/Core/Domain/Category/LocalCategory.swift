//
//  File.swift
//  
//
//  Created by Abdulrasaq on 27/07/2022.
//

import SwiftUI
public class LocalCategory: ObservableObject {
    @Published var realmManager: RealmManager
    public init(realmManager: RealmManager) {
        self.realmManager = realmManager
    }
}
