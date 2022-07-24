//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/07/2022.
//
import Core
import Foundation
import RealmSwift
class HomeViewModel: ObservableObject {
    @ObservedResults(Categorys.self, where: {$0.activeStatus == "1"}) private var categories
    @ObservedResults(Profile.self) private var profiles
    @Published var processedCategories = [[Categorys]]()
    init() {
       processedCategories = categories.reversed().reversed().chunked(into: 4)
    }
    
    func getProfile() -> Profile {
        guard let profile = profiles.first else {
            fatalError("No profile found")
        }
        return profile
    }
}
