//
//  File.swift
//  
//
//  Created by Abdulrasaq on 30/08/2022.
//

import Foundation
public class MerchantServiceRepositoryImpl: MerchantServiceRepository {
    var dbObserver: Observer<MerchantService>
    /// ``MerchantServiceRepositoryImpl`` Initialiser
    /// - Parameter dbObserver: ``Observer``
    public init(dbObserver: Observer<MerchantService>) {
        self.dbObserver = dbObserver
    }
    public func getServices() -> [MerchantService] {
        dbObserver.getEntities()
    }
}
