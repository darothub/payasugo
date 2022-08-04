//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/07/2022.
//
import Core
import Foundation
//import RealmSwift
public class HomeViewModel: ObservableObject {
    @Published public var categories = Observer<Categorys>().objects
    @Published public var profiles = Observer<Profile>().objects
    @Published public var services = Observer<MerchantService>().objects

    @Published public var processedCategories = [[Categorys]]()
    public init() {
       processedCategories = categories.reversed().reversed().chunked(into: 4)
    }
    public func getProfile() -> Profile {
        guard let profile = profiles.first else {
            fatalError("No profile found")
        }
        return profile
    }
    
    public func getQuickTopups() -> [MerchantService] {
        let airtimes = categories.filter {$0.categoryName == "Airtime"}
        let theAirtimeCategory = airtimes[0]
        return services.filter { $0.categoryID == theAirtimeCategory.categoryID}
    }
}
