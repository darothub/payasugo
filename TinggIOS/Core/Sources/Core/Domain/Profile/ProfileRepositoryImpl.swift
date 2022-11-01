//
//  File.swift
//  
//
//  Created by Abdulrasaq on 30/08/2022.
//

import Foundation
public class ProfileRepositoryImpl: ProfileRepository {
    var dbObserver: Observer<Profile>
    /// ``ProfileRepositoryImpl`` initialiser
    /// - Parameter dbObserver: ``Observer``
    public init(dbObserver: Observer<Profile>) {
        self.dbObserver = dbObserver
    }
    ///  Get user profile details
    /// - Returns: ``Profile``
    public func getProfile() -> Profile? {
        return dbObserver.getEntities().first
    }
}
