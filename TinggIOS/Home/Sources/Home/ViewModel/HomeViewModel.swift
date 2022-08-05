//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/07/2022.
//
import Core
import Combine
import Foundation

public class HomeViewModel: ObservableObject {
    @Published public var categories = Observer<Categorys>().objects
    @Published public var profiles = Observer<Profile>().objects
    @Published public var services = Observer<MerchantService>().objects
    @Published public var airTimeServices = [MerchantService]()
    @Published public var profile = Profile()
    @Published public var processedCategories = [[Categorys]]()
    @Published public var subscription = Set<AnyCancellable>()
    public init() {
        processedCategories = categories.reversed().reversed().chunked(into: 4)
        getProfile()
        getQuickTopups()
    }
    public func getProfile() {
        guard let profile = profiles.first else {
            fatalError("No profile found")
        }
        self.profile = profile
    }
    public func getQuickTopups(){
        Future<[MerchantService], Never> { [unowned self] promise in
            let airtimes = categories.filter {$0.categoryName == "Airtime"}
            let theAirtimeCategory = airtimes[0]
            promise(.success(services.filter { $0.categoryID == theAirtimeCategory.categoryID}))
        }
        .assign(to: \.airTimeServices, on: self)
        .store(in: &subscription)
        
        return
    }
}
